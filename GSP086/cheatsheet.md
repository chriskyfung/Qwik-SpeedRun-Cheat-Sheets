# GSP086 Internet of Things: Qwik Start

_last updated on 2021-09-15_

## Create a Pub/Sub Topic + Create a device registry + Add a public key to the device

```bash
REGION=us-central1
REGISTRY_ID=my-registry
TOPIC_ID=cloud-builds
DEVICE_ID=my-device
PROJECT_ID=$GOOGLE_CLOUD_PROJECT

gcloud config set compute/region $REGION
gcloud config set project $PROJECT_ID

gcloud pubsub topics create cloud-builds

gcloud iot registries create $REGISTRY_ID \
    --region $REGION \
    --event-notification-config=topic=$TOPIC_ID
    --enable-mqtt-config

openssl req -x509 -newkey rsa:2048 -keyout rsa_private.pem -nodes \
    -out rsa_cert.pem -subj "/CN=unused"

ls

gcloud iot devices create $DEVICE_ID \
  --region $REGION \
  --registry=$REGISTRY_ID \
  --public-key path=rsa_cert.pem,type=rsa-x509-pem
```

> Add a device to the registry.
^
> Add a public key to the device.

## Run a Node.js sample to connect a virtual device and view telemetry

```bash
git clone https://github.com/googleapis/nodejs-iot
cd nodejs-iot/samples/mqtt_example

cp ../../../rsa_private.pem .

npm install

gcloud pubsub subscriptions create \
    projects/$PROJECT_ID/subscriptions/my-subscription \
    --topic=projects/$PROJECT_ID/topics/cloud-builds

```

> create a subscription

```bash
wget https://pki.goog/roots.pem

node cloudiot_mqtt_example_nodejs.js \
    mqttDeviceDemo \
    --projectId=$PROJECT_ID \
    --cloudRegion=us-central1 \
    --registryId=my-registry \
    --deviceId=my-device \
    --privateKeyFile=rsa_private.pem \
    --numMessages=25 \
    --algorithm=RS256 \
    --serverCertFile=roots.pem \
    --mqttBridgePort=443

gcloud pubsub subscriptions pull --auto-ack \
    projects/$PROJECT_ID/subscriptions/my-subscription

```

## Test your knowledge

> Google Cloud IoT platform, provides a complete solution for collecting, processing, analyzing, and visualizing IoT data in real time to support improved operational efficiency.
>
> **True**
