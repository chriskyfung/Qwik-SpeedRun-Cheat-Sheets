# **GSP431** Implement a Helpdesk Chatbot with Dialogflow & BigQuery ML

Last update: 2020-05-05

Tasks:

1. Create a BigQuery dataset
2. Create a new table in BigQuery dataset
3. Build an ML model to predicts time taken to resolve an issue
4. Run the query to evaluate the ML model
5. Create a Dialogflow Agent
6. Import an IT Helpdesk Agent
7. Create a Fulfillment that Integrates with BigQuery

**The best way is to just follow the steps on the lab page!**

---------------------------------------------------------------------------

## Train a Model Using BigQuery Machine Learning

1. Click on **Navigation menu** > **BigQuery**

2. Click **CREATE DATASET**. For Dataset ID, type<br><br>

   `helpdesk`

   <br>**Create dataset**

> **Test Completed Task**
> Create a BigQuery dataset

3. Click **helpdesk**, then click **Create Table**

| Properties | Values |
| -----------| -------|
| Create table from | Google Cloud Storage |
| Select file from | `gs://solutions-public-assets/smartenup-helpdesk/ml/issues.csv` |
| File format | CSV |
| Table name | issues |
| Auto detect | Check box for **Schema and input parameters** |
| Advanced options > Header rows to skip | 1 | 

_It will take about 30 seconds_

> **Test Completed Task**
> Create a new table in BigQuery dataset

In Query editor add the following query:


```sql
SELECT * FROM `helpdesk.issues` LIMIT 1000
```

```sql
CREATE OR REPLACE MODEL `helpdesk.predict_eta_v0`
OPTIONS(model_type='linear_reg') AS
SELECT
 category,
 resolutiontime as label
FROM
  `helpdesk.issues`
```

_It takes about 1 minute_

> **Test Completed Task**
> Build an ML model to predicts time taken to resolve an issue

```sql
WITH eval_table AS (
SELECT
 category,
 resolutiontime as label
FROM
  helpdesk.issues
)
SELECT
  *
FROM
  ML.EVALUATE(MODEL helpdesk.predict_eta_v0,
    TABLE eval_table)
```

```sql
CREATE OR REPLACE MODEL `helpdesk.predict_eta`
OPTIONS(model_type='linear_reg') AS
SELECT
 seniority,
 experience,
 category,
 type,
 resolutiontime as label
FROM
  `helpdesk.issues`
```

```sql
WITH eval_table AS (
SELECT
 seniority,
 experience,
 category,
 type,
 resolutiontime as label
FROM
  helpdesk.issues
)
SELECT
  *
FROM
  ML.EVALUATE(MODEL helpdesk.predict_eta,
    TABLE eval_table)
```

> **Test Completed Task**
> Run the query to evaluate the ML model

```sql
WITH pred_table AS (
SELECT
  5 as seniority,
  '3-Advanced' as experience,
  'Billing' as category,
  'Request' as type
)
SELECT
  *
FROM
  ML.PREDICT(MODEL `helpdesk.predict_eta`,
    TABLE pred_table)
```

## Create a Dialogflow Agent

1. Click https://dialogflow.com/

2. Click **Create Agent**

> **Test Completed Task**
> Create a Dialogflow Agent

## Import Intents & Entities for a Simple Helpdesk Agent

1. Download settings file from https://github.com/googlecodelabs/cloud-dialogflow-bqml/raw/master/ml-helpdesk-agent.zip

2. In the Diagflow console, click 三 icon

3. Click on the gear icon

4. Click on **Export and Import**

5. Select **Import from zip**

6. Select the zip file

7. Type `IMPORT`

8. Click **Import** and **Done**

> **Test Completed Task**
> Import an IT Helpdesk Agent

## Use the Inline Editor to create a fulfillment that integrates with BigQuery

1. Click on **Fulfillment**

2. Enable **Inline Editor**

3. Copy to **index.js** tab

