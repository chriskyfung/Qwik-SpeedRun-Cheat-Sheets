# GSP330 Implement DevOps in Google Cloud: Challenge Lab

Topics tested

1. Use Jenkins console logs to resolve application deployment issues.
1. Deploy and a development update to a sample application for Jenkins to deply using a development pipeline.
1. Deploy and test a Kubernetes Canary deployment for a sample application.
1. Push the Canary application branch to master and confirm this triggers a production pipeline update.

- Create all resources in the `us-east1` region and `us-east1-b` zone, unless otherwise directed.
- Use the project VPCs.
- Naming is normally team-resource, e.g. an instance could be named `kraken-webserver1``

## Task 1: Configure a Jenkins pipeline for continuous deployment to Kubernetes Engine

> Check that Jenkins has pushed a production deployment the Kubernetes Engine cluster.

```bash
ssh kraken-jumphost
gcloud config set compute/zone us-east1-b
gcloud container clusters list
gcloud container clusters get-credentials jenkins-cd
kubectl cluster-info
kubectl get pods
```

### Configure `kubectl proxy` to access the Jenkins UI

```bash
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=cd" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &

kubectl get svc
```

### Retrieve and decode the Jenkins Admin password

```bash
printf $(kubectl get secret cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
```

To get to the Jenkins user interface, click on the **Web Preview** button in cloud shell, then click Preview on port 8080:

You should now be able to log in with username admin and your auto-generated password.

### Adding your service account credentials

Step 1: In the Jenkins user interface, click Manage Jenkins in the left navigation then click Manage Credentials.

Step 2: Click Jenkins stored_scoped_cred.png

Step 3: Click Global credentials (unrestricted).

Step 4: Click Add Credentials in the left navigation.

Step 5: Select Google Service Account from metadata from the Kind drop-down and click OK.

The global credentials has been added. The name of the credential is the Project ID found in the CONNECTION DETAILS section of the lab.

### Configure a multibranch Jenkins pipeline job using the Jenkinsfile

```bash
cd /work/sample-app
ls
cat Jenkinsfile

kubectl create ns production
```

### Configure the Jenkins job to check for new branches / repository updates every minute.

1. Creating the Jenkins job? 
2. choose the Multibranch Pipeline option and click OK.
3. From the Credentials drop-down, select the name of the credentials you created when adding your service account in the previous steps.
4. Under Scan Multibranch Pipeline Triggers section, check the Periodically if not otherwise run box and set the Interval value to 1 minute.

## Task 2: Push an update to the application to a development branch

> Check that updates to the appliction have been pushed to a development branch.

### Changes to the master branch trigger a Jenkins job that deploys a production update in the production namespace using the production/*.yaml templates.


```bash
cd /work/sample-app
git checkout -b dev
cat Jenkinsfile
```

Edit the file `main.go` in the root folder of the repo and change the version number to "2.0.0".

```go
const version string = "2.0.0"
```

Edit the file `html.go` in the root folder of the repo and change both lines that contains the word blue to orange.

```html
<div class="card orange">
```

```bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

git add Jenkinsfile html.go main.go

git commit -m "Version 2.0.0"

git push origin dev
```

## Task 3: Push a Canary deployment to the production namespace

> Check that Jenkins has pushed a Canary deployment to the production namespace successfully.

```bash
cd /work/sample-app
git checkout -b canary
git merge dev
cat Jenkinsfile
git push origin canary
```

### Task 4: Promote the Canary Deployment to production

> Check that Jenkins has pushed an update to the production application.


```bash
git checkout master
git merge canary
cat Jenkinsfile
git push origin master
```
