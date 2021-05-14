# GSP489 Palo Alto Networks VM-Series Firewall: Automating Deployment with Terraform

_require update_

## Configuration

### Install dependencies

Start a Cloud Shell,

```bash
gsutil cp -r gs://spls/gsp489 .
cd gsp489
unzip terraform-ansible-intro.zip

cd terraform-ansible-intro-master
./setup
```

## Enable the Compute Engine API

```bash
terraform --version

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud config set project $PROJECT_ID

gcloud services enable compute.googleapis.com

gcloud iam service-accounts list

export SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --format=json | jq -r '.[].email')

echo $SERVICE_ACCOUNT_EMAIL
```

```bash
gcloud iam service-accounts keys create gcp_compute_key.json --iam-account $SERVICE_ACCOUNT_EMAIL

cat gcp_compute_key.json

ssh-keygen -t rsa -b 1024 -N '' -f ~/.ssh/lab_ssh_key
```

## Deployment

```bash
cd deployment

sed -i 's/GCP Project ID/'"$PROJECT_ID"'/g' gcp_variables.tf
sed -i 's/PUT_gcp_region_HERE/us-central1/g' gcp_variables.tf

cat gcp_variables.tf
```

### Initialize the Terraform providers

```bash
terraform init
terraform plan
terraform apply
```

Copy the green output texts into a note.

> **Check my progress**
> Deploy the VM-Series firewall

### Update the SSH config

```bash
gcloud compute config-ssh --ssh-key-file=~/.ssh/lab_ssh_key

export VMINSTANCE=$(gcloud compute instances list --format=json | jq -r '.[].name')
echo $VMINSTANCE

export ZONE=us-central1-a
export $ZONE

ssh admin@$VMINSTANCE.$ZONE.$PROJECT_ID
```

In the SSH session,

```bash
configure
set mgt-config users admin password
```

Use this as your Password. *The password will not show, so please paste the value and click enter.

`Pal0Alt0@123`

```bash
commit
exit
exit
```

## Terraform Lab Activities

```bash
cd ../terraform

edit panos_variables.tf
```

.
.
.
.

Follow the rest procedure in the lab page