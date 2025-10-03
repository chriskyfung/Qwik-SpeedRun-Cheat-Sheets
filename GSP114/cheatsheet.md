# GSP114 Continuous Delivery Pipelines with Spinnaker and Kubernetes Engine

Last modified: 2020-04-19

## Set up your environment

```bash
gcloud config set compute/zone us-central1-f

gcloud container clusters create spinnaker-tutorial \
    --machine-type=n1-standard-2
```

#### Configure identity and access management

```bash
# Create the service account

gcloud iam service-accounts create spinnaker-account \
    --display-name spinnaker-account

# Store the service account email address and your current project ID in environment variables for use in later commands

export SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:spinnaker-account" \
    --format='value(email)')

export PROJECT=$(gcloud info --format='value(config.project)')

# Bind the storage.admin role to your service account

gcloud projects add-iam-policy-binding $PROJECT \
    --role roles/storage.admin \
    --member serviceAccount:$SA_EMAIL

# Download the service account key. In a later step, you will install Spinnaker and upload this key to Kubernetes Engine:

gcloud iam service-accounts keys create spinnaker-sa.json \
     --iam-account $SA_EMAIL
```

## Set up Cloud Pub/Sub to trigger Spinnaker pipelines

```bash
# Create the Cloud Pub/Sub topic for notifications from Container Registry.

gcloud pubsub topics create projects/$PROJECT/topics/gcr

# Create a subscription that Spinnaker can read from to receive notifications of images being pushed.

gcloud pubsub subscriptions create gcr-triggers \
    --topic projects/${PROJECT}/topics/gcr

# Give Spinnaker's service account permissions to read from the gcr-triggers subscription.

export SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:spinnaker-account" \
    --format='value(email)')

gcloud beta pubsub subscriptions add-iam-policy-binding gcr-triggers \
    --role roles/pubsub.subscriber --member serviceAccount:$SA_EMAIL
```

**Test Completed Task**

_Set up your environment_

## Deploying Spinnaker using Helm

```bash
# Download and install the helm binary:

wget https://get.helm.sh/helm-v3.1.0-linux-amd64.tar.gz
Unzip the file to your local system:

tar zxfv helm-v3.1.0-linux-amd64.tar.gz

cp linux-amd64/helm .

# Grant Helm the cluster-admin role in your cluster

kubectl create clusterrolebinding user-admin-binding \
    --clusterrole=cluster-admin --user=$(gcloud config get-value account)

# Grant Spinnaker the cluster-admin role so it can deploy resources across all namespaces

kubectl create clusterrolebinding --clusterrole=cluster-admin \
    --serviceaccount=default:default spinnaker-admin

# Add the stable charts deployments to Helm's usable repositories (includes Spinnaker)

./helm repo add stable https://kubernetes-charts.storage.googleapis.com
./helm repo update
```

#### Configure Spinnaker

```bash
# Still in Cloud Shell, create a bucket for Spinnaker to store its pipeline configuration:

export PROJECT=$(gcloud info \
    --format='value(config.project)')

export BUCKET=$PROJECT-spinnaker-config

gsutil mb -c regional -l us-central1 gs://$BUCKET

# Run the following command to create a spinnaker-config.yaml file, which describes how Helm should install Spinnaker:

export SA_JSON=$(cat spinnaker-sa.json)
export PROJECT=$(gcloud info --format='value(config.project)')
export BUCKET=$PROJECT-spinnaker-config
cat > spinnaker-config.yaml <<EOF
gcs:
  enabled: true
  bucket: $BUCKET
  project: $PROJECT
  jsonKey: '$SA_JSON'

dockerRegistries:
- name: gcr
  address: https://gcr.io
  username: _json_key
  password: '$SA_JSON'
  email: 1234@5678.com

# Disable minio as the default storage backend
minio:
  enabled: false

# Configure Spinnaker to enable GCP services
halyard:
  additionalScripts:
    create: true
    data:
      enable_gcs_artifacts.sh: |-
        \$HAL_COMMAND config artifact gcs account add gcs-$PROJECT --json-path /opt/gcs/key.json
        \$HAL_COMMAND config artifact gcs enable
      enable_pubsub_triggers.sh: |-
        \$HAL_COMMAND config pubsub google enable
        \$HAL_COMMAND config pubsub google subscription add gcr-triggers \
          --subscription-name gcr-triggers \
          --json-path /opt/gcs/key.json \
          --project $PROJECT \
          --message-format GCR
EOF

# Use the Helm command-line interface to deploy the chart with your configuration set:

./helm install -n default cd stable/spinnaker -f spinnaker-config.yaml \
           --version 1.23.0 --timeout 10m0s --wait
```

