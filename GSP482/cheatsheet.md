# GSP482 Securing Applications on Kubernetes Engine - Three Examples

_last modified: 2020-08-11_

```bash
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a

git clone https://github.com/GoogleCloudPlatform/gke-security-scenarios-demo

cd gke-security-scenarios-demo

sed -i 's/f1-micro/n1-standard-1/g' ~/gke-security-scenarios-demo/terraform/variables.tf

make setup-project

make create
```

> **Check my progress**
> Deployment Steps

## Validation

```bash
gcloud compute ssh gke-tutorial-bastion
kubectl get pods --all-namespaces
kubectl apply -f manifests/nginx.yaml
kubectl get pods
kubectl describe pod -l app=nginx
```

> **Check my progress**
> Set up Nginx

## Set up AppArmor-loader

```bash
kubectl apply -f manifests/apparmor-loader.yaml
kubectl delete pods -l app=nginx
kubectl get pods
kubectl get services
```

> **Check my progress**
> Set up AppArmor-loader

## Set up Pod-labeler

```bash
kubectl get pods --show-labels
kubectl apply -f manifests/pod-labeler.yaml
kubectl get pods --show-labels
```

This can take up to **two minutes** to finish the creation of the new pod, but once this has finished, re-execute:

> **Check my progress**
> Set up Pod-labeler

## Teardown

```bash
exit
```

```bash
nano scripts/teardown.sh
```

Add the following to the end of line 33,

```sh
-var="zone=us-central1-a" -var="region=us-central1" -var="project=qwiklabs-gcp-00-240ba0bd7c0f"
```

```
make teardown
```

> **Check my progress**
> Teardown