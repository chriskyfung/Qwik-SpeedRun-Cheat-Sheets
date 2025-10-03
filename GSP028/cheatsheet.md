# **GSP028** Deploy Node.js Express Application in App Engine

Last update : 2020-03-11

**Steps:**

1. Deploying the Application into App Engine
2. Updating the Application

## Get the Getting Started Example source code

```bash
git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples.git && cd nodejs-docs-samples/appengine/hello-world/flexible

npm install

npm start
```

## Run the Application Locally

**preview on port 8080**

## Deploying the Application into App Engine

```bash
gcloud app deploy
# choose **us-central**.
# Enter `y`.
```

choose **us-central**.

Enter `y`.

**Test Completed Task**

*Deploying the Application into App Engine*

## Updating the Application

open a new Cloud Shell

```
nano app.js
// Copyright 2017 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

'use strict';

// [START gae_flex_quickstart]
const express = require('express');
const uuid = require('uuid/v4');

const app = express();

app.get('/', (req, res) => {
  res
    .status(200)
    .send(`Hello, ${uuid()}!`)
    .end();
});

// Start the server
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`App listening on port ${PORT}`);
  console.log('Press Ctrl+C to quit.');
});
// [END gae_flex_quickstart]

module.exports = app;
```

cp app.js nodejs-docs-samples/appengine/hello-world/flexible
cd nodejs-docs-samples/appengine/hello-world/flexible
cat app.js
```

```bash
cd nodejs-docs-samples/appengine/hello-world/flexible
npm install uuid --save
npm start
#
```

```bash
gcloud app deploy
#
```

**Test Completed Task**

*Updating the Application*
