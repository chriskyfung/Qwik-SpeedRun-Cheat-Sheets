# GSP708 Confluent: Running Apache Kafka on GKE

_last modified: 2020-11-06_

```bash
export PROJECT_ID=$(gcloud config list project --format "value(core.project)")
gcloud config set project $PROJECT_ID
git clone https://github.com/confluentinc/examples
cd examples # change directory and switch to 6.0.0-post branch
git checkout 6.0.0-post
cd ~
git clone https://github.com/TheJaySmith/confluent-kafka-on-gcp
cp confluent-kafka-on-gcp/kafka/gke/Makefile-impl examples/kubernetes/gke-base
cp confluent-kafka-on-gcp/kafka/gke/cfg/*.yaml examples/kubernetes/gke-base/cfg
cp confluent-kafka-on-gcp/kafka/gke/cfg/*.json examples/kubernetes/gke-base/cfg
cd examples/kubernetes/gke-base
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
make gke-create-cluster
gcloud container clusters list
make demo

```

_Deploying the Confluent Platform takes about 7 minutes_

```bash
kubectl -n operator get all

```

## Setup NGINX Ingress

```bash
kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/provider/cloud-generic.yaml
curl https://raw.githubusercontent.com/TheJaySmith/confluent-kafka-on-gcp/master/kafka/gke/kafka-nginx-ingress.yaml --output kafka-nginx-ingress.yaml
kubectl apply -f kafka-nginx-ingress.yaml -n operator
export KAFKA_IP=$(kubectl get service kafka-bootstrap-lb -n operator -o=jsonpath='{.status.loadBalancer.ingress[].ip}')
helm upgrade --install --namespace operator --wait --timeout=5m -f cfg/values.yaml --set global.initContainer.image.tag=6.0.0.0 --set global.provider.region=us-central1 --set global.provider.kubernetes.deployment.zones={us-central1-a}  --set kafka.image.tag=6.0.0.0 --set kafka.replicas=1 --set kafka.enabled=true kafka --set kafka.loadBalancer.enabled=true --set kafka.loadBalancer.domain=${KAFKA_IP}.xip.io -f cfg/values.yaml ../common/cp/operator/1.6.0/helm/confluent-operator

```

## Verify Confluent Platform via CLI

In Cloud Shell, open another tab and log into another shell:

```bash
kubectl -n operator exec -it client-console bash
kafka-console-consumer --bootstrap-server kafka:9071 --consumer.config /etc/kafka-client-properties/kafka-client.properties --topic clicks --from-beginning

```

## Verify and Explore Confluent Platform Control Center

```bash
kubectl get ingress -n operator

```