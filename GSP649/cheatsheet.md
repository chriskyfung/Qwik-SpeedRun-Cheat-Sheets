# GSP649 Optimizing Cost with Google Cloud Storage

_last modified: 2020-12-12_

## Enable APIs and clone repository

```bash
gcloud services enable cloudscheduler.googleapis.com

git clone https://github.com/GoogleCloudPlatform/gcf-automated-resource-cleanup.git && cd gcf-automated-resource-cleanup/

export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
WORKDIR=$(pwd)

cd $WORKDIR/migrate-storage

export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
gsutil mb -c regional -l us-central1 gs://${PROJECT_ID}-serving-bucket

gsutil acl ch -u allUsers:R gs://${PROJECT_ID}-serving-bucket
gsutil cp $WORKDIR/migrate-storage/testfile.txt  gs://${PROJECT_ID}-serving-bucket
gsutil acl ch -u allUsers:R gs://${PROJECT_ID}-serving-bucket/testfile.txt
curl http://storage.googleapis.com/${PROJECT_ID}-serving-bucket/testfile.txt

gsutil mb -c regional -l us-central1 gs://${PROJECT_ID}-idle-bucket

sudo apt-get install apache2-utils -y

```

## Create a Monitoring dashboard

1. In the Cloud Console, click Navigation menu > Monitoring.

2. click Dashboards > Create Dashboard.

    `Bucket Usage`

3. In the top right of the window, click Add Chart.

    `Bucket Access`

4. To filter by the method name:

    For Filter, select **method**.

    For Value, select **ReadObject**.

    Click Apply.

5. To group the metrics by bucket name, in the **Group By** drop-down list, click **bucket_name**.

## Generate load on the serving bucket

```bash
ab -n 10000 http://storage.googleapis.com/$PROJECT_ID-serving-bucket/testfile.txt

cat $WORKDIR/migrate-storage/main.py | grep "migrate_storage(" -A 15

gcloud functions deploy migrate_storage --trigger-http --runtime=python37

```

When prompted, enter **Y** to allow unauthenticated invocations.

Capture the trigger URL into an environment variable that you use in the next section:

```bash
export FUNCTION_URL=$(gcloud functions describe migrate_storage --format=json | jq -r '.httpsTrigger.url')

export IDLE_BUCKET_NAME=$PROJECT_ID-idle-bucket

envsubst < $WORKDIR/migrate-storage/incident.json | curl -X POST -H "Content-Type: application/json" $FUNCTION_URL -d @-

gsutil defstorageclass get gs://$PROJECT_ID-idle-bucket

```