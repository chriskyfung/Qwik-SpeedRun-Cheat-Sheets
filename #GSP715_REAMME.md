# GSP715 Palo Alto Networks: VM-Series Advanced Deployment

Latest update: 2021-05-14
Latest verified: 2021-05-14

1. Verify the creation of VMs and VPCs via Terraform.
1. Verify the http response of public external IP for load 1. balancer.
1. Check the logs in VM-Series01 to verify the traffic flow the `Spoke2-vm1` outbound.
1. Check the logs in VM-Series02 to verify the traffic flow  the `Spoke2-vm1` outbound.
1. Review the east/west traffic on vmseries01

## Clone the Repository

```bash
git clone https://github.com/PaloAltoNetworks/advanced_deployment && cd advanced_deployment

gcloud projects list --filter=qwiklabs-gcp
export PROJECT_ID=$(gcloud projects list --filter=qwiklabs-gcp --format=json | jq -r '.[].projectId')
echo $PROJECT_ID

sed -i 's/project_id      = ""/project_id      = '"$PROJECT_ID"'/g' terraform.tfvars
sed -n 1p terraform.tfvars

terraform version
```

# Deploy via Terraform

```
terraform init
terraform apply
```

Building the environment can **take ~10min**

## Review your environment

**Navigation menu** > **VPC Network** > **VPC Networks**.

> **Check my progress**
> Click Check my progress to verify the objective.

## VM-Series NGFW

> **Check my progress**
> Verify the http response of public external IP for load balancer.

Open the External Ips for MGMT-FW1 and MGMT-FW2 in new tabs, then click **Proceed to \<IP address\> (unsafe)**

Log in the Panorama management console

| Username | Password    |
|----------|-------------|
|`paloalto`|`Pal0Alt0@123`|

## Review Inbound Flow

Copy the **EXT-LB** IP address from the Terraform output and paste into a new web browser

Find your IP address using https://whatismyipaddress.com/

Add your IP address to the search field `(addr.src in <your-IP-address>)`

## Review outbound flow

```bash
gcloud compute ssh --zone us-east4-a spoke2-vm1
```

Type Y and Enter to continue.

```bash
sudo apt-get update
curl http://10.1.0.100/?[1-1000]
```

In the Monitor tab, filter `(addr.src in 10.2.0.2)`

> **Check my progress**
> Check the logs in VM-Series01 to verify the traffic flow from the `Spoke2-vm1` outbound.

> **Check my progress**
> Check the logs in `VM-Series02` to verify the traffic flow from the Spoke2-vm1 outbound.

## Review East/West Flow

> **Check my progress**
> Review the east/west traffic on vmseries01

