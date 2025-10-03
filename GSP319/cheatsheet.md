# **GSP319** Build a Website on Google Cloud: Challenge Lab

_Last update_: 2020-06-08

### Topics tested

Building and refactoring a monolithic web app into microservices

Deploying microservices in GKE

Exposing the Services deployed on GKE

### Tasks:

1. Download the monolith code and build your container
1. Create a kubernetes cluster and deploy the application
1. Create a containerized version of orders and product Microservices
1. Deploy the new microservices
1. Create a containerized version of the Frontend microservice
1. Deploy the Frontend microservice

### Make sure you

Create the cluseter in `us-central-1`

## Task 1: Downlaod the monolith code and build your container

Hint: GSP659 [Deploy Your Website on Cloud Run](https://www.qwiklabs.com/focuses/10445?parent=catalog)

Make sure you:
- submit a build named `fancytest`
- with a version of `1.0.0`.

```bash
git clone https://github.com/googlecodelabs/monolith-to-microservices
cd monolith-to-microservices
./setup.sh

cd monolith
npm start

gcloud services enable cloudbuild.googleapis.com
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/fancytest:1.0.0 .
```

> **Check my progress**
> Download the monolith code and build your container

## Task 2: Create a kubernetes cluster and deploy the application

Hint: GSP663 [Deploy, Scale, and Update Your Website on Google Kubernetes Engine](https://www.qwiklabs.com/focuses/10470?parent=catalog)

Make sure you:
- Create the cluster is named `fancy-cluster`
- in the running state in the zone `us-central1-a`

```bash
gcloud config set compute/zone us-central1-a
gcloud services enable container.googleapis.com
gcloud container clusters create fancy-cluster --num-nodes 3
gcloud compute instances list

kubectl create deployment fancytest --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/fancytest:1.0.0
kubectl get all

kubectl expose deployment fancytest --type=LoadBalancer --port 80 --target-port 8080
```

> **Check my progress**
> Create a kubernetes cluster and deploy the application

## Task 3: Create a containerized version of your Microservices

Make sure you:
- submit a build named "orders" with a version of "1.0.0",
- submit a build named "products" with a version of "1.0.0".

```bash
cd ~/monolith-to-microservices/microservices/src/orders
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/orders:1.0.0 .

cd ~/monolith-to-microservices/microservices/src/products
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/products:1.0.0 .
```

> **Check my progress**
> Create a containerized version of orders and product Microservices

## Task 4: Deploy the new microservices

```bash
kubectl create deployment orders --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/orders:1.0.0

kubectl expose deployment orders --type=LoadBalancer --port 80 --target-port 8081

kubectl create deployment products --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/products:1.0.0

kubectl expose deployment products --type=LoadBalancer --port 80 --target-port 8082
```

> **Check my progress**
> Deploy the new microservices

## Task 5: Configure the Frontend microservice

```bash
cd ~/monolith-to-microservices/react-app
nano .env
```

Replace `<ORDERS_IP_ADDRESS>` and `<PRODUCTS_IP_ADDRESS>` with the Orders and Product microservice IP addresses, respectively.

```
REACT_APP_ORDERS_URL=http://<ORDERS_IP_ADDRESS>/api/orders
REACT_APP_PRODUCTS_URL=http://<PRODUCTS_IP_ADDRESS>/api/products
```

## Task 6: Create a containerized version of the Frontend microservice

Make sure you
- submit a build named "frontend"
- with a version of "1.0.0".

```bash
npm run build

cd ~/monolith-to-microservices/microservices/src/frontend
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/frontend:1.0.0 .
```

> **Check my progress**
> Create a containerized version of the Frontend microservice

## Task 7: Deploy the Frontend microservice

```bash
kubectl create deployment frontend --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/frontend:1.0.0

kubectl expose deployment frontend --type=LoadBalancer --port 80 --target-port 8080
```

> **Check my progress**
> Deploy the Frontend microservice

## Summary

<iframe width="560" height="315" src="https://www.youtube.com/embed/C6xRQ2BgG5Y" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Almost repeat the task in the lab [Migrating a Monolithic Website to Microservices on Google Kubernetes Engine](https://www.qwiklabs.com/focuses/11953?parent=catalog)