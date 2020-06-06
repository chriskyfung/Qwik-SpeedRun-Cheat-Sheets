# **GSP079** Getting Started with Cloud KMS

_Last update_: 2020-06-06

## Create a Cloud Storage bucket
## Check out the data

```bash
export PROJECT_ID=$(gcloud info --format='value(config.project)')
BUCKET_NAME=${PROJECT_ID}_enron_corpus

gsutil mb gs://${BUCKET_NAME}
gsutil cp gs://enron_emails/allen-p/inbox/1. .
tail 1.
```

> **Check my progress**
> Create a Cloud Storage bucket.

## Enable Cloud KMS

```bash
gcloud services enable cloudkms.googleapis.com
KEYRING_NAME=test CRYPTOKEY_NAME=qwiklab
gcloud kms keyrings create $KEYRING_NAME --location global

gcloud kms keys create $CRYPTOKEY_NAME --location global \
      --keyring $KEYRING_NAME \
      --purpose encryption
```

Go to the **Navigation menu** > **IAM & Admin** > **Cryptogrphic keys** > **Go to Key Management**

> **Check my progress**
> Create a Keyring and Crypto key.

## Encrypt Your Data

```bash
PLAINTEXT=$(cat 1. | base64 -w0)

curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:encrypt" \
  -d "{\"plaintext\":\"$PLAINTEXT\"}" \
  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"\
  -H "Content-Type: application/json"

curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:encrypt" \
  -d "{\"plaintext\":\"$PLAINTEXT\"}" \
  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"\
  -H "Content-Type:application/json" \
| jq .ciphertext -r > 1.encrypted

curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:decrypt" \
  -d "{\"ciphertext\":\"$(cat 1.encrypted)\"}" \
  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"\
  -H "Content-Type:application/json" \
| jq .plaintext -r | base64 -d

gsutil cp 1.encrypted gs://${BUCKET_NAME}
```

> **Check my progress**
> Encrypt Your Data with the Cloud KMS key and upload it on the storage bucket.

## Configure IAM Permissions

```bash
USER_EMAIL=$(gcloud auth list --limit=1 2>/dev/null | grep '@' | awk '{print $2}')

gcloud kms keyrings add-iam-policy-binding $KEYRING_NAME \
    --location global \
    --member user:$USER_EMAIL \
    --role roles/cloudkms.admin

gcloud kms keyrings add-iam-policy-binding $KEYRING_NAME \
    --location global \
    --member user:$USER_EMAIL \
    --role roles/cloudkms.

gsutil -m cp -r gs://enron_emails/allen-p .

MYDIR=allen-p
FILES=$(find $MYDIR -type f -not -name "*.encrypted")
for file in $FILES; do
  PLAINTEXT=$(cat $file | base64 -w0)
  curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:encrypt" \
    -d "{\"plaintext\":\"$PLAINTEXT\"}" \
    -H "Authorization:Bearer $(gcloud auth application-default print-access-token)" \
    -H "Content-Type:application/json" \
  | jq .ciphertext -r > $file.encrypted
done
gsutil -m cp allen-p/inbox/*.encrypted gs://${BUCKET_NAME}/allen-p/inbox
```

Open [Key Management](https://console.cloud.google.com/iam-admin/kms)

> **Check my progress**
> Encrypt multiple files using KMS API and upload to cloud storage.

Go to **Storage** > **Browser** > **YOUR_BUCKET** > **allen-p** > **inbox**

## View Cloud Audit Logs

## Test your knowledge

> Cloud KMS is integrated with Cloud IAM and Cloud Audit Logging so that you can manage permissions on individual keys and monitor how these are used.
> **True**