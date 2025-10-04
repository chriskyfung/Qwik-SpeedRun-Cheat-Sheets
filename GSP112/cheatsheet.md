# **GSP112** Cloud Security Scanner: Qwik Start

Last update: 2020-03-21

1. Deploy sample App Engine application

## Before you begin, you need an app to scan

```bash
git clone https://github.com/GoogleCloudPlatform/python-docs-samples

cd python-docs-samples/appengine/standard_python37/hello_world

dev_appserver.py app.yaml
```

## Test App

Preview on port 8080

Ctrl+c

## Deploy App

```bash
gcloud app deploy

# Click Y
```

## View App

```bash
gcloud app browse
```

**Test Completed Task**

_Deploy sample App Engine application_

## Test your Understanding

> Cloud Security Scanner is a web security scanner for common vulnerabilities in Google App Engine applications.

**True**

## Run the scan

Navigation menu > App Engine > Security scans

Click Enable API > Create scan.

Click Save

Click Run