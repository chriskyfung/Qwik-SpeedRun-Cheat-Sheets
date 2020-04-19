# **GSP318** Kubernetes in Google Cloud: Challenge Lab

last modified: 2020-04-19

1. Create a Docker image and store the Dockerfile
2. Test the created Docker image
3. Push the Docker image in the Google Container Repository
4. Create and expose a deployment in Kubernetes
5. Increase the replicas from 1 to 3
6. Update the deployment with a new version of valkyrie-app
7. Create a pipeline in Jenkins to deploy your app

## Task 1: Create a Docker image and store the Dockerfile

![](/img/Source_Repositories.png)

1. Open Cloud Shell

```bash
source <(gsutil cat gs://cloud-training/gsp318/marking/setup_marking.sh)

gcloud config set compute/region us-esat1
gcloud config set compute/zone us-esat1-b

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud source repos clone valkyrie-app --project=$PROJECT_ID

cd valkyrie-app

cat > Dockerfile <<EOF
FROM golang:1.10
WORKDIR /go/src/app
COPY source .
RUN go install -v
ENTRYPOINT ["app","-single=true","-port=8080"]
EOF

docker build -t valkyrie-app:v0.0.1 .

docker images

cd ~/marking
./step1.sh

cd valkyrie-app
```

![](/img/container-repositories.png)

## Task 2: Test the created Docker image

```bash
docker run -p 8080:8080 --name valkyrie-app valkyrie-app:v0.0.1 &
```

**Web Preview**

```bash
cd ~/marking
./step2.sh

cd valkyrie-app
```

![](/img/valkyrie-app-v0.0.1.png)

## Task 3: Push the Docker image in the Container Repository

```bash
docker tag valkyrie-app:v0.0.1 gcr.io/$PROJECT_ID/valkyrie-app:v0.0.1
docker images
docker push gcr.io/$PROJECT_ID/valkyrie-app:v0.0.1
```

**Check My Progress**

_Push the Docker image in the Google Container Repository_

## Task 4: Create and expose a deployment in Kubernetes

1. Navigate to **Kubernetes Engine** > **Clusters**
![](/img/Provisioned_Kubernetes_Cluster_-_valkyrie-dev.png)

2. Click **Connect**, to get the Kubernetes credentials of the cluster called **valkyrie-dev**.

```bash
cd k8s

gcloud container clusters get-credentials valkyrie-dev --zone us-east1-d --project $PROJECT_ID

sed -i 's/IMAGE_HERE/gcr.io\/'"${PROJECT_ID}"'\/valkyrie-app:v0.0.1/g' deployment.yaml

kubectl create -f deployment.yaml

kubectl create -f service.yaml

kubectl get pods
kubectl get services
```

**Check My Progress**

_Create and expose a deployment in Kubernetes_

## Task 5: Update the deployment with a new version of valkyrie-app

1. Increase the replicas from 1 to 3

**Check My Progress**

_Increase the replicas from 1 to 3_

2. Merge kurt-dev into master

```bash
cd ..
git merge origin/kurt-dev

docker build -t valkyrie-app:v0.0.2 .

docker images

docker container kill $(docker ps -q)

docker run -p 8080:8080 --name valkyrie-app valkyrie-app:v0.0.2 &
```
![](/img/valkyrie-app-v0.0.2.png)

```bash
docker tag valkyrie-app:v0.0.2 gcr.io/$PROJECT_ID/valkyrie-app:v0.0.2
docker images
docker push gcr.io/$PROJECT_ID/valkyrie-app:v0.0.2
```

Navigate to **Kubernetes Engine > Workloads**, click the name **valkyrie-app** to show the Deployment details. Press the  icon to expand the menu and select Rolling Update.

**Check My Progress**

_Update the deployment with a new version of valkyrie-app_

## Task 6: Create a pipeline in Jenkins to deploy your app

```bash
docker container kill $(docker ps -q)

printf $(kubectl get secret cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=cd" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &
```

**Username**: admin

#### Adding your service account credentials

**Step 1**: In the Jenkins user interface, click **Credentials** in the left navigation.

**Stip 2**: Click **Jenkins**

![](/img/jenkins-credentials.png)

**Step 3**: Click **Global credentials (unrestricted)**.

![](/img/jenkins-global-credentials.png)

**Step 4**: Click **Add Credentials** in the left navigation.

**Step 5**: Select **Google Service Account from metadata** from the **Kind** drop-down and click **OK**.

![](/img/jenkins-google-sa-credentials.png)

#### Creating the Jenkins job

Create a pipeline job that points to your */master branch on your source code.

**Step 1**: Click **Jenkins** > **New Item** in the left navigation:

**Step 2**: Name the project **valkyrie-app**, then choose the **Multibranch Pipeline** option and click **OK**.

**Step 3**: On the next page, in the Branch Sources section, click **Add Source** and select **git**.

**Step 4**: Paste the HTTPS clone URL of your sample-app repo in Cloud Source Repositories into the Project Repository field. Replace [PROJECT_ID] with your GCP Project ID:

```bash
echo "https://source.developers.google.com/p/${PROJECT_ID}/r/valkyrie-app"
```

**Step 5**: From the **Credentials** drop-down, select the name of the credentials you created when adding your service account in the previous steps.

**Step 6**: Under **Scan Multibranch Pipeline Triggers** section, check the **Periodically if not otherwise run** box and set the **Interval** value to 1 minute.

**Step 7**: Your job configuration should look like this:

![](/img/Multibranch_Pipeline.png)

#### Make two changes to your files before you commit and build:

```bash
sed -i -e 's/YOUR_PROJECT/'"${PROJECT_ID}"'/g' Jenkinsfile

sed -i 's/green/orange/g' source/html.go

git config --global user.email $PROJECT_ID
git config --global user.name $PROJECT_ID

git add *
git commit -m 'green to orange'
git push origin master
```

Manually trigger a build

![](/img/jenkins-build-queue.png)

![](/img/valkyrie-app-versions.png)

![](/img/valkyrie-app-dev.2.png)

**Check My Progress**
__Create a pipeline in Jenkins to deploy your app__