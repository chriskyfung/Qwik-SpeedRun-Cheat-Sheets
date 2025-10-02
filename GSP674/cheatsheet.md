# GSP674 Conditional Routing of APIs Based on Feature Flag

Login to Apigee (https://login.apigee.com/login)


Fill in the username, password, and organization of the Apigee account in the following commands and then run then in the Cloud Shell.

```bash
wget https://storage.googleapis.com/apigee-quest/scripts/lab13.rewind.sh
wget https://storage.googleapis.com/apigee-quest/apiproxies/lab13.apiproxy.zip
chmod +x lab13.rewind.sh;
export APIGEE_USER=<YOUR-MAIL-ADDRESS>
export APIGEE_PW=
export APIGEE_ORG=<YOUR-USER-NAME>-eval
./lab13.rewind.sh
```

In the Cloud Console, click on **Navigation Menu** > **IAM & admin** > **Service accounts**.

Create Service Account with 

- Name: `Create Service Account`
- Description: Service account for Apigee Stackdriver integration
- Role: **Logs Writer**

Create and download a JSON key.
Open the downloaded json file and copy All the file content.

* * *

In the Apigee console, navigate to **Admin** > **Extensions**.

Click on **Google Stackdriver Logging** at the end of the page.

- name: `stackdriver-logging-extension`

Click the arrow **>** for the **test** environment

Fill in the GCP Project ID.
Paste the copied JSON data as the Credential

* * *

In the Apigee console, navigate to **Develop** > **API Proxies**.

Open **lab13-catalog** > **Develop** tab.

Click on **Proxy Endpoints** > **PreFlow**.

Click on the **+ Step** button in the Response pipeline (**at the lower-left corner**)

Add **Extension Callout** and select the log extension.

.
.
.
.
