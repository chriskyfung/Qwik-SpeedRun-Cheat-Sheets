# GSP613 Machine Learning Predictions with FHIR and Healthcare API

```bash
git clone https://github.com/GoogleCloudPlatform/healthcare
cd healthcare/fhir/lung-cancer
pip3 install --upgrade pip
pip3 install tensorflow==1.15.2

python3 -c "import warnings;warnings.simplefilter(action='ignore', category=FutureWarning);import tensorflow as tf; print('TensorFlow version {} is installed.'.format(tf.VERSION))"

PROJECT_ID=$(gcloud info --format='value(config.project)')
DATASET_BUCKET=synthea-fhir-demo-dataset
BUCKET=${PROJECT_ID}-data
REGION=us-central1

gsutil mb -c regional -l ${REGION} gs://${BUCKET}

sed -i 's/tensorflow==1.13.1/tensorflow==1.15.2/g' requirements.txt
pip3 install --user -r requirements.txt

python3 -m scripts.assemble_training_data \
  --src_bucket=${DATASET_BUCKET} \
  --src_folder=synthea \
  --dst_bucket=${BUCKET} \
  --dst_folder=tfrecords

gsutil ls gs://${BUCKET}/tfrecords

python3 -m models.trainer.model \
  --training_data=gs://${BUCKET}/tfrecords/training.tfrecord \
  --eval_data=gs://${BUCKET}/tfrecords/eval.tfrecord \
  --model_dir=gs://${BUCKET}/model \
  --training_steps=3000 \
  --eval_steps=1000 \
  --learning_rate=0.1 \
  --export_model_dir=gs://${BUCKET}/saved_model

TIMESTAMP=`gsutil ls gs://${BUCKET}/saved_model/ | grep -oP '(?<=/)[0-9]+(?=/)'`

export MODEL=lungcancerdemo
export VERSION=v1

gcloud ai-platform models create --regions ${REGION} ${MODEL}
gcloud ai-platform versions create ${VERSION} \
  --async \
  --model ${MODEL} \
  --origin gs://${BUCKET}/saved_model/${TIMESTAMP} \
  --runtime-version=1.15

```

Type `1`  to select the the Global region.

```bash
gcloud ai-platform operations list -w

```

```bash
python3 -m scripts.predict \
  --project ${PROJECT_ID} \
  --model ${MODEL} \
  --version ${VERSION}

DATASET_ID=devdays
FHIR_STORE_ID=lung-cancer
PUBSUB_TOPIC=fhir

gcloud pubsub topics create ${PUBSUB_TOPIC}
gcloud beta healthcare datasets create ${DATASET_ID}

```

Type `y` to confirm that you want to enable healthcare API.

```bash
gcloud beta healthcare fhir-stores create \
  --dataset ${DATASET_ID} \
  --pubsub-topic "projects/${PROJECT_ID}/topics/${PUBSUB_TOPIC}" \
  --enable-update-create \
  --location us-central1 \
  --version STU3 \
  ${FHIR_STORE_ID}

inference/deploy.sh \
  --name ${MODEL} \
  --topic ${PUBSUB_TOPIC} \
  --env_vars MODEL=${MODEL},VERSION=${VERSION}

```

Type `y` to confirm the unauthenticated invocations.

```bash
TOKEN="Authorization: Bearer $(gcloud auth print-access-token)"
CT="Content-Type: application/json+fhir; charset=utf-8"

BASE_URL="https://healthcare.googleapis.com/v1beta1/projects/${PROJECT_ID}/locations/${REGION}/datasets/${DATASET_ID}/fhirStores/${FHIR_STORE_ID}/fhir"

gsutil cp gs://${DATASET_BUCKET}/synthea/patient_bundle.json .

curl -X POST -H "${TOKEN}" -H "${CT}" \
  -d @patient_bundle.json \
  "${BASE_URL}"

gsutil cp gs://${DATASET_BUCKET}/synthea/smoking_survey.json .
curl -X PUT -H "${TOKEN}" -H "${CT}" \
  -d @smoking_survey.json \
  "${BASE_URL}/Observation/a39bb260-4768-4989-8e1b-730c71085f58"

```