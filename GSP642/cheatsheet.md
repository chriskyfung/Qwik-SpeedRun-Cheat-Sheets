# GSP642 Importing Data to a Firestore Database

_last update: 2020-08-28_

## Set up Firestore in GCP

1. Open the **Navigation menu** and select **Firestore**, which is found in the Storage section:

2. **Select Native Mode**

3. Select a location, and then click **Create Database**.

## Write database import code

1. In Cloud Shell, 

```bash
git clone https://github.com/rosera/pet-theory && cd pet-theory/lab01

cat package.json

npm install @google-cloud/firestore
npm install @google-cloud/logging

cat package.json

edit importTestData.js
```

2. Add to `pet-theory/lab01/importTestData.js`

```js
const {Firestore} = require('@google-cloud/firestore');
const {Logging} = require('@google-cloud/logging');

const logName = 'pet-theory-logs-importTestData';

// Creates a Logging client
const logging = new Logging();
const log = logging.log(logName);

const resource = {
  type: 'global',
};
```

3. Add the following code underneath the `if (process.argv.length < 3)` conditional:

```js
const db = new Firestore();

function writeToFirestore(records) {
  const batchCommits = [];
  let batch = db.batch();
  records.forEach((record, i) => {
    var docRef = db.collection('customers').doc(record.email);
    batch.set(docRef, record);
    if ((i + 1) % 500 === 0) {
      console.log(`Writing record ${i + 1}`);
      batchCommits.push(batch.commit());
      batch = db.batch();
    }
  });
  batchCommits.push(batch.commit());
  return Promise.all(batchCommits);
}
```

4. Add to the `importCsv` function,

```js
await writeToFirestore(records);
```

5. Add in `importCsv` function just below the line `console.log(Wrote ${records.length} records)`,

```js
// A text log entry
success_message = `Success: importTestData - Wrote ${records.length} records`
const entry = log.entry({resource: resource}, {message: `${success_message}`});
log.write([entry]);
```

## Create test data

1. install the "faker" library and edit `createTestData.js`

```bash
npm install faker
edit createTestData.js
```

2. Add the following codes,

```js
const {Logging} = require('@google-cloud/logging');

const logName = 'pet-theory-logs-createTestData';

// Creates a Logging client
const logging = new Logging();
const log = logging.log(logName);

const resource = {
  // This example targets the "global" resource for simplicity
  type: 'global',
};
```

3. Add code to write the logs in the createTestData function just below the line console.log(Created file ${fileName} containing ${recordCount} records.); which will look like this:

```js
// A text log entry
const success_message = `Success: createTestData - Created file ${fileName} containing ${recordCount} records.`
const entry = log.entry({resource: resource}, {name: `${fileName}`, recordCount: `${recordCount}`, message: `${success_message}`});
log.write([entry]);
```

4. Run the following command to configure your GCP Project ID


```bash
export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud config set project $PROJECT_ID

node createTestData 1000

```

Create test data for the Firestore Database
**Check my progress**

* * *

## Import the test customer data

```bash
npm install csv-parse

node importTestData customers_1000.csv
```

Import test data into the Firestore Database
**Check my progress**

* * *

## Inspect the data in Firestore

1. Return to your GCP Console tab. In the **Navigation menu** click on **Firestore**. Once there, click on the pencil icon:

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
