# **GSP698** Securing Google Cloud with CFT Scorecard

_Last update_: 2020-06-06

### Tasks

1. Create the cai bucket
2. Create the two cai files

## Setup environment

```bash
export GOOGLE_PROJECT=$(gcloud config get-value project)
export CAI_BUCKET_NAME=cai-$GOOGLE_PROJECT

gcloud services enable cloudasset.googleapis.com \
    --project $GOOGLE_PROJECT
    
git clone https://github.com/forseti-security/policy-library.git

cp policy-library/samples/storage_blacklist_public.yaml policy-library/policies/constraints/

gsutil mb -l us-central1 -p $GOOGLE_PROJECT gs://$CAI_BUCKET_NAME

# Export resource data
gcloud asset export \
    --output-path=gs://$CAI_BUCKET_NAME/resource_inventory.json \
    --content-type=resource \
    --project=$GOOGLE_PROJECT

# Export IAM data
gcloud asset export \
    --output-path=gs://$CAI_BUCKET_NAME/iam_inventory.json \
    --content-type=iam-policy \
    --project=$GOOGLE_PROJECT
```

> **Check my progress**
> Create the CAI bucket

## Collect the data using Cloud Asset Inventory (CAI)

> **Check my progress**
> Create the CAI files have been created

* * *

## Analyze the CAI data with CFT Scorecard
## Adding more constraints to CFT Scorecard

```bash
curl -o cft https://storage.googleapis.com/cft-cli/latest/cft-linux-amd64
# make executable
chmod +x cft

./cft scorecard --policy-path=policy-library/ --bucket=$CAI_BUCKET_NAME

# Add a new policy to blacklist the IAM Owner Role
cat > policy-library/policies/constraints/iam_whitelist_owner.yaml << EOF
apiVersion: constraints.gatekeeper.sh/v1alpha1
kind: GCPIAMAllowedBindingsConstraintV1
metadata:
  name: whitelist_owner
  annotations:
    description: List any users granted Owner
spec:
  severity: high
  match:
    target: ["organization/*"]
    exclude: []
  parameters:
    mode: whitelist
    assetType: cloudresourcemanager.googleapis.com/Project
    role: roles/owner
    members:
    - "serviceAccount:admiral@qwiklabs-services-prod.iam.gserviceaccount.com"
EOF

./cft scorecard --policy-path=policy-library/ --bucket=$CAI_BUCKET_NAME

export USER_ACCOUNT="$(gcloud config get-value core/account)"
export PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_PROJECT --format="get(projectNumber)")

# Add a new policy to whitelist the IAM Editor Role
cat > policy-library/policies/constraints/iam_identify_outside_editors.yaml << EOF
apiVersion: constraints.gatekeeper.sh/v1alpha1
kind: GCPIAMAllowedBindingsConstraintV1
metadata:
  name: identify_outside_editors
  annotations:
    description: list any users outside the organization granted Editor
spec:
  severity: high
  match:
    target: ["organization/*"]
    exclude: []
  parameters:
    mode: whitelist
    assetType: cloudresourcemanager.googleapis.com/Project
    role: roles/editor
    members:
    - "user:$USER_ACCOUNT"
    - "serviceAccount:*$PROJECT_NUMBER*gserviceaccount.com"
    - "serviceAccount:$GOOGLE_PROJECT*gserviceaccount.com"
EOF

./cft scorecard --policy-path=policy-library/ --bucket=$CAI_BUCKET_NAME
```