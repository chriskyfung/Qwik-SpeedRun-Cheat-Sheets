# **GSP005** Hello Node Kubernetes

_Last modified: 2020-1-11_

- Create your cluster / 20
- Create your pod / 30
- Create a Kubernetes Service / 30
- Scale up your service / 20

* * *

In Cloud Shell, run the following codes:

```bash
cat > server.js <<EOF
var http = require('http');
var handleRequest = function(request, response) {
  response.writeHead(200);
  response.end("Hello World!");
}
var www = http.createServer(handleRequest);
www.listen(8080);
EOF

node server.js
```

Open a second Cloud Shell,

```bash
curl http://localhost:8080
export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud config set project ${PROJECT_ID}
gcloud container clusters create hello-world \
                --num-nodes 2 \
                --machine-type n1-standard-1 \
                --zone us-central1-a
```

**Check my progress** _Create your cluster._

**Preview the app on port 8080**

Press **Ctrl+C** to kill the app.

```bash
cat > Dockerfile <<EOF
FROM node:6.9.2
EXPOSE 8080
COPY server.js .
CMD node server.js
EOF

export PROJECT_ID=$(gcloud info --format='value(config.project)')

docker build -t gcr.io/${PROJECT_ID}/hello-node:v1 .

docker run -d -p 8080:8080 gcr.io/${PROJECT_ID}/hello-node:v1

curl http://localhost:8080

docker ps
docker ps -q
docker stop ${docker ps -q}

gcloud auth configure-docker
docker push gcr.io/${PROJECT_ID}/hello-node:v1

kubectl run hello-node \
    --image=gcr.io/${PROJECT_ID}/hello-node:v1 \
    --port=8080

kubectl get deployments
kubectl get pods

kubectl expose deployment hello-node --type="LoadBalancer"

kubectl get services
```

**Check my progress** _Create your pod_

**Check my progress** _Create a Kubernetes Service_

## Scale up your service

```bash
kubectl scale deployment hello-node --replicas=4
kubectl get deployment
kubectl get pods
```

**Check my progress** _Scale up your service_

* * *

## Optional

```bash
cat > server.js <<EOF
var http = require('http');
var handleRequest = function(request, response) {
  response.writeHead(200);
  response.end("Hello Kubernetes World!");
}
var www = http.createServer(handleRequest);
www.listen(8080);
EOF

cat < server.js

docker build -t gcr.io/${PROJECT_ID}/hello-node:v2 .
docker push gcr.io/${PROJECT_ID}/hello-node:v2

kubectl edit deployment hello-node
```

```vi
:wq
```

```bash
deployment "hello-node" edited
kubectl get deployments
```

## Test your knowledge


Identity and Access Management

Stateful Application Support

Integrated Logging and Monitoring
