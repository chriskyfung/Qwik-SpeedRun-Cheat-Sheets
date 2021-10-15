# GSP917 Vertex AI: Qwik Start

_last updated on 2021-10-15_

## Enable Google Cloud services

```bash
gcloud services enable \
  compute.googleapis.com \
  iam.googleapis.com \
  iamcredentials.googleapis.com \
  monitoring.googleapis.com \
  logging.googleapis.com \
  notebooks.googleapis.com \
  aiplatform.googleapis.com \
  bigquery.googleapis.com \
  artifactregistry.googleapis.com \
  cloudbuild.googleapis.com \
  container.googleapis.com

SERVICE_ACCOUNT_ID=vertex-custom-training-sa
gcloud iam service-accounts create $SERVICE_ACCOUNT_ID  \
    --description="A custom service account for Vertex custom training with Tensorboard" \
    --display-name="Vertex AI Custom Training"

PROJECT_ID=$(gcloud config get-value core/project)
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/bigquery.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/aiplatform.user"

```

## Deploy Vertex Notebook instance

1. Navigate to **Vertex AI** > **Workbench**.

2. Go to **User-Managed Notebooks** tab and click **New Notebook**.

3. Choose **TensorFlow Enterprise 2.3 (with LTS)** > **Without GPUs**.

4. Region: `us-central1`

5. Click **Create**.

> Create a Vertex AI Notebook

## Clone the lab repository + Install lab dependencies

```bash
cd
git clone https://github.com/GoogleCloudPlatform/training-data-analyst

cd training-data-analyst/self-paced-labs/vertex-ai/vertex-ai-qwikstart
pip install -U -r requirements.txt

```

> Clone the lab repository

navigate to **training-data-analyst** > **self-paced-labs** > **vertex-ai** > **vertex-ai-qwikstart,** and open **lab_exercise.ipynb.**