```js
/**
* Copyright 2017 Google Inc. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

"use strict";

const functions = require("firebase-functions");
const { WebhookClient } = require("dialogflow-fulfillment");
const { Card } = require("dialogflow-fulfillment");
const BIGQUERY = require("@google-cloud/bigquery");

const BIGQUERY_CLIENT = new BIGQUERY({
projectId: "your-project-id" // ** CHANGE THIS **
});

process.env.DEBUG = "dialogflow:debug";

exports.dialogflowFirebaseFulfillment = functions.https.onRequest(
(request, response) => {
  const agent = new WebhookClient({ request, response });
  console.log(
    "Dialogflow Request headers: " + JSON.stringify(request.headers)
  );
  console.log("Dialogflow Request body: " + JSON.stringify(request.body));

  function welcome(agent) {
    agent.add(`Welcome to my agent!`);
  }

  function fallback(agent) {
    agent.add(`I didn't understand`);
    agent.add(`I'm sorry, can you try again?`);
  }

  function ticketCollection(agent) {
    // Capture Parameters from the Current Dialogflow Context
    console.log('Dialogflow Request headers: ' + JSON.stringify(request.headers));
    console.log('Dialogflow Request body: ' + JSON.stringify(request.body));
    const OUTPUT_CONTEXTS = request.body.queryResult.outputContexts;
    const EMAIL = OUTPUT_CONTEXTS[OUTPUT_CONTEXTS.length - 1].parameters["email.original"];
    const ISSUE_CATEGORY = OUTPUT_CONTEXTS[OUTPUT_CONTEXTS.length - 1].parameters.category;
    const ISSUE_TEXT = request.body.queryResult.queryText;


    // The SQL Query to Run
    const SQLQUERY = `WITH pred_table AS (SELECT 5 as seniority, "3-Advanced" as experience,
          @category as category, "Request" as type)
          SELECT cast(predicted_label as INT64) as predicted_label
          FROM ML.PREDICT(MODEL helpdesk.predict_eta,  TABLE pred_table)`;

    const OPTIONS = {
      query: SQLQUERY,
      // Location must match that of the dataset(s) referenced in the query.
      location: "US",
      params: {
        category: ISSUE_CATEGORY
      }
    };
    return BIGQUERY_CLIENT.query(OPTIONS)
      .then(results => {
        //Capture results from the Query
        console.log(JSON.stringify(results[0]));
        const QUERY_RESULT = results[0];
        const ETA_PREDICTION = QUERY_RESULT[0].predicted_label;

        //Format the Output Message
        agent.add( EMAIL + ", your ticket has been created. Someone will you contact shortly. " +
            " The estimated response time is " + ETA_PREDICTION  + " days."
        );
        agent.add(
          new Card({
            title:
              "New " + ISSUE_CATEGORY +
              " Request for " + EMAIL +
              " (Estimated Response Time: " + ETA_PREDICTION  +
              " days)",
            imageUrl:
              "https://developers.google.com/actions/images/badges/XPM_BADGING_GoogleAssistant_VER.png",
            text: "Issue description: " + ISSUE_TEXT,
            buttonText: "Go to Ticket Record",
            buttonUrl: "https://assistant.google.com/"
          })
        );
        agent.setContext({
          name: "submitticket-collectname-followup",
          lifespan: 2
        });
      })
      .catch(err => {
        console.error("ERROR:", err);
      });
  }

  // Run the proper function handler based on the matched Dialogflow intent name
  let intentMap = new Map();
  intentMap.set("Default Welcome Intent", welcome);
  intentMap.set("Default Fallback Intent", fallback);
  intentMap.set("Submit Ticket - Issue Category", ticketCollection);
  agent.handleRequest(intentMap);
}
);
```

Replace `your-project-id` with your **Project ID**

Copy to **package.json** tab

```json
{
   "name": "dialogflowFirebaseFulfillment",
   "description": "Dialogflow Fulfillment Library quick start sample",
   "version": "0.0.1",
   "private": true,
   "license": "Apache Version 2.0",
   "author": "Google Inc.",
   "engines": {
     "node": ">=6.0"
   },
   "scripts": {
     "start": "firebase serve --only functions:dialogflowFirebaseFulfillment",
     "deploy": "firebase deploy --only functions:dialogflowFirebaseFulfillment"
   },
   "dependencies": {
     "firebase-admin": "^4.2.1",
     "firebase-functions": "^0.5.7",
     "dialogflow-fulfillment": "0.3.0-beta.3",
     "@google-cloud/bigquery": "^1.3.0"

   }
}
```

Click **Deploy**

> **Test Completed Task**
> Create a Fulfillment that Integrates with BigQuery

## Enable webhook for fulfillment

1. go back to **Indents**

2. Expand **Submit Ticket**

3. Click on **Submit Ticket - Issue Category**

4. In the **Fulfillment** section, **Enable webhook call for the intent**

## Test your chatbot


