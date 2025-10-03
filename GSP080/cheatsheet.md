# **GSP080** Cloud Functions: Qwik Start - Command Line

_last updaetd on 2021-09-16_
_last verified on 2021-09-16_

## Create a function

```bash
mkdir gcf_hello_world

cd gcf_hello_world

cat > index.js <<EOF
/**
 * Cloud Function.
 *
 * @param {object} event The Cloud Functions event.
 * @param {function} callback The callback function.
 */
exports.helloWorld = function helloWorld (event, callback) {
  console.log(`My Cloud Function: ${JSON.stringify(event.data.message)}`);
  callback();
};
EOF

export PROJECT_ID=$(gcloud info --format='value(config.project)')

export BUCKET=${PROJECT_ID}

gsutil mb -p ${PROJECT_ID} gs://${BUCKET}

gcloud functions deploy helloWorld \
  --stage-bucket ${BUCKET} \
  --trigger-topic hello_world \
  --runtime nodejs8
```

**Check my progress** _Create a cloud storage bucket._

## Deploy your function

**Check my progress** _Deploy the function._

## Test the function

```bash
gcloud functions describe helloWorld

gcloud functions call helloWorld --data '{"message":"Hello World!"}'

gcloud functions logs read helloWorld
```

## View logs

## Test your Understanding

> Serverless lets you write and deploy code without the hassle of managing the underlying infrastructure.

**True**