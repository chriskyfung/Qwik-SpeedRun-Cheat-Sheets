**GSP642** Importing Data to a Firestore Database

_last update: 2020-08-28_

## Set up Firestore in GCP

1. Open the **Navigation menu** and select **Firestore**, which is found in the Storage section:

2. **Select Native Mode**

3. Select a location, and then click **Create Database**.

## Write database import code

1. In Cloud Shell, 

```bash
git clone https://github.com/rosera/pet-theory && cd pet-theory/lab01

npm install @google-cloud/firestore
npm install @google-cloud/logging
npm install faker

wget https://raw.githubusercontent.com/chriskyfung/Qwik-SpeedRun-Cheat-Sheets/GSP642/importTestData.js

mv importTestData.js.1 importTestData.js

wget https://raw.githubusercontent.com/chriskyfung/Qwik-SpeedRun-Cheat-Sheets/GSP642/createTestData.js

mv createTestData.js.1 createTestData.js

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud config set project $PROJECT_ID

node createTestData 1000
```

> **Check my progress**
> 
> Create test data for the Firestore Database

* * *

## Import the test customer data

```bash
npm install csv-parse

node importTestData customers_1000.csv
```

> **Check my progress**
>
> Import test data into the Firestore Database

* * *

## Add a developer to the project without giving them Firestore access

```bash
 export SECOND_USER_ID=
```

```bash
 gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=user:$SECOND_USER_ID --role=roles/logging.viewer

 gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=user:$SECOND_USER_ID --role=roles/source.writer
```

> **Check my progress**
>
> Add a developer to the project without giving them Firestore access (role: logging.viewer)

> **Check my progress**
>
> Add a developer to the project without giving them Firestore access (role: source.writer)