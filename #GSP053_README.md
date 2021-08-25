# **GSP053** Managing Deployments Using Kubernetes Engine

_last updated on 2021-06-22_
_last verified on 2021-08-25_

```bash
gcloud config set compute/zone us-central1-a

gsutil -m cp -r gs://spls/gsp053/orchestrate-with-kubernetes .
cd orchestrate-with-kubernetes/kubernetes

gcloud container clusters create bootcamp --num-nodes 5 --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"

sed -i '/kelseyhightower/s/auth:2.0.0/auth:1.0.0/' deployments/auth.yaml
cat deployments/auth.yaml

kubectl create -f deployments/auth.yaml
kubectl get deployments
kubectl get replicasets
kubectl get pods

kubectl create -f services/auth.yaml
kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml

kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml

kubectl get services frontend
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`
```

## Create a canary deployment

```bash
kubectl create -f deployments/hello-canary.yaml
kubectl get deployments
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
```

```bash
kubectl explain deployment.spec.replicas

kubectl scale deployment hello --replicas=5

kubectl get pods | grep hello- | wc -l
```

```bash
kubectl scale deployment hello --replicas=3

kubectl get pods | grep hello- | wc -l
```

## Trigger a rolling update

```bash
kubectl edit deployment hello
```

```yaml
...
containers:
- name: hello
  image: kelseyhightower/hello:2.0.0
...
```

```bash
kubectl get replicaset
kubectl rollout history deployment/hello
```
