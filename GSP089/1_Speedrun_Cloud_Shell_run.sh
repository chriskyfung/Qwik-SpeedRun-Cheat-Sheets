export PROJECT_ID=$(gcloud info --format='value(config.project)')

export SERVICE_ACCOUNT=$(gcloud --project=$PROJECT_ID iam service-accounts list --format=json |
 jq -r '.[] | select(.displayName=="Compute Engine default service account").email')

gcloud beta compute --project=${PROJECT_ID} instances create lamp-1-vm --zone=us-central1-a --machine-type=n1-standard-2 --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=${SERVICE_ACCOUNT} --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server --image=debian-9-stretch-v20191014 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=lamp-1-vm --reservation-affinity=any

gcloud compute --project=${PROJECT_ID} firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server