# GSP699 Migrating a Monolithic Website to Microservices on Google Kubernetes Engine

_last updated on 2021-10-15_

```bash
cd ~
git clone https://github.com/googlecodelabs/monolith-to-microservices.git
cd ~/monolith-to-microservices
./setup.sh

gcloud config set compute/zone us-central1-f

gcloud services enable container.googleapis.com
```

```bash
gcloud container clusters create fancy-cluster --num-nodes 3

gcloud compute instances list

```

```bash
cd ~/monolith-to-microservices
./deploy-monolith.sh

kubectl get service monolith -w


```

> Create a GKE Cluster

> Deploy Existing Monolith

```bash
cd ~/monolith-to-microservices/microservices/src/orders
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/orders:1.0.0 .

kubectl create deployment orders --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/orders:1.0.0

kubectl expose deployment orders --type=LoadBalancer --port 80 --target-port 8081

kubectl get service orders -w

```

## Reconfigure Monolith

```bsah
cd ~/monolith-to-microservices/react-app
nano .env.monolith

```

Edit the file with:

```shell
REACT_APP_ORDERS_URL=http://<ORDERS_IP_ADDRESS>/api/orders
REACT_APP_PRODUCTS_URL=/service/products

```

```bash
npm run build:monolith

cd ~/monolith-to-microservices/monolith
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:2.0.0 .

kubectl set image deployment/monolith monolith=gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:2.0.0

cd ~/monolith-to-microservices/microservices/src/products
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/products:1.0.0 .

kubectl create deployment products --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/products:1.0.0

kubectl expose deployment products --type=LoadBalancer --port 80 --target-port 8082

kubectl get service products -w

```

> Migrate Orders to a microservice

## Reconfigure Monolith

```bash
cd ~/monolith-to-microservices/react-app
nano .env.monolith

```

Edite the file with:

```shell
REACT_APP_ORDERS_URL=http://<ORDERS_IP_ADDRESS>/api/orders
REACT_APP_PRODUCTS_URL=http://<PRODUCTS_IP_ADDRESS>/api/products

```

```bash
npm run build:monolith

cd ~/monolith-to-microservices/monolith
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:3.0.0 .

kubectl set image deployment/monolith monolith=gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:3.0.0

cd ~/monolith-to-microservices/react-app
cp .env.monolith .env
npm run build

cd ~/monolith-to-microservices/microservices/src/frontend
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/frontend:1.0.0 .

kubectl create deployment frontend --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/frontend:1.0.0

kubectl expose deployment frontend --type=LoadBalancer --port 80 --target-port 8080

kubectl get service frontend -w

```

> Migrate Products to a microservice

> Migrate frontend to a microservice

## Delete The Monolith

```bash
kubectl delete deployment monolith
kubectl delete service monolith

```
