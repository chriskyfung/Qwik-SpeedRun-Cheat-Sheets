# GSP066 Awwvision: Cloud Vision API from a Kubernetes Cluster

_last modified:_ 2020-09-06

## Create a Kubernetes Engine cluster

```bash
gcloud config set compute/zone us-central1-a
gcloud container clusters create awwvision \
    --num-nodes 2 \
    --scopes cloud-platform
gcloud container clusters get-credentials awwvision
kubectl cluster-info
git clone https://github.com/GoogleCloudPlatform/cloud-vision
cd cloud-vision/python/awwvision
make all
```

> Create a Kubernetes Engine cluster

## Check the Kubernetes resources on the cluster

```bash
kubectl get pods
kubectl get deployments -o wide
kubectl get svc awwvision-webapp
```

> Deploy the sample

## Test your Understanding

> ____ allows developers to easily integrate vision detection features within applications, including image labeling, face and landmark detection and much more.
>
> - Cloud Vision API