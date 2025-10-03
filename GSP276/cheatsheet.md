# GSP276 Using Agones to Easily Create Scalable Game Servers

_last updated on 2021-09-17_

## Creating the cluster

```bash
gcloud config set compute/zone us-central1-a

export CLUSTER_NAME=cluster-1
echo $cluster-1

gcloud container clusters create $CLUSTER_NAME \
  --no-enable-legacy-authorization \
  --tags=game-server \
  --scopes=gke-default \
  --num-nodes=3 \
  --machine-type=n1-standard-2 \
  --region=us-central1-a

```

> Create a Kubernetes cluster

## Creating the firewall...

```bash
gcloud config set container/cluster $CLUSTER_NAME
gcloud container clusters get-credentials --region=us-central1-a $CLUSTER_NAME

gcloud compute firewall-rules create game-server-firewall \
  --allow udp:7000-8000 \
  --target-tags game-server \
  --description "Firewall to allow game server udp traffic"

kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin --user `gcloud config get-value account`

kubectl create namespace agones-system
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/agones/release-1.6.0/install/yaml/install.yaml

kubectl describe --namespace agones-system pods

```

> Create a firewall rule to allow the UDP traffic

> Enable creation of RBAC resources

> Create agones-system namespace and install Agones with YAML

## Create a GameServer

```bash
kubectl create -f https://raw.githubusercontent.com/googleforgames/agones/release-1.6.0/examples/simple-udp/gameserver.yaml

kubectl get gameservers

kubectl get pods

watch kubectl describe gameserver

```

> Create a GameServer

```bash
kubectl get gs

```

## Connect to the GameServer

```bash
gcloud compute instances create agones-test-vm \
  --image-family=debian-10 \
  --image-project=debian-cloud

gcloud compute ssh agones-test-vm

```

> Create a new VM instance

```bash
sudo apt install netcat

nc -u [IP] [PORT]
Hello World !
```

```bash
EXIT

```

> Shut down the GameServer
