# GSP670 Leverage Apigee to Modernize Exposure & Secure Access

_Last update_: 2020-06-06

Reference: https://medium.com/@qwiklabs/leverage-apigee-to-modernize-exposure-secure-access-882345937e0b

### Tasks

1. Create a service account and key
1. Upload exported API proxy on storage bucket
1. Verify IAM permission and API proxy
1. Load log entries to Stackdriver Logging

## Create and configure the Stackdriver Extension instance on Apigee Edge

1. Sign in Apigee https://login.apigee.com/login

2. **Admin** > **Extensions** > **+ Add Extensions**

3. click on the **Google Stackdriver Logging** extension.

| Properties     |    Values     |
| ---------------|---------------|
| Name:          | `stackdriver-logging-extention` |
| Desp:          | None          |

click **Create**.

4. click the arrow (>) for the test environment 

#### Go back to Cloud Console, 

1. **Navigation Menu** > **IAM & admin** > **Service accounts**.

2. Click **Create Service Account**

| Properties     |    Values     |
| ---------------|---------------|
| Name:          | `apigee-stackdriver` |
| Desp:          | `Service account for Apigee Stackdriver integration`          |

click **Create**

**Select a Role** > **Logging** > **Logs Writer** permission.

Click **Continue**.

Click **Create Key** > **JSON**

#### Go back to Apigee,

Copy/paste the **Credential**

Click **Save**.

Click **Deploy**

> **Check my progress**
> Create a service account and key

## Import a SOAP service

In Apigee, **Develop** > **API Proxies**

Click the **+ Proxy** button

Select **SOAP Service**

| Properties     |    Values     |
| ---------------|---------------|
| URL  | `https://hipster-soap.apigee.io/hipster?wsdl` |
| Name | lab5-catalog  |
| Base Path | /lab5catalog/v1 |
| Description | Product Catalog |

Click `Validate`.

click **Next**

| Properties     |    Values     |
| ---------------|---------------|
| Security       |  API          |
| Quota          |  *Checked*    |

click **Next**

Check **Test** and Click **Next**.

Click **Next**.

On the summary tab, **test** only, then click **Create and deploy**

## Export your API Proxy

**lab5-catalog** > **Project** tab > click on **Download Revision**

## Create a cloud storage bucket & upload your app data in it

Create a bucket, then upload the **apiproxy** folder.

> **Check my progress**
> Upload exported API proxy on storage bucket

## Make your bucket publicly accessible

1 . three dot menu > **Edit bucket permissions**
2. Add members

**allUsers** > **Storage Admin**

> **Check my progress**
> Verify IAM permission and API proxy

## Securely access the REST API and trace the call flow

1. Click on the **Develop** tab 

2. click on the **+ Step** button at the top right.

3. Add **Extension Callout** > **Log**

4. Replace **input** element in the policy,

_Replace `PROJECT_ID_HERE` with Project ID for this lab._

```
   <Input><![CDATA[
         {  "logName": "example-log",
            "resource": {
                "type": "global",
                "labels": {
                    "project_id": "PROJECT_ID_HERE"
                }
            },
            "message":  {"Action":"{request.verb}", "ClientIP":"{client.ip}", "Apiproxyname":"{apiproxy.name}"}
        }
     ]]></Input>
```

Click **Save**

Click the **Trace** tab and click **Start trace session**

Open ![https://apigee.com/edge](https://apigee.com/edge)

Go to the **Publish** > **API Products** and then click on **+ API Product**

| Properties     |    Values     |
| ---------------|---------------|
| Name  | `lab5-catalog-Product` |
|  Display Name  | `lab5-catalog-Product` |
| Premission | Both `prod` and `test` |
| Access | `Public` |
| Add a proxy | `lab5-catalog` |
| Add a path | `/products` |

Click on **Save**

Go to the **Publish** > **Apps**, the click **+ App**

| Properties     |    Values     |
| ---------------|---------------|
| Name  | `Product App` |
| Display Name | `Product App` |
| Developer | _any available_ |
| Add product | `lab5-catalog-Product` |

click **Create**

Click **Show** to see the generated **Consumer Key**.

Navigate to the **API Products** > **lab5-catalog-Product** > **Edit**

| Properties     |    Values     |
| ---------------|---------------|
| Quota | *3* requests every *1* minute |

click **Save**

Open ![Apigee REST client](http://apigee-restclient.appspot.com/)

Copy and paste the **Consumer Key** to the end of 

http://<your-account-name>-eval.apigee.net/lab5catalog/v1/products?apikey=

Click **Send**.

In the Cloud Console, navigate to **Logging** > **Logs Viewer**.

> **Check my progress**
> Load log entries to Stackdriver Logging

Hit the **Send** button 5-6 times