**The installation typically takes 5-8 minutes to complete.**

After the command completes, run the following command to set up port forwarding to Spinnaker from Cloud Shell:

```bash
export DECK_POD=$(kubectl get pods --namespace default -l "cluster=spin-deck" \
    -o jsonpath="{.items[0].metadata.name}")

kubectl port-forward --namespace default $DECK_POD 8080:9000 >> /dev/null &
```

To open the Spinnaker user interface, click the **Web Preview** icon at the top of the Cloud Shell window and select **Preview on port 8080**.

**Test Completed Task**

__Deploy the Spinnaker chart using Kubernetes Helm__

## Building the Docker image

#### Create your source code repository

In Cloud Shell tab and download the sample application source code:

```bash
wget https://gke-spinnaker.storage.googleapis.com/sample-app-v2.tgz

tar xzfv sample-app-v2.tgz

cd sample-app

# Set the username and email address for your Git commits in this repository. Replace [USERNAME] with a username you create:

export PROJECT_ID=$(gcloud info --format='value(config.project)')

git config --global user.email "$(gcloud config get-value core/account)"

git config --global user.name "$PROJECT_ID"

# Make the initial commit to your source code repository:

git init

git add .

git commit -m "Initial commit"

# Create a repository to host your code:

gcloud source repos create sample-app

git config credential.helper gcloud.sh

# Add your newly created repository as remote:

export PROJECT=$(gcloud info --format='value(config.project)')

git remote add origin https://source.developers.google.com/p/$PROJECT/r/sample-app

# Push your code to the new repository's master branch:

git push origin master
```

Click **Navigation Menu** > **Source Repositories**, click View All Repositories and select sample-app.

#### Configure your build triggers

Click Navigation menu > Cloud Build > Triggers.

Click **Create trigger**.

### Prepare your Kubernetes Manifests for use in Spinnaker

```bash
# Create the bucket:

export PROJECT=$(gcloud info --format='value(config.project)')

gsutil mb -l us-central1 gs://$PROJECT-kubernetes-manifests

# Enable versioning on the bucket so that you have a history of your manifests:

gsutil versioning set on gs://$PROJECT-kubernetes-manifests

# Set the correct project ID in your kubernetes deployment manifests:

sed -i s/PROJECT/$PROJECT/g k8s/deployments/*

# Commit the changes to the repository:

git commit -a -m "Set project ID"

# In Cloud Shell, still in the sample-app directory, create a Git tag:

git tag v1.0.0

# Push the tag:

git push --tags
```

Click **History**

**Stay on this page and wait** for the build to complete before going on to the next section.

## Configuring your deployment pipelines

#### Install the spin CLI for managing Spinnaker

```bash
curl -LO https://storage.googleapis.com/spinnaker-artifacts/spin/1.14.0/linux/amd64/spin

chmod +x spin

./spin application save --application-name sample \
                        --owner-email "$(gcloud config get-value core/account)" \
                        --cloud-providers kubernetes \
                        --gate-endpoint http://localhost:8080/gate

export PROJECT=$(gcloud info --format='value(config.project)')
sed s/PROJECT/$PROJECT/g spinnaker/pipeline-deploy.json > pipeline.json
./spin pipeline save --gate-endpoint http://localhost:8080/gate -f pipeline.json
```

### Manually Trigger and View your pipeline execution

## Triggering your pipeline from code changes

```bash
#From your sample-app directory, change the color of the app from orange to blue:

sed -i 's/orange/blue/g' cmd/gke-info/common-service.go

#Tag your change and push it to the source code repository:

git commit -a -m "Change color to blue"

git tag v1.0.1

git push --tags
```

In the Console, in **Cloud Build** > **History**

