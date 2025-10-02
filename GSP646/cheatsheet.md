# GSP646 Clean Up Unused IP Addresses

_last update: 2020-12-28_

## Enable APIs and Clone Repository

```bash
gcloud services enable cloudscheduler.googleapis.com

git clone https://github.com/GoogleCloudPlatform/gcf-automated-resource-cleanup.git && cd gcf-automated-resource-cleanup/

export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
export region=us-central1
WORKDIR=$(pwd)

cd $WORKDIR/unused-ip

export USED_IP=used-ip-address
export UNUSED_IP=unused-ip-address

gcloud compute addresses create $USED_IP --project=$PROJECT_ID --region=us-central1
gcloud compute addresses create $UNUSED_IP --project=$PROJECT_ID --region=us-central1

export USED_IP_ADDRESS=$(gcloud compute addresses describe $USED_IP --region=us-central1 --format=json | jq -r '.address')

gcloud compute instances create static-ip-instance \
--zone=us-central1-a \
--machine-type=n1-standard-1 \
--subnet=default \
--address=$USED_IP_ADDRESS

gcloud compute addresses list --filter="region:(us-central1)"

```

> **Check my progress**
> Enable the Cloud Scheduler API

## Create IP Addresses

> **Check my progress**
> Create two static IP addresses

## Create a VM

> **Check my progress**
> Create an instance with static IP address created earlier.

## Deploy the Cloud Function

```bash
cd gcf-automated-resource-cleanup/

export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
export region=us-central1
WORKDIR=$(pwd)

cd $WORKDIR/unused-ip

export USED_IP=used-ip-address
export USED_IP_ADDRESS=$(gcloud compute addresses describe $USED_IP --region=us-central1 --format=json | jq -r '.address')

cat $WORKDIR/unused-ip/function.js | grep "const compute" -A 31
gcloud functions deploy unused_ip_function --trigger-http --runtime=nodejs8

Y

```

```bash
export FUNCTION_URL=$(gcloud functions describe unused_ip_function --format=json | jq -r '.httpsTrigger.url')

gcloud scheduler jobs create http unused-ip-job \
--schedule="* 2 * * *" \
--uri=$FUNCTION_URL

gcloud scheduler jobs run unused-ip-job

Y

```

> **Check my progress**
> Deploy cloud function

> **Check my progress**
> Create App Engine Application

> **Check my progress**
> Run a cloud schedular job

```bash
gcloud compute addresses list --filter="region:(us-central1)"
```

> **Check my progress**
> Confirm the deletion of unused IP address
