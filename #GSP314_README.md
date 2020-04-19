# **GSP314** Cloud Architecture: Challenge Lab

### Tasks

1. Create the Production Environment
2. Setup the Admin instance
3. Verify the Spinnaker deployment

![](/img/lab_provisioning.png)

![](/img/deployment-manager.png)

## Task 1: Create the production environment

#### Create the network using the Deployment Manager configuration

1. In the Console, navigate to Navigation menu > Compute Engine > VM instances.

2. Find the VM instance, called **kraken-jumphost**, and click **SSH**.

3. In the SSH window,

```bash
gcloud config set compute/region us-east1
gcloud config set compute/zone us-east1-b

export project=$(gcloud info --format='value(config.project)')

cd /work/dm

ls
```
![](/img/jumphost-ssh.png)

4. Replace `SET_REGION` to **us-east1** in `prod-network.yaml`

```bash
sed -i 's/SET_REGION/us-east1/g' prod-network.yaml
cat prod-network.yaml 
```
5. Create the **kraken-prod-vpc**

```bash
gcloud deployment-manager deployments create kraken-prod-vpc --config prod-network.yaml
```

![](/img/create-kraken-prod-vpc.png)

#### Create a cluster 

Click on Navigation menu > Kubernetes Engine > Cluster

```bash
gcloud beta container --project "$project" clusters create "kraken-prod" --zone "us-east1-b" --num-nodes "2" --network "projects/$project/global/networks/kraken-prod-vpc" --subnetwork "projects/$project/regions/us-east1/subnetworks/kraken-prod-subnet" 
```

![](kraken-prod-cluster.png)

![](/img/work-k8s.png)

```bash
cd /work/k8s

gcloud container clusters create kraken-prod \
--zone us-east1-b --num-nodes 2 --network kraken-prod-vpc --subnetwork kraken-prod-subnet

ls

kubectl create -f deployment-prod-backend.yaml

kubectl create -f deployment-prod-frontend.yaml

kubectl get pods

kubectl create -f service-prod-backend.yaml

kubectl create -f service-prod-frontend.yaml

kubectl get services
```

![](/img/deploy-pods-and-services.png)

**Click Check my progress to verify the objective.**

_Create the Production Environment_


## Task 2: Setup the Admin instance

- Add an instance called **kraken-admin**
- Add a network interface in **kraken-mgmt-subnet**
- Add another network interface in **kraken-prod-subnet**
- Monitor **kraken-admin** and if **CPU utilization** is over **50%** for more than **a minute** you need to **send an email** to yourself

### Create a VM instance

1. In the Console, navigate to **Navigation menu** > **Compute Engine** > **VM instances**.

2. Click **Create instance**.

3. Set the following values, leave all other values at their defaults:

| Property	| Value (type value or select option as specified) |
| ----------| --------------------|
| Name	    | kraken-admin        |
| Region	| us-east1            |
| Zone      | us-east1-b          |
| Machine type	| 1 vCPU (f1-micro) |

4. Click Management, security, disks, networking, sole tenancy.

5. Click Networking.

6. For Network interfaces, click the pencil icon to edit.

7. Set the following values, leave all other values at their defaults:

| Property |	Value (type value or select option as specified) |
| --       | --                   |
| Network	| kraken-prod-vpc
| Subnetwork|	kraken-prod-subnet |
| Network	| kraken-mgmt-vpc
| Subnetwork|	kraken-mgmt-subnet |

![](/img/kraken-admin-network.png)

### Create a Monitoring workspace

1. In the Google Cloud Platform Console, click on **Navigation menu** > **Monitoring**.

2. click **Alerting** from the left menu, then click **Create Policy**.

3. Click **Add Condition**.

Resource Type: CPU Usage
Metric `compute.googleapis.com/instance/cpu/utilization`

Threshold: 0.5 for 1 minute.

![](/img/alerting.png)

## Task 3: Verify the Spinnaker deployment

#### Connect the Spinnaker console.

1. In the Google Cloud Platform Console, click on **Navigation menu** > **Kubernetes Engine** > **Service & Ingress**

2. Search **spin-deck**, and click **Port Forward**

![](/img/spin-deck.png)
![](/img/port-forwarding.png)
![](/img/port-forwarding-cmd.png)

3. To open the Spinnaker user interface, click the **Web Preview** icon at the top of the Cloud Shell window and select **Preview on port 8080**.

![](/img/spinnaker.png)

#### Configure your build triggers

![](/img/cloud-build-trigger.png)

#### Clone your source code repository

![](/img/clone-sample-app.png)

![](/img/sample-app-v100.png)

1. In Cloud Shell tab and download the sample application source code:

```bash
export PROJECT=$(gcloud info --format='value(config.project)')

git clone https://source.developers.google.com/p/$PROJECT/r/sample-app

cd sample-app

ls

git config --list


git config --global user.email "$(gcloud config get-value core/account)"

git config --global user.name $PROJECT
```

![](/img/git_config.png)

### Triggering your pipeline from code changes

```bash
sed -i 's/orange/blue/g' cmd/gke-info/common-service.go
git commit -a -m "Change color to blue"

git tag v1.0.1

git push --tags
```

![](/img/git-commit.png)

In the Console, in **Cloud Build** > **History**

![](/img/build-history-v101.png)

Return to the Spinnaker UI and click **Pipelines** to watch the pipeline start to deploy the image to production.

![](/img/spinnaker-deploy.png)

![](/img/sample-app-v101.png)