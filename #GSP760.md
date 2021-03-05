# GSP760 Build a BigQuery Processing Pipeline with Events for Cloud Run for Anthos

```bash
export CLUSTER_NAME=events-cluster
export CLUSTER_ZONE=europe-west1-b

export BUCKET="$(gcloud config get-value core/project)-charts-gke"

gcloud config set run/cluster $CLUSTER_NAME
gcloud config set run/cluster_location $CLUSTER_ZONE
gcloud config set run/platform gke

gcloud beta container clusters create ${CLUSTER_NAME} \
  --addons=HttpLoadBalancing,HorizontalPodAutoscaling,CloudRun \
  --machine-type=n1-standard-4 \
 --enable-autoscaling --min-nodes=3 --max-nodes=10 \
  --no-issue-client-certificate --num-nodes=3 --image-type=cos \
  --enable-stackdriver-kubernetes \
  --scopes=cloud-platform,logging-write,monitoring-write,pubsub \
  --zone ${CLUSTER_ZONE} \
  --release-channel=rapid

gcloud beta events init

```

Type `Y` at each prompt.

```bash
kubectl get pods -n cloud-run-events
kubectl get pods -n knative-eventing

export NAMESPACE=default
gcloud beta events namespaces init ${NAMESPACE} --copy-default-secret

gcloud beta events brokers create default --namespace ${NAMESPACE}

kubectl get broker -n ${NAMESPACE}
```

```bash
export CLUSTER_NAME=events-cluster
export CLUSTER_ZONE=europe-west1-b
export BUCKET="$(gcloud config get-value core/project)-charts-gke"
gsutil mb gs://${BUCKET}
gsutil uniformbucketlevelaccess set on gs://${BUCKET}
gsutil iam ch allUsers:objectViewer gs://${BUCKET}

export GCS_SERVICE_ACCOUNT=$(curl -s -X GET -H "Authorization: Bearer $(gcloud auth print-access-token)" "https://storage.googleapis.com/storage/v1/projects/$(gcloud config get-value project)/serviceAccount" | jq --raw-output '.email_address')

gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
    --member=serviceAccount:${GCS_SERVICE_ACCOUNT} \
    --role roles/pubsub.publisher

git clone https://github.com/meteatamel/knative-tutorial
cd knative-tutorial/eventing/processing-pipelines/

export SERVICE_NAME=query-runner
docker build -t gcr.io/$(gcloud config get-value project)/${SERVICE_NAME}:v1 -f bigquery/${SERVICE_NAME}/csharp/Dockerfile .

docker push gcr.io/$(gcloud config get-value project)/${SERVICE_NAME}:v1

gcloud run deploy ${SERVICE_NAME} \
  --image gcr.io/$(gcloud config get-value project)/${SERVICE_NAME}:v1 \
  --update-env-vars PROJECT_ID=$(gcloud config get-value project)

gcloud container clusters get-credentials events-cluster --zone europe-west1-b

export SCHEDULER_LOCATION=europe-west1
export APP_ENGINE_LOCATION=europe-west
gcloud app create --region=${APP_ENGINE_LOCATION}
gcloud beta events triggers create trigger-${SERVICE_NAME}-uk \
--target-service=${SERVICE_NAME} \
--type=google.cloud.scheduler.job.v1.executed \
--parameters location=${SCHEDULER_LOCATION} \
--parameters schedule="0 16 * * *" \
--parameters data="United Kingdom"

gcloud beta events triggers create trigger-${SERVICE_NAME}-cy \
--target-service=${SERVICE_NAME} \
--type=google.cloud.scheduler.job.v1.executed \
--parameters location=${SCHEDULER_LOCATION} \
--parameters schedule="0 17 * * *" \
--parameters data="Cyprus"

cd bigquery/chart-creator/python
export SERVICE_NAME=chart-creator
docker build -t gcr.io/$(gcloud config get-value project)/${SERVICE_NAME}:v1 .
docker push gcr.io/$(gcloud config get-value project)/${SERVICE_NAME}:v1

gcloud run deploy ${SERVICE_NAME} \
  --image gcr.io/$(gcloud config get-value project)/${SERVICE_NAME}:v1 \
  --update-env-vars BUCKET=${BUCKET}

gcloud beta events triggers create trigger-${SERVICE_NAME} \
  --target-service=${SERVICE_NAME} \
  --type=dev.knative.samples.querycompleted \
  --custom-type

gcloud beta events triggers list
gcloud scheduler jobs list

```

Open [Cloud Scheduler](https://console.cloud.google.com/cloudscheduler)
Click **RUN NOW** for each Job

gcloud scheduler jobs run [MY-ID]
gcloud scheduler jobs run [MY-ID]


```bash
gsutil ls gs://${BUCKET}
```