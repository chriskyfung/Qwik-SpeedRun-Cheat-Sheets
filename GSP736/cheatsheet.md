# GSP736 Debugging Apps on Google Kubernetes Engine

## Infrastructure setup

```bash
gcloud config set compute/zone us-central1-b

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud container clusters list
```

Once your cluster has RUNNING status, get the cluster credentials:

```bash
gcloud container clusters get-credentials central --zone us-central1-b
kubectl get nodes
```

## Deploy application

```bash
git clone https://github.com/xiangshen-dk/microservices-demo.git
cd microservices-demo
kubectl apply -f release/kubernetes-manifests.yaml
kubectl get pods
```

```
export EXTERNAL_IP=$(kubectl get service frontend-external | awk 'BEGIN { cnt=0; } { cnt+=1; if (cnt > 1) print $4; }')

curl -o /dev/null -s -w "%{http_code}\n"  http://$EXTERNAL_IP
