# **GSP051** Continuous Delivery with Jenkins in Kubernetes Engine


```bash
gcloud config set compute/zone us-east1-d

git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git

cd continuous-deployment-on-kubernetes

gcloud container clusters create jenkins-cd \
--num-nodes 2 \
--machine-type n1-standard-2 \
--scopes "https://www.googleapis.com/auth/source.read_write,cloud-platform"

```

```bash
gcloud container clusters list

gcloud container clusters get-credentials jenkins-cd

kubectl cluster-info

helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install cd jenkins/jenkins -f jenkins/values.yaml --version 1.2.2 --wait

kubectl get pods -w

```

```bash
kubectl create clusterrolebinding jenkins-deploy --clusterrole=cluster-admin --serviceaccount=default:cd-jenkins

export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=cd" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &

kubectl get svc

printf $(kubectl get secret cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
```

```bash
cd sample-app
kubectl create ns production

kubectl apply -f k8s/production -n production

kubectl apply -f k8s/canary -n production

kubectl apply -f k8s/services -n production
```

```bash
kubectl scale deployment gceme-frontend-production -n production --replicas 4

kubectl get pods -n production -l app=gceme -l role=frontend

kubectl get pods -n production -l app=gceme -l role=backend

kubectl get service gceme-frontend -n production

export FRONTEND_SERVICE_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gceme-frontend)

curl http://$FRONTEND_SERVICE_IP/version
```

```
gcloud source repos create default

git init

git config credential.helper gcloud.sh

git remote add origin https://source.developers.google.com/p/$DEVSHELL_PROJECT_ID/r/default

git config --global user.email "student@qwiklabs.net"
git config --global user.name "student"

git add .
git commit -m "Initial commit"
git push origin master

export PROJECT_ID=$(gcloud info --format='value(config.project)')
https://source.developers.google.com/p/${PROJECT_ID}/r/default
```

## Adding your service account credentials

**Step 1:** In the Jenkins user interface, click **Manage Jenkins** in the left navigation then click **Manage Credentials.**

**Step 2:** Click **Jenkins**

**Step 3:** Click **Global credentials (unrestricted).**

**Step 4:** Click **Add Credentials** in the left navigation.

**Step 5:** Select **Google Service Account from metadata** from the **Kind** drop-down and click **OK.**

### Creating the Jenkins job

**Step 1:** Click **New Item** in the left navigation:

**Step 2:** Name the project **sample-app,** then choose the **Multibranch Pipeline** option and click **OK.**

**Step 3:** On the next page, in the **Branch Sources** section, click **Add Source** and select **git.**

**Step 4:** Paste the **HTTPS clone URL** of your sample-app repo in Cloud Source Repositories into the **Project Repository** field. Replace `[PROJECT_ID]` with your **Project ID:**

```
https://source.developers.google.com/p/[PROJECT_ID]/r/default
```

**Step 5:** From the **Credentials** drop-down, select the name of the credentials you created when adding your service account in the previous steps.


**Step 6:** Under **Scan Multibranch Pipeline Triggers** section, check the **Periodically if not otherwise run** box and set the **Interval** value to 1 minute.

## Creating a development branch

```bash
git checkout -b new-feature
sed -i 's/REPLACE_WITH_YOUR_PROJECT_ID/${PROJECT_ID}/' Jenkinsfile
cat Jenkinsfile

sed -i 's/card blue/card orange/' html.go
sed -i '/const version string/s/1.0.0/2.0.0/' main.go
cat main.go

git add Jenkinsfile html.go main.go

git commit -m "Version 2.0.0"

git push origin new-feature
```

```bash
kubectl proxy &
curl \
http://localhost:8001/api/v1/namespaces/new-feature/services/gceme-frontend:80/proxy/version

git checkout -b canary
git push origin canary

export FRONTEND_SERVICE_IP=$(kubectl get -o \
jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gceme-frontend)
while true; do curl http://$FRONTEND_SERVICE_IP/version; sleep 1; done
```

```bash
git checkout master

git merge canary

git push origin master

export FRONTEND_SERVICE_IP=$(kubectl get -o \
jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gceme-frontend)

while true; do curl http://$FRONTEND_SERVICE_IP/version; sleep 1; done
kubectl get service gceme-frontend -n production
```

## Test your Understanding

Which are the following Kubernetes namespaces used in the lab?

> production
> default
> kube-system

The Helm chart is a collection of files that describe a related set of Kubernetes resources.

> True