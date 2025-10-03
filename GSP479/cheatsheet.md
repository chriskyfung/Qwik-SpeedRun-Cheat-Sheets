# GSP479 Google Kubernetes Engine Security: Binary Authorization

_last modified: 2020-08-10_

## Clone Demo

In the Cloud Shell, run:

```bash
git clone https://github.com/GoogleCloudPlatform/gke-binary-auth-demo.git

cd gke-binary-auth-demo

gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a

./create.sh -c my-cluster-1
./validate.sh -c my-cluster-1
```

## Deployment Steps

## Validation

> **Check my progress**
> Create a Kubernetes Cluster with Binary Authorization

### Using Binary Authorization

navigate to the **Security** > **Binary Authorization**.
Click **Configure Policy**.

+ Disallow all images
+ click **Add Rule**.

`us-central1-a.my-cluster-1`

Select the default rule of `Allow all images` for your cluster.
Click **Add**.

Click **Save Policy**.

> **Check my progress**
> Update Binary Authorization Policy to add Disallow all images rule at project level and allow at cluster level

## Creating a Private GCR Image

```bash
docker pull gcr.io/google-containers/nginx:latest
gcloud auth configure-docker
PROJECT_ID="$(gcloud config get-value project)"
docker tag gcr.io/google-containers/nginx "gcr.io/${PROJECT_ID}/nginx:latest"
docker push "gcr.io/${PROJECT_ID}/nginx:latest"
gcloud container images list-tags "gcr.io/${PROJECT_ID}/nginx"
```

Run after Cluster Ready:

```
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: "gcr.io/${PROJECT_ID}/nginx:latest"
    ports:
    - containerPort: 80
EOF

kubectl get pods
kubectl delete pod nginx
```

On the Binary Authorization page, click **Edit Policy**,

1. Expand the Rules dropdown
2. click on the three vertical dots
3. click **edit**
4. Select `Disallow all images`, click Submit.
5. Finally, click **Save Policy** 

> **Check my progress**
> Update cluster specific policy to Disallow all images

```bash
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: "gcr.io/${PROJECT_ID}/nginx:latest"
    ports:
    - containerPort: 80
EOF
```

In the GCP console navigate to the Navigation menu > Logging.

`resource.type="k8s_cluster" protoPayload.response.reason="Forbidden"`

> **Check my progress**
> Create a Nginx pod to verify cluster admission rule is applied for disallow all images (denies to create)

#### Denying Images Except From Whitelisted Container Registries

Edit the Binary Authorization Policy, display the image paths, then click **Add Image Path**.

Click **Save Policy**

run:

```bash
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: "gcr.io/${PROJECT_ID}/nginx:latest"
    ports:
    - containerPort: 80
EOF

kubectl delete pod nginx

ATTESTOR="manually-verified" # No spaces allowed
ATTESTOR_NAME="Manual Attestor"
ATTESTOR_EMAIL="$(gcloud config get-value core/account)" # This uses your current user/email

NOTE_ID="Human-Attestor-Note" # No spaces
NOTE_DESC="Human Attestation Note Demo"

NOTE_PAYLOAD_PATH="note_payload.json"
IAM_REQUEST_JSON="iam_request.json"

cat > ${NOTE_PAYLOAD_PATH} << EOF
{
  "name": "projects/${PROJECT_ID}/notes/${NOTE_ID}",
  "attestation_authority": {
    "hint": {
      "human_readable_name": "${NOTE_DESC}"
    }
  }
}
EOF

curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $(gcloud auth print-access-token)"  \
    --data-binary @${NOTE_PAYLOAD_PATH}  \
    "https://containeranalysis.googleapis.com/v1beta1/projects/${PROJECT_ID}/notes/?noteId=${NOTE_ID}"

curl -H "Authorization: Bearer $(gcloud auth print-access-token)"  \
    "https://containeranalysis.googleapis.com/v1beta1/projects/${PROJECT_ID}/notes/${NOTE_ID}"

PGP_PUB_KEY="generated-key.pgp"

sudo apt-get install -y rng-tools
sudo rngd -r /dev/urandom
gpg --quick-generate-key --yes ${ATTESTOR_EMAIL}
```

> **Check my progress**
> Update BA policy to denying images except from whitelisted container registries (your project container registry)

#### Enforcing Attestations

```bash
gpg --armor --export "${ATTESTOR_EMAIL}" > ${PGP_PUB_KEY}
gcloud --project="${PROJECT_ID}" \
    beta container binauthz attestors create "${ATTESTOR}" \
    --attestation-authority-note="${NOTE_ID}" \
    --attestation-authority-note-project="${PROJECT_ID}"
gcloud --project="${PROJECT_ID}" \
    beta container binauthz attestors public-keys add \
    --attestor="${ATTESTOR}" \
    --pgp-public-key-file="${PGP_PUB_KEY}"
gcloud --project="${PROJECT_ID}" \
    beta container binauthz attestors list
GENERATED_PAYLOAD="generated_payload.json"
GENERATED_SIGNATURE="generated_signature.pgp"
PGP_FINGERPRINT="$(gpg --list-keys ${ATTESTOR_EMAIL} | head -2 | tail -1 | awk '{print $1}')"
IMAGE_PATH="gcr.io/${PROJECT_ID}/nginx"
IMAGE_DIGEST="$(gcloud container images list-tags --format='get(digest)' $IMAGE_PATH | head -1)"
gcloud beta container binauthz create-signature-payload \
    --artifact-url="${IMAGE_PATH}@${IMAGE_DIGEST}" > ${GENERATED_PAYLOAD}
cat "${GENERATED_PAYLOAD}"
gpg --local-user "${ATTESTOR_EMAIL}" \
    --armor \
    --output ${GENERATED_SIGNATURE} \
    --sign ${GENERATED_PAYLOAD}
cat "${GENERATED_SIGNATURE}"
gcloud beta container binauthz attestations create \
    --artifact-url="${IMAGE_PATH}@${IMAGE_DIGEST}" \
    --attestor="projects/${PROJECT_ID}/attestors/${ATTESTOR}" \
    --signature-file=${GENERATED_SIGNATURE} \
    --public-key-id="${PGP_FINGERPRINT}"
gcloud beta container binauthz attestations list \
    --attestor="projects/${PROJECT_ID}/attestors/${ATTESTOR}"
echo "projects/${PROJECT_ID}/attestors/${ATTESTOR}" # Copy this output to your copy/paste buffer
```

Edit the Binary Authorization policy to **edit** the cluster-specific rule.

Select `Allow only images that have been approved by all of the following attestors` instead of ~~`Disallow all images`~~

**Add Attestors** followed by `Add attestor by resource ID`

then click **Add 1 Attestor**, Submit, and finally **Save Policy**

```bash
IMAGE_PATH="gcr.io/${PROJECT_ID}/nginx"
IMAGE_DIGEST="$(gcloud container images list-tags --format='get(digest)' $IMAGE_PATH | head -1)"
```

After waiting at least 30 seconds 

```
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: "${IMAGE_PATH}@${IMAGE_DIGEST}"
    ports:
    - containerPort: 80
EOF
```

> **Check my progress**
> Update BA policy to modify cluster specific rule to allow only images that have been approved by attestors

## Tear Down

```bash
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
./delete.sh -c my-cluster-1
```

> **Check my progress**
> Tear Down (delete cluster)

