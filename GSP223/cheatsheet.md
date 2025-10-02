# GSP223 Classify Images of Clouds in the Cloud with AutoML Vision

_last update: 2021-04-25_

Click on the **Cloud AutoML API** result and then click Enable.

Now open this [AutoML UI](https://console.cloud.google.com/vision/datasets) link in a new browser.

```
export PROJECT_ID=$DEVSHELL_PROJECT_ID
export QWIKLABS_USERNAME=

```
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="user:$QWIKLABS_USERNAME" \
    --role="roles/automl.admin"

gsutil mb -p $PROJECT_ID \
    -c standard    \
    -l us-central1 \
    gs://$PROJECT_ID-vcm/

export BUCKET=$PROJECT_ID-vcm
gsutil -m cp -r gs://spls/gsp223/images/* gs://${BUCKET}

gsutil cp gs://spls/gsp223/data.csv .
sed -i -e "s/placeholder/${BUCKET}/g" ./data.csv
gsutil cp ./data.csv gs://${BUCKET}

```

At the top of the console, click + NEW DATASET.

Type "clouds" for the Dataset name.

Select "Single-Label Classification".

Click Create Dataset.

Choose Select a CSV file on Cloud Storage and add the file name to the URL for the file you just uploaded - gs://your-bucket-name/data.csv




