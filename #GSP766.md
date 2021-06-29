# GSP766 Managing a GKE Multi-tenant Cluster with Namespaces

_last updated on 2021-06-29_

**Prep:**

Open **Monitoring** page

## Download required files && View and Create Namespaces

```bash
gsutil -m cp -r gs://spls/gsp766/gke-qwiklab ~
cd ~/gke-qwiklab

gcloud config set compute/zone us-central1-a && gcloud container clusters get-credentials multi-tenant-cluster

kubectl get namespace
kubectl api-resources --namespaced=true
kubectl get services --namespace=kube-system

kubectl create namespace team-a && \
kubectl create namespace team-b

kubectl get namespace

kubectl run app-server --image=centos --namespace=team-a -- sleep infinity && \
kubectl run app-server --image=centos --namespace=team-b -- sleep infinity

kubectl get pods -A

kubectl describe pod app-server --namespace=team-a
kubectl config set-context --current --namespace=team-a
kubectl describe pod app-server

```

## Access Control in Namespaces

```bash
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
--member=serviceAccount:team-a-dev@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com  \
--role=roles/container.admin

kubectl create role pod-reader \
--resource=pods --verb=watch --verb=get --verb=list

cat developer-role.yaml

kubectl create -f developer-role.yaml

kubectl create rolebinding team-a-developers \
--role=developer --user=team-a-dev@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com

gcloud iam service-accounts keys create /tmp/key.json --iam-account team-a-dev@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com

```

Open a new Cloud Shell tab, and run the following commands:

```bash
gcloud auth activate-service-account  --key-file=/tmp/key.json

gcloud container clusters get-credentials multi-tenant-cluster --zone us-central1-a --project ${GOOGLE_CLOUD_PROJECT}

kubectl get pods --namespace=team-a

kubectl get pods --namespace=team-b

```

Return to the first Cloud Shell tab

```bash
gcloud container clusters get-credentials multi-tenant-cluster --zone us-central1-a --project ${GOOGLE_CLOUD_PROJECT}

```

## Resource Quotas

```bash
kubectl create quota test-quota \
--hard=count/pods=2,count/services.loadbalancers=1 --namespace=team-a

kubectl run app-server-2 --image=centos --namespace=team-a -- sleep infinity

kubectl run app-server-3 --image=centos --namespace=team-a -- sleep infinity

kubectl describe quota test-quota --namespace=team-a

export KUBE_EDITOR="nano"
kubectl edit quota test-quota --namespace=team-a

```

Change the value of count/pods under spec to 6:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  creationTimestamp: "2020-10-21T14:12:07Z"
  name: test-quota
  namespace: team-a
  resourceVersion: "5325601"
  selfLink: /api/v1/namespaces/team-a/resourcequotas/test-quota
  uid: a4766300-29c4-4433-ba24-ad10ebda3e9c
spec:
  hard:
    count/pods: "6"
    count/services.loadbalancers: "1"
status:
  hard:
    count/pods: "5"
    count/services.loadbalancers: "1"
  used:
    count/pods: "2"
```

```bash
kubectl describe quota test-quota --namespace=team-a

cat cpu-mem-quota.yaml
kubectl create -f cpu-mem-quota.yaml

cat cpu-mem-demo-pod.yaml
kubectl create -f cpu-mem-demo-pod.yaml --namespace=team-a

kubectl describe quota cpu-mem-quota --namespace=team-a

```

## Monitoring GKE and GKE Usage Metering

Open a new Cloud Shell

```bash
gcloud container clusters \
update multi-tenant-cluster --zone us-central1-a \
--resource-usage-bigquery-dataset cluster_dataset

export GCP_BILLING_EXPORT_TABLE_FULL_PATH=${GOOGLE_CLOUD_PROJECT}.billing_dataset.gcp_billing_export_v1_xxxx
export USAGE_METERING_DATASET_ID=cluster_dataset
export COST_BREAKDOWN_TABLE_ID=usage_metering_cost_breakdown

export USAGE_METERING_QUERY_TEMPLATE=~/gke-qwiklab/usage_metering_query_template.sql
export USAGE_METERING_QUERY=cost_breakdown_query.sql
export USAGE_METERING_START_DATE=2020-10-26

sed \
-e "s/\${fullGCPBillingExportTableID}/$GCP_BILLING_EXPORT_TABLE_FULL_PATH/" \
-e "s/\${projectID}/$GOOGLE_CLOUD_PROJECT/" \
-e "s/\${datasetID}/$USAGE_METERING_DATASET_ID/" \
-e "s/\${startDate}/$USAGE_METERING_START_DATE/" \
"$USAGE_METERING_QUERY_TEMPLATE" \
> "$USAGE_METERING_QUERY"

bq query \
--project_id=$GOOGLE_CLOUD_PROJECT \
--use_legacy_sql=false \
--destination_table=$USAGE_METERING_DATASET_ID.$COST_BREAKDOWN_TABLE_ID \
--schedule='every 24 hours' \
--display_name="GKE Usage Metering Cost Breakdown Scheduled Query" \
--replace=true \
"$(cat $USAGE_METERING_QUERY)"

```

Click the link below to navigate to the Data Studio Data Sources page:

[Data Sources](https://datastudio.google.com/c/navigation/datasources)

click **Create** > **Data Source**

select **CUSTOM QUERY.**

Enter the following query in the custom query box and replace [PROJECT-ID] with your Qwiklabs project id:

```sql
 SELECT *  FROM `[PROJECT-ID].cluster_dataset.usage_metering_cost_breakdown`
```

Click CONNECT.

