# **GSP645** Share Data Securely via a REST API Using Cloud Run

## Enable the Cloud Run API

**APIs & Services** > **Library**. 
Search **"Cloud Run"** and Click **Enable**

## Build the REST API

```bash
PROJECT_ID=$(gcloud config get-value project)
git clone https://github.com/rosera/pet-theory.git
cd pet-theory/lab04
npm install express
edit package.json
edit index.js
edit Dockerfile
```

```bash
cd pet-theory/lab04
gcloud config set project 
PROJECT_ID=$(gcloud config get-value project)
gcloud builds submit \
  --tag gcr.io/$PROJECT_ID/rest-api

gcloud beta run deploy rest-api \
  --image gcr.io/$PROJECT_ID/rest-api \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated

```

**Check my progress** _Build a REST API with Google Container Registry and Cloud Run_

## Import customer data into Firestore

**Firestore** > click the **Select Native Mode** button

Select the location `nam5 (United States)`

Click the **Create Database** button

**Check my progress** *Create a new GCS bucket with name as <PROJECT_ID>-customer*

```bash
gsutil mb gs://$PROJECT_ID-customer

gsutil cp -r gs://spls/gsp645/2019-10-06T20:10:37_43617/ gs://$PROJECT_ID-customer

gcloud beta firestore import gs://$PROJECT_ID-customer/2019-10-06T20:10:37_43617
```

**Check my progress** _Import customer data into Firestore Database_

## Connect the REST API to the Firestore database

```bash
npm install @google-cloud/firestore
npm install cors
edit index.js
```

```bash
gcloud builds submit \
  --tag gcr.io/$PROJECT_ID/rest-api

gcloud beta run deploy rest-api \
  --image gcr.io/$PROJECT_ID/rest-api \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

**Check my progress** _Connect the REST API to the Firestore database_

## Add authentication to the REST API

**APIs & Services** > **OAuth consent screen**

Select `Internal` for the **User Type** and click **Create**.

Application name:

`Pet Theory REST API`

Authorized Domains:

`storage.googleapis.com`

**Check my progress** _Create an OAuth consent screen for your app_

**APIs & Services** > **Credentials**. Click **Create credentials** and select **OAuth client ID**.

select **Web application**.

Authorized JavaScript origins:

`https://storage.googleapis.com`

Click **Create**

**Check my progress** _Create OAuth client ID_

## Add a web page that lets users sign in and call the REST API

```bash
gsutil mb gs://$PROJECT_ID-public
gsutil iam ch allUsers:objectViewer gs://$PROJECT_ID-public
gcloud beta run services describe rest-api --platform managed --region us-central1 --format "value(status.url)"
edit website/index.html
edit website/index.js
```

Replace `[CLIENT-ID]` in `index.html` with it
Replace [URL] in `index.js` with it

**Check my progress** *Create a new GCS bucket with name as <PROJECT_ID>-public*

```bash
cd website
gsutil cp * gs://$PROJECT_ID-public
```

**Check my progress** *Copy website directory content into <PROJECT_ID>-public bucket*

..
..
..
...
.

..
.
.
.








