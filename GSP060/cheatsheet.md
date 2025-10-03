# **GSP060** Deployment Manager - Full Production

```bash
sudo apt-get update
sudo apt-get install -y virtualenv
virtualenv -p python3 venv
source venv/bin/activate
mkdir ~/dmsamples
cd ~/dmsamples
git clone https://github.com/GoogleCloudPlatform/deploymentmanager-samples.git
cd ~/dmsamples/deploymentmanager-samples/examples/v2
ls
cd nodejs/python
ls
sed -i '/maxSize/s/20/4/' nodejs.py
cat nodejs.py
gcloud compute zones list
sed -i 's/ZONE_TO_RUN/us-east1-d/g' nodejs.yaml
cat nodejs.yaml
```

## Deploy the application

```bash
gcloud deployment-manager deployments create advanced-configuration --config nodejs.yaml

gcloud compute forwarding-rules list
```

**Check my progress** _Deploy the application_

## Create a Stackdriver workspace

1. **Navigation menu** > **Monitoring**

2. Wait for your workspace to be provisioned.

3. Click on the **USE CLASSIC button** in the top-right corner:

4. select the **I was only testing** radio button and then click **OPT-OUT**:

## Configure an uptime check

1. **Uptime Checks** > **Create Uptime Check**

2. Specify the following:

| Property | Value  |
|----------|--------|
| Title	   | Check1 |
| Check Type | TCP  |
| Resource Type | URL |
| Hostname | <your forwarding address> |
| Port | 8080 |
| Response content contains the text | <leave blank> |
| Check every | 1 minute|

3. Click **Test**

4. **Save**, click **No, Thanks**

## Configure an alerting policy and notification

1. **Alerting** > **Create Policy**

2. Name:

   `Test`

3. Click on **Add Condition**

4.

| Property | Value|
|----------|------|
| Find resource type and metric | `GCE VM Instance` |
| Metrics | `CPU usage` |
| Condition | is above |
| Threshold | `20` |
| For | 1 minute |

5. Click **Save**

6. Add Email

7. Click **Save**

**Check my progress** _Configure an Uptime Check and Alert Policy in Stackdriver_

## Create a VM

```bash
sudo apt-get update

sudo apt-get -y install apache2-utils
```

**Check my progress** _Create a Test VM with ApacheBench_

## Test your knowledge

_Stackdriver collects metrics, events, and metadata from Google Cloud Platform, Amazon Web Services, hosted uptime probes, application instrumentation, and a variety of common application components including Cassandra, Nginx, Apache Web Server, Elasticsearch, and many others._

> True






