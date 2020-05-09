# GSP716 Prisma Cloud Compute: Securing GKE Run Time

Last update: 2020-05-09

1. Create service account key
1. Create a deployment in NGFW project
1. Create a network peering from trust to default
1. Create a network peering from default to trust
1. Create a deployment in Apps project
1. Test the app deployment

## Deploy AutoScaling Template in NGFW Project

```bash
git clone https://github.com/PaloAltoNetworks/autoscale; cd autoscale/firewall

gcloud iam service-accounts list --filter=compute

export SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --filter=compute --format=json | jq -r '.[].email')
```

```bash
sed -i 's/INSERT_SERVICE_ACCOUNT_EMAIL_HERE/'"$SERVICE_ACCOUNT_EMAIL"'/g' vm-series-fw-nlb.yaml

sed -n 47p vm-series-fw-nlb.yaml

gcloud iam service-accounts keys create autoscale-key.json --iam-account $SERVICE_ACCOUNT_EMAIL

cloudshell dl autoscale-key.json

gcloud deployment-manager deployments create autoscale-fw-deployment --config vm-series-fw-nlb.yaml --automatic-rollback-on-error

gcloud projects list --filter=name:qwiklabs-gcp-*

export APPS_PROJECT_ID=$(gcloud projects list --filter=name:qwiklabs-gcp-* --format=json | jq -r '.[].projectId')
```

> **Check my progress**
> Create service account key.

> **Check my progress**
> Create a deployment in NGFW project.

```bash
gcloud beta compute networks peerings create ngfw-to-apps --network=trust --peer-network=default --export-custom-routes --import-custom-routes --peer-project $APPS_PROJECT_ID
```

> **Check my progress**
> Create a network peering from trust to default.

## Configure Panorama Autoscale Plugin

In the Cloud Console navigate to **Compute Engine** > **VM Instances**.

Open HTTPS:// <External IP> in a new tab, and click **Proceed Unsafe**

Log in to Panorama management console:

| username | password |
|----------|----------|
| `admin`  |`Paloalto123#!!`|

Select the **Panorama** tab

Scroll down in the left menu to **Google Cloud Platform** then click **Setup**

Select the **GCP Service Account** tab, then click the **Add** button

| Name |
|------|
|`Autoscale-SA`|

Click **Browse** and select the downloaded **autoscale-key.json** then click **OK**

In the left menu, select **AutoScaling** then click **Add**.

| Fields         | Values           |
|----------------|------------------|
| Device Group   | GCP-DG1          |
| Template Stack | GCP-TMPL-STK     |
| Licenses Management Only | _unchecked_ |

Click **OK**

Click **Commit** > **Commit to Panorama**

Select **Commit all Changes** and click **Commit**

Click **Close**

## Deploy apps template in Apps Project

```bash
gcloud projects list --filter=name:qwiklabs-gcp-*

export APPS_PROJECT_ID=$(gcloud projects list --filter=name:qwiklabs-gcp-* --format=json | jq -r '.[].projectId')

gcloud config set project $APPS_PROJECT_ID
```

```bash
gcloud projects list --filter=name:qwiklabs-PAN-NGFW*

export NGFW_PROJECT_ID=$(gcloud projects list --filter=name:qwiklabs-PAN-NGFW* --format=json | jq -r '.[].projectId')

gcloud beta compute networks peerings create apps-to-ngfw --network=default --peer-network=trust --export-custom-routes --import-custom-routes --peer-project $NGFW_PROJECT_ID

cd
cd autoscale/apps/

sed -i 's/NGFW_Project_ID/'"$NGFW_PROJECT_ID"'/' apps.yaml
sed -n 24p apps.yaml

sed -i 's/Apps_Project_ID/'"$APPS_PROJECT_ID"'/g' apps.yaml
sed -n 40p apps.yaml
sed -n 41p apps.yaml

gcloud pubsub topics list --filter=pano --project=$NGFW_PROJECT_ID
export TOPIC_NAME=$(gcloud pubsub topics list --filter=pano --project=$NGFW_PROJECT_ID --format=json | jq -r '.[].name')

sed -i 's/pubsub-topic_from_NGFW_PROJECT/'"$TOPIC_NAME"'/' apps.yaml
sed -n 48p apps.yaml

gcloud projects list --filter=name:qwiklabs-gcp-*
```

> **Check my progress**
> Create a network peering from default to trust.

From the **Navigation Menu**, navigate to **Pub/Sub** > **Topics**

Select the Topic beginning with **autoscale_fw_deployment**.

Click **ADD MEMEBER**

Paste in the **APPS_PROJECT_NUMBER** then type in "**@cloudservices.gserviceaccount.com**"

Select **Pub/Sub Admin** in Role

Click **SAVE**

```bash
gcloud deployment-manager deployments create autoscale-apps-deployment --config apps.yaml
sudo apt-get install wrk
```

> **Check my progress**
> Create a deployment in Apps project.

Go back to Panorama console, **Google Cloud Platform** > **Autoscaling** > **autoscale-fw-deployment** click on the **Show Status**

## Test the app deployment

Select the **Policies** tab, and under **NAT** select **Pre Rules**
From **Device Group** dropdown to select **GCP-DG1**

In the Cloud Console, go to **Network Services** > **Load Balancing**

Click **Frontends** tab, then copy the External Public IP address

Open the External IP in a new tab

> **Check my progress**
> Test the app deployment.

## Create a scale out event

wrk -d1020s -t6 -c400 -H"x-Spirent-Id: 00-00-00-00-00-00 03704600" --latency http://<EXTERNAL_LOAD_BALANCER_IP_ADDRESS>

In Cloud Console, select **Navigation menu** > **Compute Engine** > **Instance Groups** then Refresh

go back to **Compute Engine** > **VM Instances** and refresh to see the scaleout.