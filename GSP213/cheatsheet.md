# GSP213 VPC Networks - Controlling Access

_last verified:_ 2020-09-05

## Create the web servers

```bash
# Create the blue server
gcloud compute instances create blue --zone=us-central1-a --tags=web-server --metadata startup-script='#! /bin/bash
sudo apt-get install nginx-light -y
sudo sed -i "/<h1>Welcome to nginx!/<h1>Welcome to the blue server!/" /var/www/html/index.nginx-debian.html'
# Create the green server
gcloud compute instances create green --zone=us-central1-a --metadata startup-script='#! /bin/bash
sudo apt-get install nginx-light -y
sudo sed -i "/<h1>Welcome to nginx!/<h1>Welcome to the green server!/" /var/www/html/index.nginx-debian.html'
#Create the tagged firewall rule
gcloud compute firewall-rules create allow-http-web-server --action=ALLOW --target-tags=web-server --source-ranges=0.0.0.0/0 --allow tcp:80,icmp
#Create a test-vm
gcloud compute instances create test-vm --machine-type=f1-micro --subnet=default --zone=us-central1-a
```

### Create a service account

1. In the Console, navigate to **Navigation menu** > **IAM & admin** > **Service accounts**.
2. Click **Create service account**.
3. Name: `Network-admin`
4. Select a role: **Compute Engine** > **Compute Network Admin**
5. Click **CREATE KEY** > **JSON**.

### Authorize test-vm and verify permissions

> The Network Admin role provides permissions to:
> - List the available firewall rules



### Update service account and verify permissions

> The Security Admin role, provides permissions to:
> - Modify the available firewall rules
> - Delete the available firewall rules
> - Create a firewall rules
> - List the available firewall rules

