# **GSP074** Cloud Storage: Qwik Start - CLI/SDK

## Create a bucket

```bash
export PROJECT_ID=$(gcloud info --format='value(config.project)')

export BUCKET=${PROJECT_ID}
gsutil mb gs://${BUCKET}

wget --output-document ada.jpg https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg

gsutil cp ada.jpg gs://${BUCKET}

rm ada.jpg

gsutil cp -r gs://${BUCKET}/ada.jpg .

gsutil cp gs://${BUCKET}/ada.jpg gs://${BUCKET}/image-folder/

gsutil ls gs://${BUCKET}

gsutil ls -l gs://${BUCKET}/ada.jpg

gsutil acl ch -u AllUsers:R gs://${BUCKET}/ada.jpg


```

**Check Progress** _Create a cloud storage bucket._

## Test your Understanding

> Each bucket has a default storage class, which you can specify when you create your bucket.

**True**

## Upload an object into your bucket

**Check Progress** _Copy an object to a folder in the bucket (ada.jpg)._

## List contents of a bucket or folder

## List details for an object

## Make your object publicly accessible

**Check Progress** _Make your object publicly accessible_

## Test your Understanding

> An access control list (ACL) is a mechanism you can use to define who has access to your buckets and objects.

**True**

## Remove public access

```bash
gsutil acl ch -d AllUsers gs://${BUCKET}/ada.jpg

gsutil rm gs://${BUCKET}/ada.jpg
```

## Test your Understanding

> You can stop publicly sharing an object by removing permission entry that have:

**allUsers**