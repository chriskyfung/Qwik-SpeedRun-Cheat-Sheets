export PROJECT_ID=$(gcloud info --format='value(config.project)')
export SERVICE_ACCOUNT=$(gcloud --project=$PROJECT_ID iam service-accounts list --format=json |
 jq -r '.[] | select(.displayName=="Compute Engine default service account").email')

gcloud beta compute --project=${PROJECT_ID} instances create dev-instance --zone=us-central1-a --machine-type=n1-standard-1 --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=${SERVICE_ACCOUNT} --scopes=https://www.googleapis.com/auth/cloud-platform --tags=http-server --image=debian-9-stretch-v20191014 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=dev-instance --reservation-affinity=any