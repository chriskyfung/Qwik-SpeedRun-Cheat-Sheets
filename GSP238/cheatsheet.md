# **GSP238** Write Apps That Access G Suite APIs

Last update: 2020-03-21

1. Create the credentials
2. Create a cloud storage bucket
3. Upload credential file in storage bucket
4. Add Files to your Google Drive and run the application

## The Google Drive API

Navigation menu > APIs & Services > Library

ENABLE `Google Drive API`

## Obtain project credentials

Navigation menu > APIs & Services > Credentials

Create credentials > Help me choose

| Question                 | Answer           |
|--------------------------|------------------|
| Which API are you using? | Google Drive API |
| Where will you be calling the API from?| Other UI (e.g. Windows, CLI tool) |
| What data will you be accessing? | User data |

#### SET UP CONSENT SCREEN

Application name:

`Sample App`

#### Create OAUTH client ID

Download credentials

Rename `client_id.json` to

`credentials.json`

**Test Completed Task**

_Create the credentials_

## Upload credentials.json to the project file

Navigation menu > Storage > Browser

Click **Create bucket**

**Test Completed Task**

_Create a cloud storage bucket_

Upload `credentials.json`

**Test Completed Task**

_Upload credential file in storage bucket_

```bash
mkdir gdrive_api_lab
cd gdrive_api_lab

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gsutil cp gs://${PROJECT_ID}/credentials.json .


cat > package.json <<EOF
{
  "name": "google-drive-nodejs-quickstart",
  "version": "1.0.0",
  "description": "A simple Node.js command-line application that makes requests to the Google Drive API.",
  "private": true,
  "dependencies": {
    "@google-cloud/logging": "^4.2.0",
    "googleapis": "^27.0.0"
  },
  "devDependencies": {},
  "engines": {
    "node": ">=6.4.0"
  },
  "scripts": {
    "start": "node ."
  },
  "license": "Apache-2.0"
}
EOF

nano index.js

const fs = require('fs');
const readline = require('readline');
const {google} = require('googleapis');
const {Logging} = require('@google-cloud/logging');
// If modifying these scopes, delete token.json.
const SCOPES = ['https://www.googleapis.com/auth/drive.metadata.readonly'];
const TOKEN_PATH = 'token.json';
const logName = 'drive-logs';

// Creates a client
const logging = new Logging();
const log = logging.log(logName);

const resource = {
  // This example targets the "global" resource for simplicity
  type: 'global',
};

// Load client secrets from a local file.
fs.readFile('credentials.json', (err, content) => {
  if (err) return console.log('Error loading client secret file:', err);
  // Authorize a client with credentials, then call the Google Drive API.
  authorize(JSON.parse(content), listFiles);
});

/**
 * Create an OAuth2 client with the given credentials, and then execute the
 * given callback function.
 * @param {Object} credentials The authorization client credentials.
 * @param {function} callback The callback to call with the authorized client.
 */
function authorize(credentials, callback) {
  const {client_secret, client_id, redirect_uris} = credentials.installed;
  const oAuth2Client = new google.auth.OAuth2(
      client_id, client_secret, redirect_uris[0]);

  // Check if we have previously stored a token.
  fs.readFile(TOKEN_PATH, (err, token) => {
    if (err) return getAccessToken(oAuth2Client, callback);
    oAuth2Client.setCredentials(JSON.parse(token));
    callback(oAuth2Client);
  });
}

/**
 * Get and store new token after prompting for user authorization, and then
 * execute the given callback with the authorized OAuth2 client.
 * @param {google.auth.OAuth2} oAuth2Client The OAuth2 client to get token for.
 * @param {getEventsCallback} callback The callback for the authorized client.
 */
function getAccessToken(oAuth2Client, callback) {
  const authUrl = oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SCOPES,
  });
  console.log('Authorize this app by visiting this url:', authUrl);
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });
  rl.question('Enter the code from that page here: ', (code) => {
    rl.close();
    oAuth2Client.getToken(code, (err, token) => {
      if (err) return console.error('Error retrieving access token', err);
      oAuth2Client.setCredentials(token);
      // Store the token to disk for later program executions
      fs.writeFile(TOKEN_PATH, JSON.stringify(token), (err) => {
        if (err) console.error(err);
        console.log('Token stored to', TOKEN_PATH);
      });
      callback(oAuth2Client);
    });
  });
}

/**
 * Lists the names and IDs of up to 10 files.
 * @param {google.auth.OAuth2} auth An authorized OAuth2 client.
 */
function listFiles(auth) {
  const drive = google.drive({version: 'v3', auth});
  drive.files.list({
    pageSize: 10,
    fields: 'nextPageToken, files(id, name)',
  }, (err, res) => {
    if (err) return console.log('The API returned an error: ' + err);
    const files = res.data.files;
    if (files.length) {
      console.log('Files:');
      files.map((file) => {
        console.log(`${file.name} (${file.id})`);
        if ((`${file.name}`) != "Getting started")
        {
        // A text log entry
        const entry = log.entry(
            {resource: resource},
            {
                name: `${file.name}`,
                id: `${file.id}`
            }
        );
        log.write([entry]);
        }
      });
    } else {
      console.log('No files found.');
    }
  });
}
```

## Run the Application

```bash
npm install

npm audit fix

node .
```

Click on the URL provided in the output.

Copy the code provided and paste it in Cloud Shell.

## Add Files to Your Google Drive

Open a new tab in your browser
[https://drive.google.com/drive/my-drive](https://drive.google.com/drive/my-drive)

New > Google Docs

Rename the file **API Test 1**

New > Google Docs

Rename the file **API Test 2**

## Run the Application

```bash
ls

node .
```

**Test Completed Task**

_Add Files to your Google Drive and run the application_

## Test your Understanding

> You can access G Suite APIs using NodeJs application only.

**False**


