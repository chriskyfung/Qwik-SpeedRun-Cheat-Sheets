# GSP336 Build and Manage APIs with Apigee: Challenge Lab

Topics tested:

Create an API Facade and add functionality
Share the APIs with partners through a developer portal
Route traffic to different backend implementations of the API

Prerequisites
Apigee Account - If you don't have an Apigee account, sign-up for a trial account. You are notified through the registered email once Apigee creates the account. This could take a few minutes. Remember the email you signed up with and the password you set - to use later in the lab.

https://login.apigee.com/login

If not already, log onto the Apigee console and then note the organization you are working in. The organization name can be found on the top-left corner of the Apigee console after you log in.

## Task 1 - Create API Specification and Generate an API Proxy

### Define a RESTful API in Apigee using an API specification

https://storage.googleapis.com/apigee-quest/data/ourbank-verification-v1.yaml

from https://docs.apigee.com/api-platform/samples/mock-target-api

copy https://mocktarget.apigee.net/json to Target

Make sure you enable CORS headers in Apigee

### Provision a Mock Response in Apigee

The updated Assign Message Policy should look like:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<AssignMessage async="false" continueOnError="false" enabled="true" name="Assign-Message-1">
    <DisplayName>Assign Message-1</DisplayName>
    <Properties/>
    <Copy source="request">
        <Headers/>
        <QueryParams/>
        <FormParams/>
        <Payload/>
        <Verb/>
        <StatusCode/>
        <ReasonPhrase/>
        <Path/>
    </Copy>
    <Remove>
        <Headers>
            <Header name="h1"/>
        </Headers>
        <QueryParams>
            <QueryParam name="q1"/>
        </QueryParams>
        <FormParams>
            <FormParam name="f1"/>
        </FormParams>
        <Payload/>
    </Remove>
    <Add>
        <Headers/>
        <QueryParams/>
        <FormParams/>
    </Add>
    <Set>
        <Payload contentType="application/json">
          {"valid":true,"message":"mock response"}
      </Payload>
    </Set>
    <AssignVariable>
        <Name>name</Name>
        <Value/>
        <Ref/>
    </AssignVariable>
    <IgnoreUnresolvedVariables>true</IgnoreUnresolvedVariables>
    <AssignTo createNew="false" transport="http" type="request"/>
</AssignMessage>
```

### Testing
The deployment can be tested using the following curl statement:

In the Cloud Shell, run the following commands to verify the API.

```bash
export APIGEE_ORG=<YOUR_APIGEE_ORG_NAME>

curl -X POST \
  'https://${APIGEE_ORG}-test.apigee.net/verification-api-v1/verifyCard' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'postman-token: 89236919-eabe-4357-e4c4-079f20ecd798' \
  -d '{
    "number": "2221005276762844",
    "cvv": "345",
    "expiration": "10/2025"
  } '
```

### Upload API Proxy bundle to GCS

Download Revision

Extract the downloaded Zip file

In the Cloud Console, click on **Navigation Menu** > **Storage**.

Create a new bucket.

Upload the folder to the bucket.

## Task 2 - Add Policies to the API Proxy

### Create a service account with permissions to write logs

In the Cloud Console, click on **Navigation Menu** > **IAM & admin** > **Service accounts**.

Click **Create Service Account**, then enter the following:

Service account name: `apigee-stackdriver`
Service account description: `Service account for Apigee Stackdriver integration`

Then click **Create**.

Click into **Select a Role** field and choose **Logging** > **Logs Writer** permission. Click **Continue** then click **Done**.

After creating service account 'apigee-stackdriver', click on three dots at the right corner and click **Create Key** in the dropdown, then **Create** to download your JSON output.

### Create an extension and deploy it to test the environment using this service account.

Go back to the Apigee console, naviagte to **Admin** > **Extensions** from the left navigation menu, then **+ Add Extension** to create a new extension.

On the new Extension Properties page, click on the **Google Stackdriver Logging** extension.

Enter a name (e.g. `stackdriver-logging-extension`) and an optional description for the Extension instance, then click **Create**.

On the Extension detail page, click the arrow (>) for the test environment to configure the instance for the Apigee environment.

In the configuration dialog. enter the following information:

- Select the latest extension version from the Version drop-down list.
- Add your GCP Project ID (which you can get from the Home Console).
- Open the downloaded JSON file and copy/paste the contents into the Credential field in the Apigee UI.

Click **Save**.

Once the configuration is saved, click on the **Deploy** button for the Test environment.

### Create an Extension policy in the PostFlow response path

In the Apigee console, navigate to **Develop** > **API Proxies** from the left menu.

Click to open **Verification-API-v1** from the proxy list.

Click the **Develop** tab in the top right.

To add a policy to your proxy, click on **Proxy Endpoints** → **PreFlow** in the Navigator tab, then in the *Response* pipeline, click **+ Step** to add a step.

### Create an API Product and an App, then send a request with valid API Key in apikey query parameter.

### Testing

```bash
export APIKEY=

