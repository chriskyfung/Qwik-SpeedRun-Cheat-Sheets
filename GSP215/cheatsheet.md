# GSP215 HTTP Load Balancer with Cloud Armor

## Configure HTTP and health check firewall rules

```bash
# Create the HTTP firewall rule
gcloud compute firewall-rules create default-allow-http --network=default --target-tags=http-server --source-ranges=0.0.0.0/0 --allow tcp:80
# Create the health check firewall rules
gcloud compute firewall-rules create default-allow-health-check --network=default --target-tags=http-server --source-ranges=130.211.0.0/22,35.191.0.0/16 --allow tcp
# Configure the instance templates
gcloud compute instance-templates create us-east1-template --subnet=projects/$DEVSHELL_PROJECT_ID/regions/us-east1/subnetworks/default --metadata=startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh --region=us-east1 --tags=http-server
gcloud compute instance-templates create europe-west1-template --subnet=projects/$DEVSHELL_PROJECT_ID/regions/europe-west1/subnetworks/default --metadata=startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh --region=europe-west1 --tags=http-server


# Create the managed instance groups
gcloud compute instance-groups managed create us-east1-mig --base-instance-name=us-east1-mig --template=us-east1-template --size=1 --zones=us-east1-b,us-east1-c,us-east1-d --instance-redistribution-type=PROACTIVE

gcloud compute instance-groups managed set-autoscaling "us-east1-mig" --region "us-east1" --cool-down-period "45" --max-num-replicas "5" --min-num-replicas "1" --target-cpu-utilization "0.8" --mode "on"

gcloud beta compute instance-groups managed create NAME --base-instance-name=NAME --template=europe-west1-template --size=1 --zones=europe-west1-b,europe-west1-c,europe-west1-d --instance-redistribution-type=PROACTIVE

gcloud beta compute instance-groups managed set-autoscaling --region "europe-west1" --cool-down-period "45" --max-num-replicas "5" --min-num-replicas "1" --target-cpu-utilization "0.8" --mode "on"

```

> Which of these fields identify the region of the backend?
>
> - Server Location
> - Hostname

## Configure the HTTP Load Balancer



