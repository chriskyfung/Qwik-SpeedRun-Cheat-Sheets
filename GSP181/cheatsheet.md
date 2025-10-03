# GSP181 NGINX Ingress Controller on Google Kubernetes Engine

_last update_: 2020-07-19


## Create a Kubernetes cluster

```bash
gcloud config set compute/zone us-central1-a
gcloud container clusters create nginx-tutorial --num-nodes 2
```

> **Check my progress**
> Create a Kubernetes cluster

## Install Helm

```bash
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh
chmod u+x install-helm.sh
./install-helm.sh --version v2.16.3

helm init
```

> **Check my progress**
> Initialize Helm

## Installing Tiller

```bash
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```

> **Check my progress**
> Create a tiller Service Account

```bash
helm init --service-account tiller --upgrade
kubectl get deployments -n kube-system
```

## Deploy an application in Kubernetes Engine

```bash
kubectl create deployment hello-app --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment hello-app  --port=8080

```

> **Check my progress**
> Deploy an application in Kubernetes Engine

> **Check my progress**
> Expose the created deployment as a service

## Deploying the NGINX Ingress Controller via Helm

```bash
helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true
kubectl get service nginx-ingress-controller
```

> **Check my progress**
> Deploy the NGINX Ingress Controller via Helm

```bash
cat > ingress-resource.yaml << EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-resource
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /hello
        backend:
          serviceName: hello-app
          servicePort: 8080
EOF

kubectl apply -f ingress-resource.yaml
kubectl get ingress ingress-resource
```