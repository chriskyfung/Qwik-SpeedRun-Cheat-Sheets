# GSP199 Service Accounts and Roles: Fundamentals

_last modified: 2021-09-18_

## Creating and Managing Service Accounts

### Creating a service account

```bash
gcloud iam service-accounts create my-sa-123 --display-name "my service account"
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:my-sa-123@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/editor
```

> **Check my progress**
> Creating and Managing Service Accounts

## Create a service account

Go to Navigation menu > **IAM & Admin**, select Service accounts and click on **+ Create Service Account**.

Service account name: `bigquery-qwiklab`

Role: `BigQuery Data Viewer` and `BigQuery User`

## Create a VM instance

```bash
gcloud compute instances create bigquery-instance \
  --zone=us-central1-a \
  --machine-type=n1-standard-1 \
  --service-account=bigquery-qwiklab@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --image-project=debian-cloud \
  --image-family=debian-9

gcloud compute ssh bigquery-instance --zone=us-central1-a
```


In the SSH,


```bash
sudo apt-get update
sudo apt-get install -y virtualenv

```

```bash
virtualenv -p python3 venv
source venv/bin/activate

echo "
from google.auth import compute_engine
from google.cloud import bigquery

credentials = compute_engine.Credentials(
    service_account_email='YOUR_SERVICE_ACCOUNT')

query = '''
SELECT
  year,
  COUNT(1) as num_babies
FROM
  publicdata.samples.natality
WHERE
  year > 2000
GROUP BY
  year
'''

client = bigquery.Client(
    project='YOUR_PROJECT_ID',
    credentials=credentials)
print(client.query(query).to_dataframe())
" > query.py

sed -i -e "s/YOUR_PROJECT_ID/$(gcloud config get-value project)/g" query.py

sed -i -e "s/YOUR_SERVICE_ACCOUNT/bigquery-qwiklab@$(gcloud config get-value project).iam.gserviceaccount.com/g" query.py

sudo apt-get install -y git python3-pip

```

```bash
pip install google-cloud-bigquery

pip install pandas

python query.py
```

> **Check my progress**
> Access BigQuery from a Service Account