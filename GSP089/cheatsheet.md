# **GSP089** Cloud Monitoring: Qwik Start

_Last modified: 2020-12-28_
_Last verified: 2021-09-16_

- Create a Compute Engine instance / 25
- Add Apache2 HTTP Server to your instance / 25
- Get a success response over External IP of VM instance / 25
- Create an uptime check and alerting policy / 25

* * *

## Create a Compute Engine instance / 25<br>Add Apache2 HTTP Server to your instance / 25<br>Get a success response over External IP of VM instance / 25

## Create a Compute Engine instance

1. Run the following codes in Cloud Shell:

```bash
export PROJECT_ID=$(gcloud info --format='value(config.project)')

export SERVICE_ACCOUNT=$(gcloud --project=$PROJECT_ID iam service-accounts list --format=json |
 jq -r '.[] | select(.displayName=="Compute Engine default service account").email')

gcloud beta compute --project=${PROJECT_ID} instances create lamp-1-vm --zone=us-central1-a --machine-type=n1-standard-2 --tags=http-server

gcloud compute --project=${PROJECT_ID} firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

gcloud compute ssh lamp-1-vm --project ${PROJECT_ID} --zone us-central1-a

```

**Check my progress** _Create a Compute Engine instance (zone: us-central1-a)_

## Add Apache2 HTTP Server to your instance

2. Open an SSH window of the instance, and then run the codes below:

```bash
sudo apt-get update
sudo apt-get install apache2 php7.0 -y
sudo service apache2 restart

curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh
sudo apt-get install -y stackdriver-agent

curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh
sudo apt-get update
sudo apt-get install google-fluentd

```

**Check my progress** _Add Apache2 HTTP Server to your instance_

3. Open the **External IP** in a tab or a window.

**Check my progress** _Get a success response over External IP of VM instance_

## Create a Stackdriver account

1. Navigation menu > Monitoring
2. Click **NO THANKS!**
3. Click **Install Agents**, copy and paste the displayed commands in the VM SSH window.

## Create an uptime check

1. Click **Create Check**
2. In the left-hand menu, click **Uptime Checks** > **Uptime Checks Overview** > **Add Uptime Check**
3. Edit the New Uptime Check panel by adding the following:

- Title: `Lamp Uptime Check`
- Check type: `HTTP`
- Resource Type: `Instance`
- Applies to: `Single`, `lamp-1-vm`
- Path: `leave at default`
- Check every: `1 min`

4. Click **Test**
5. **Save**
6. Click **No Thanks**

## Create an alerting policy

1. In the left menu, click **Alerting** > **Create a Policy**
2. Click **Add Condition**
3. Name this policy:

`Inbound Traffic Alert`

4. Target
 - Resource Type: 
 
 `GCE VM Instance (gce_instance)`

 - Metric: 
 
 `Network traffic`
 
 agent.googleapis.com/interface/traffic

5. Configuration
    - Condition: `is above`
    - Threshold: `500 bytes`
    - For: `1 minute`

6. **Save**

7. Notifications: Select **Email Address**

8. Alert name: `Inbound Traffic Alert`

9. Save.

**Check my progress** _Create an uptime check and alerting policy_

## Test your knowledge
_Scroll to the end of the lab_

> Stackdriver supports which of the following cloud platforms?

- **Amazon Web Services**
- **Google Cloud Platform**


## Create a dashboard and chart

1. In the left-hand menu of Stackdriver Monitoring Console, select **Dashboards** > **Create Dashboard**.
2. Name the dashboard

 `Stackdriver LAMP Qwik Start Dashboard`
 
3. Click **Add Chart**
4. Click **Find resource type and metric**
5. Select `CPU Load (1m)`
6. **Save**
7. Click **Add Chart**
8. Click **Find resource type and metric**
9. Select `Received Packets`
10. **Save**


## View your logs
1. In the Stackdriver left-hand menu, click **Logging**
2. Select **GCE VM Instance** > **lamp-1-vm**
3. Select **syslog**
4. Click the **Start streaming logs** icon.