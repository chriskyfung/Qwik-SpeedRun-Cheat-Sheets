GSP010 Distributed Image Processing in Cloud Dataproc
===

**Requirements:**
1. Create a development machine in Compute Engine
2. Install Software in the development machine
3. Create a GCS bucket
4. Download some sample images into your bucket
5. Create a Cloud Dataproc cluster
6. Submit your job to Cloud Dataproc

## Create a development machine in Compute Engine

**Compute Engine** > **VM Instances** > **Create**

Name:
`devhost`

Machine Type: **2 vCPUs (n1-standard-2 instance)**

Identity and API Access: **Allow full access to all Cloud APIs**

**Check my progress**


## Install Software

**SSH**

```bash
sudo apt-get install -y dirmngr
```

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https
```

```bash
echo "deb https://dl.bintray.com/sbt/debian /" | \
sudo tee -a /etc/apt/sources.list.d/sbt.list

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
sudo apt-get update
sudo apt-get install -y bc scala sbt
```

```bash
sudo apt-get update
git clone https://github.com/GoogleCloudPlatform/cloud-dataproc
cd cloud-dataproc/codelabs/opencv-haarcascade
sbt assembly
```

**Check my progress**

* * *

_This step can be executed in another SSH session_

## Create a Cloud Dataproc cluster

```bash
MYCLUSTER="${USER/_/-}-qwiklab"
echo MYCLUSTER=${MYCLUSTER}
gcloud config set compute/zone us-central1-a
gcloud dataproc clusters create ${MYCLUSTER} --worker-machine-type=n1-standard-2 --master-machine-type=n1-standard-2
```

**Check my progress**

* * *

_The following steps must be executed in the first SSH session_

## Create a GCS bucket and collect images

```bash
GCP_PROJECT=$(gcloud config get-value core/project)
MYBUCKET="${USER//google}-image-${RANDOM}"
echo MYBUCKET=${MYBUCKET}
gsutil mb gs://${MYBUCKET}

# Download some sample images into your bucket
curl https://www.publicdomainpictures.net/pictures/20000/velka/family-of-three-871290963799xUk.jpg | gsutil cp - gs://${MYBUCKET}/imgs/family-of-three.jpg
curl https://www.publicdomainpictures.net/pictures/10000/velka/african-woman-331287912508yqXc.jpg | gsutil cp - gs://${MYBUCKET}/imgs/african-woman.jpg
curl https://www.publicdomainpictures.net/pictures/10000/velka/296-1246658839vCW7.jpg | gsutil cp - gs://${MYBUCKET}/imgs/classroom.jpg
gsutil ls -R gs://${MYBUCKET}
```

**Check my progress**

## Submit your job to Cloud Dataproc

```bash
MYCLUSTER="${USER/_/-}-qwiklab"
curl https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_frontalface_default.xml | gsutil cp - gs://${MYBUCKET}/haarcascade_frontalface_default.xml

cd ~/cloud-dataproc/codelabs/opencv-haarcascade

gcloud dataproc jobs submit spark \
--cluster ${MYCLUSTER} \
--jar target/scala-2.10/feature_detector-assembly-1.0.jar -- \
gs://${MYBUCKET}/haarcascade_frontalface_default.xml \
gs://${MYBUCKET}/imgs/ \
gs://${MYBUCKET}/out/
```

**Check my progress**

Navigation menu > Storage

## Test your Understanding
1. False
2. Apache Spark
3. True