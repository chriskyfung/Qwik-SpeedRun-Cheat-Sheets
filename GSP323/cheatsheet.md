# GSP323 Perform Foundational Data, ML, and AI Tasks in Google Cloud: Challenge Lab

_Last update_: 2020-06-11

### Topics tested:

Create a simple Dataproc job
Create a simple DataFlow job
Create a simple Dataprep job
Perform one of three Google machine learning backed API tasks
Are you up for the challenge?

### Tasks

1. Run a simple Dataflow job
1. Run a simple Dataproc job
1. Run a simple Dataprep job
1. AI

## Task 1: Run a simple Dataflow job

#### Created a BigQuery dataset called **lab**

```bash
bq mk lab

load \
--source_format=CSV \
lab.customers \
gs://cloud-training/gsp323/lab.schema

export GCLOUD_PROJECT=$(gcloud config get-value project)
export BUCKET_NAME=$GCLOUD_PROJECT

echo projects/pubsub-public-data/topics/lab-customers
echo $GCLOUD_PROJECT:lab-customers
echo gs://$GCLOUD_PROJECT/temp
```



## Task 2: Run a simple Dataproc job

```bash
hdfs dfs -cp gs://cloud-training/gsp323/data.txt /data.txt

gcloud dataproc jobs submit spark --cluster example-cluster \
  --region=us-central1
  --class org.apache.spark.examples.SparkPageRank \
  --jars file:///usr/lib/spark/examples/jars/spark-examples.jar -- /data.txt
```

## Task 3: Run a simple Dataprep job

1. Navigation menu > Dataprep.

2. Click Import Data

## Task 4: AI

#### Use Google Cloud Speech API to analyze the audio file

Create `gsc-request.json`

```json
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-training/gsp323/task4.flac"
  }
}
```

Create an API Key

```bash
export API_KEY=
```

```bash
curl -s -X POST -H "Content-Type: application/json" --data-binary @gsc-request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > task4-gcs.result
```

#### Use the Cloud Natural Language API to analyze the sentence

```bash
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value core/project)
gcloud iam service-accounts create my-natlang-sa \
  --display-name "my natural language service account"
gcloud iam service-accounts keys create ~/key.json \
  --iam-account my-natlang-sa@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS="/home/USER/key.json"

gcloud ml language analyze-entities --content="Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat." > task4-cnl.result
```

#### Use Google Video Intelligence and detect all text on the video


Create `gvi-request.json`

```json
{
   "inputUri":"gs://spls/gsp154/video/chicago.mp4",
   "features": [
       "LABEL_DETECTION"
   ]
}
```

```bash
gcloud iam service-accounts create quickstart
gcloud iam service-accounts keys create key.json --iam-account quickstart@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
gcloud auth activate-service-account --key-file key.json
export TOKEN=$(gcloud auth print-access-token)

curl -s -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer '${TOKEN} \
    'https://videointelligence.googleapis.com/v1/videos:annotate' \
    -d @gvi-request.json
```

```bash
curl -s -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer '$TOKEN \
    'https://videointelligence.googleapis.com/v1/operations/OPERATION_NAME' > task4-gvi.result
```

Replace `OPERATION_NAME`

#### Upload the result files

```bash
export GCLOUD_PROJECT=$(gcloud config get-value project)
gsutil cp task4-gcs.result gs://${GCLOUD_PROJECT}-marking/task4-gcs.result

gsutil cp task4-cnl.result gs://${GCLOUD_PROJECT}-marking/task4-cnl.result

gsutil cp task4-gvi.result gs://${GCLOUD_PROJECT}-marking/task4-gvi.result
```