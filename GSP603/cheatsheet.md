# GSP603 Tracking Cryptocurrency Exchange Trades with Google Cloud Platform in Real-Time

_Last update_: 2020-06-20

📹 https://youtu.be/YgM6vQTUUxQ

### Tasks

1. Create a virtual machine to perform the creation of the pipeline and use as your website. / 20
1. Create the bigtable instance. / 20
1. Create a Google Cloud Storage bucket / 20
1. Run the daraflow pipeline / 20
1. Create a firewall rule to allow tcp:5000 for visualization. / 20

## Activate Cloud Shell

## Create your lab resources

```bash
gcloud beta compute instances create crypto-driver \
--zone=us-central1-a \
--machine-type=n1-standard-1 \
--subnet=default \
--network-tier=PREMIUM \
--maintenance-policy=MIGRATE \
--service-account=$(gcloud iam service-accounts list --format='value(email)' --filter="compute") \
--scopes=https://www.googleapis.com/auth/cloud-platform \
--image=debian-9-stretch-v20181210 \
--image-project=debian-cloud \
--boot-disk-size=20GB \
--boot-disk-type=pd-standard \
--boot-disk-device-name=crypto-driver

export PROJECT=$(gcloud info --format='value(config.project)')
export ZONE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google"|cut -d/ -f4)

gsutil mb -p ${PROJECT} gs://realtimecrypto-${PROJECT}

gcloud compute --project=${PROJECT} firewall-rules create crypto-dashboard \
--direction=INGRESS \
--priority=1000 \
--network=default \
--action=ALLOW \
--rules=tcp:5000 \
--source-ranges=0.0.0.0/0 \
--target-tags=crypto-console \
--description="Open port 5000 for crypto visualization tutorial"

gcloud compute instances add-tags crypto-driver --tags="crypto-console" --zone=${ZONE}
```

> **Check my progress**
> Create a virtual machine to perform the creation of the pipeline and use as your website.

> **Check my progress** in Connect to the instance via SSH
> Create a Google Cloud Storage bucket

> **Check my progress** in Visualizing the data
> Open firewall port 5000 for visualization

## Connect to the instance via SSH

```bash
sudo -s
apt-get update -y

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo pip3 install virtualenv
virtualenv -p python3 venv
source venv/bin/activate
sudo apt -y --allow-downgrades install openjdk-8-jdk git maven google-cloud-sdk=271.0.0-0 google-cloud-sdk-cbt=271.0.0-0
```

Create the Bigtable resource

```bash
export PROJECT=$(gcloud info --format='value(config.project)')
export ZONE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google"|cut -d/ -f4)
gcloud services enable bigtable.googleapis.com \
bigtableadmin.googleapis.com \
dataflow.googleapis.com \
--project=${PROJECT}

gcloud bigtable instances create cryptorealtime \
    --cluster=cryptorealtime-c1 \
    --cluster-zone=${ZONE} \
    --display-name=cryptorealtime \
    --cluster-storage-type=HDD \
    --instance-type=DEVELOPMENT
cbt -instance=cryptorealtime createtable cryptorealtime families=market

git clone https://github.com/GoogleCloudPlatform/professional-services
cd professional-services/examples/cryptorealtime
mvn clean install
```

> **Check my progress**
> Create the Bigtable instance

```bash
./run.sh ${PROJECT} \
cryptorealtime gs://realtimecrypto-${PROJECT}/temp \
cryptorealtime market

cbt -instance=cryptorealtime read cryptorealtime
```

> **Check my progress**
> Run the Dataflow pipeline

## Examine the Dataflow pipeline

In the Cloud Console, **Navigation** > **Dataflow**.

## Visualizing the data

Go back to the SSH session,

```bash
cd frontend/
pip install -r requirements.txt
python app.py ${PROJECT} cryptorealtime cryptorealtime market
```

Open another SSH session

```bash
export EXTERNAL_IP=`gcloud compute instances list --format='value(EXTERNAL
_IP)' --filter="name:crypto-driver"`

echo http://$EXTERNAL_IP:5000/stream
```

## Clean up

```bash
gsutil -m rm -r gs://realtimecrypto-${PROJECT}/*
gsutil rb gs://realtimecrypto-${PROJECT}

gcloud bigtable instances delete cryptorealtime

gcloud dataflow jobs cancel \
$(gcloud dataflow jobs list \
--format='value(id)' \
--filter="name:runthepipeline*")
```