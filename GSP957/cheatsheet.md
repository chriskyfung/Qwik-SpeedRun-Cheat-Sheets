# GSP957 GKE Autopilot: Qwik Start

```
PROJECT_ID=$(gcloud config get-value project)

cd ./src/frontend

gcloud builds submit --tag gcr.io/$PROJECT_ID/frontend:latest

cd -

cd ~/voting-demo

sed -i "s/PROJECT_ID/$PROJECT_ID/g" ./kubernetes/frontend.yaml

kubectl apply -f ./kubernetes/

watch kubectl get pods

EXTERNAL_IP=$(kubectl get service frontend-external -o jsonpath="{.status.loadBalancer.ingress[0].ip}{'\n'}")

echo $EXTERNAL_IP

FRONTEND="http://$EXTERNAL_IP:80"

curl -X POST "$FRONTEND/vote" -H "Content-Type: application/json" -d '{"vote":"a"}'

curl "$FRONTEND/results"


```

> Deploy the App

> Test the App

```
kubectl delete -f kubernetes/

```