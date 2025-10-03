# GSP094 Google Cloud Pub/Sub: Qwik Start - Python

__last update: 2020-08-05__

## Create a virtual environment

(Unnecessary)

In the Cloud Shell, run:

```bash
sudo apt-get update
sudo apt-get install -y virtualenv
virtualenv -p python3 venv
source venv/bin/activate
```

## Install the client library

```bash
git clone https://github.com/googleapis/python-pubsub.git
cd python-pubsub/samples/snippets
pip install --upgrade google-cloud-pubsub
```

## Pub/Sub - the Basics

### Create a topic

```bash
export GLOBAL_CLOUD_PROJECT=$(gcloud config get-value project)

cat publisher.py

python publisher.py -h

python publisher.py $GLOBAL_CLOUD_PROJECT create MyTopic

python publisher.py $GLOBAL_CLOUD_PROJECT list

python subscriber.py $GLOBAL_CLOUD_PROJECT create MyTopic MySub

python subscriber.py $GLOBAL_CLOUD_PROJECT list-in-project

python subscriber.py -h
```

> **Check my progress**
> Create a topic.

### Create a subscription

> **Check my progress**
> Create a subscription.

## Publish messages

```bash
gcloud pubsub topics publish MyTopic --message "Hello"
gcloud pubsub topics publish MyTopic --message "Publisher's name is Google"
gcloud pubsub topics publish MyTopic --message "Publisher likes to eat Apple"
gcloud pubsub topics publish MyTopic --message "Publisher thinks Pub/Sub is awesome"

python subscriber.py $GLOBAL_CLOUD_PROJECT receive MySub
```

## View messages

## Test your Understanding

> Google Cloud Pub/Sub service allows applications to exchange messages reliably, quickly, and asynchronously.
> **True**

> A _____ is a shared string that allows applications to connect with one another.
> **topic*
