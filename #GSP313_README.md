# **GSP313** Google Cloud Essentials: Challenge Lab

Last update: 2020-03-21

1. Create a project jumphost instance (zone: us-east1-b)
2. Create a Kubernetes service cluster
3. Create the web server frontend

## Challenge scenario

- Create all resources in the default region or zone
- Naming is normally team-resource, e.g. an instance could be named **nucleus-webserver1**
- use **f1-micro** for small Linux VMs and **n1-standard-1** for Windows or other applications such as Kubernetes nodes.

Topics tested:

- Create an instance.
- Create a 3 node Kubernetes cluster and run a simple service.
- Create an HTTP(s) Load Balancer in front of two web servers.

## Task 1: Create a project jumphost instance

Make sure you:

- name the instance `nucleus-jumphost`
- use the machine type of `f1-micro`
- use the default image type (Debian Linux)

Procedures:

1. In the GCP Console, on the top left of the screen, select Navigation menu > Compute Engine > VM Instances
2. To create a new instance, click Create.
3. Configure the following parameters when creating a new instance:
    - Name: `nucleus-jumphost`
    - Region: `us-east1`
    - Zone: `us-east1-b`
    - Machine Type: `f1-micro`
    - Boot Disk: **default image type (Debian Linux)**
    - Firewall: Check `Allow HTTP traffic`

Click **Create**.

**Check my progress**

_Create a project jumphost instance_

## Task 2: Create a Kubernetes service cluster

- Create a cluster to host the service
- Use the Docker container hello-app (`gcr.io/google-samples/hello-app:2.0`) as a place holder, the team will replace the container with their own work later
- Expose the app on port 8080

Procedures:

1. Setting a default compute zone

```bash
gcloud config set compute/zone us-east1-b
gcloud config set compute/region us-east1
```

2. Creating a Kubernetes Engine cluster

```bash
export CLUSTER_NAME=nucleus-webserver1
gcloud container clusters create ${CLUSTER_NAME}
```

3. Deploying hello-app to the cluster

```bash
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:2.0

kubectl expose deployment hello-server --type=LoadBalancer --port 8080

kubectl get service
```

**Check my progress**

_Create a Kubernetes cluster_

## Task 3: Setup an HTTP load balancer

- Create an instance template
- Create a target pool
- Create a managed instance group
- Create a firewall rule to allow traffic (80/tcp)
- Create a health check
- Create a backend service and attach the managed instance group
- Create a URL map and target HTTP proxy to route requests to your URL map
- Create a forwarding rule

Procedures:

1. Set the default region and zone for all resources

```bash
gcloud config set compute/zone us-east1-b
gcloud config set compute/region us-east1
```

2. Create multiple web server instances

Still in Cloud Shell, create a startup script to be used by every virtual machine instance. This script sets up the Nginx server upon startup:

```bash
cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF
```

Create an instance template, which uses the startup script:

```bash
gcloud compute instance-templates create nginx-template \
         --metadata-from-file startup-script=startup.sh
```

Create a target pool. A target pool allows a single access point to all the instances in a group and is necessary for load balancing in the future steps.

```bash
gcloud compute target-pools create nginx-pool
```

Create a managed instance group using the instance template:

```bash
gcloud compute instance-groups managed create nucleus-nginx-group \
         --base-instance-name nucleus \
         --size 2 \
         --template nginx-template \
         --target-pool nginx-pool
```

List the compute engine instances and you should see all of the instances created:

```bash
gcloud compute instances list
```

Now configure a firewall so that you can connect to the machines on port 80 via the `EXTERNAL_IP` addresses:

```bash
gcloud compute firewall-rules create nucleus-www-firewall --allow tcp:80
```

3. Create a health check

```bash
gcloud compute http-health-checks create nucleus-http-basic-check
```

4. Create a backend service and attach the managed instance group

```
gcloud compute instance-groups managed \
       set-named-ports nucleus-nginx-group \
       --named-ports http:80

gcloud compute backend-services create nucleus-nginx-backend \
      --protocol HTTP --http-health-checks nucleus-http-basic-check --global

gcloud compute backend-services add-backend nucleus-nginx-backend \
    --instance-group nucleus-nginx-group \
    --instance-group-zone us-east1-b \
    --global
```

5. Create a URL map and target HTTP proxy to route requests to your URL map

```bash
gcloud compute url-maps create nucleus-web-map \
    --default-service nucleus-nginx-backend

gcloud compute target-http-proxies create nucleus-http-lb-proxy \
    --url-map nucleus-web-map
```

6. Create a forwarding rule

```bash
gcloud compute forwarding-rules create nucleus-http-content-rule \
        --global \
        --target-http-proxy nucleus-http-lb-proxy \
        --ports 80


gcloud compute forwarding-rules list
```

**Check my progress**

_Create the website behind the HTTP load balancer_