curl -X POST \
  'https://${APIEE_ORG}-test.apigee.net/verification-api-v1/verifyCard?apikey=${APIKEY}' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'postman-token: 89236919-eabe-4357-e4c4-079f20ecd798' \
  -d '{
    "number": "2221005276762844",
    "cvv": "345",
    "expiration": "10/2025"
  } '
```

```json
{"valid":true,"message":"mock response"}
```

```json
{"fault":{"faultstring":"Invalid ApiKey","detail":{"errorcode":"oauth.v2.InvalidApiKey"}}}
```

## Task 3 - Create a Developer Portal for consuming the APIs

## Task 4 - Route traffic from mock response to real backend

```bash
mkdir bank-verification-service; cd bank-verification-service
wget https://storage.googleapis.com/apigee-quest/code/index.js
wget https://storage.googleapis.com/apigee-quest/code/package.json
gcloud functions deploy verifyCard --runtime nodejs10 --trigger-http --allow-unauthenticated
gcloud functions deploy verifyAddress --runtime nodejs10 --trigger-http --allow-unauthenticated
```



mock preflow

<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<TargetEndpoint name="mock">
    <Description/>
    <FaultRules/>
    <PreFlow name="PreFlow">
        <Request>
            <Step>
                <Name>Keep-Target-URL</Name>
            </Step>
        </Request>
        <Response/>
    </PreFlow>
    <PostFlow name="PostFlow">
        <Request/>
        <Response>
            <Step>
                <Name>Assign-Message-1</Name>
            </Step>
        </Response>
    </PostFlow>
    <Flows/>
    <HTTPTargetConnection>
        <Properties/>
        <URL>https://mocktarget.apigee.net/json</URL>
    </HTTPTargetConnection>
</TargetEndpoint>


mock postflow

<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<TargetEndpoint name="mock">
    <Description/>
    <FaultRules/>
    <PreFlow name="PreFlow">
        <Request>
            <Step>
                <Name>Keep-Target-URL</Name>
            </Step>
        </Request>
        <Response/>
    </PreFlow>
    <PostFlow name="PostFlow">
        <Request/>
        <Response>
            <Step>
                <Name>Assign-Message-1</Name>
            </Step>
        </Response>
    </PostFlow>
    <Flows/>
    <HTTPTargetConnection>
        <Properties/>
        <URL>https://mocktarget.apigee.net/json</URL>
    </HTTPTargetConnection>
</TargetEndpoint>

change the default preflow

<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<TargetEndpoint name="default">
    <PreFlow name="PreFlow">
        <Request/>
        <Response>
            <Step>
                <Name>add-cors</Name>
            </Step>
        </Response>
    </PreFlow>
    <Flows/>
    <PostFlow name="PostFlow">
        <Request/>
        <Response/>
    </PostFlow>
    <HTTPTargetConnection>
        <URL>https://us-central1-qwiklabs-gcp-00-2a1fe279c569.cloudfunctions.net</URL>
    </HTTPTargetConnection>
</TargetEndpoint>

change the default postflow

<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<TargetEndpoint name="default">
    <PreFlow name="PreFlow">
        <Request/>
        <Response>
            <Step>
                <Name>add-cors</Name>
            </Step>
        </Response>
    </PreFlow>
    <Flows/>
    <PostFlow name="PostFlow">
        <Request/>
        <Response/>
    </PostFlow>
    <HTTPTargetConnection>
        <URL>https://us-central1-qwiklabs-gcp-00-2a1fe279c569.cloudfunctions.net</URL>
    </HTTPTargetConnection>
</TargetEndpoint>

add to Proxy Endpoints > default > preflow

    <RouteRule name="mock">
        <Condition>request.queryparam.mock = "true"</Condition>
        <TargetEndpoint>mock</TargetEndpoint>
    </RouteRule>