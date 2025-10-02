# ARC120 The Basics of Google Cloud Compute: Challenge Lab

This cheat sheet provides the commands needed to complete the "ARC120 The Basics of Google Cloud Compute: Challenge Lab".

*Created on 2025-10-02*

## 1. Initial Setup in Cloud Shell

First, set up your environment variables and gcloud configuration.

```bash
# Note: A region is a collection of zones. 'us-central1-f' is a zone.
# The region should be 'us-central1'.
export REGION=us-central1
export ZONE=us-central1-f

# Set the default compute zone and region for gcloud commands
gcloud config set compute/zone $ZONE
gcloud config set compute/region $REGION
```

## 2. Create Resources

Execute the following commands to create the necessary Google Cloud resources.

```bash
# Get your Project ID and store it in a variable
export PROJECT_ID=$(gcloud info --format='value(config.project)')

# Create a globally unique Cloud Storage bucket
gsutil mb gs://${PROJECT_ID}-bucket

# Create a new e2-medium VM instance with an HTTP tag
gcloud compute instances create my-instance --zone $ZONE --machine-type e2-medium --tags=http-server

# Create a 200GB persistent disk
gcloud compute disks create mydisk --size=200GB --zone $ZONE
# Attach the newly created disk to your VM instance
gcloud compute instances attach-disk my-instance --disk mydisk --zone $ZONE

# SSH into the 'my-instance' VM
gcloud compute ssh my-instance --zone $ZONE
```

## 3. Configure the VM via SSH

Connect to your instance and install NGINX.

```sh
# The following commands should be run inside this SSH session
# Inside the SSH session: Update package lists and install the NGINX web server
sudo apt-get update && sudo apt-get install -y nginx

# Verify that the NGINX service is running
ps auwx | grep nginx
```
