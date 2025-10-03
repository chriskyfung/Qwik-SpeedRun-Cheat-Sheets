# GSP156 Terraform Fundamentals

_last updated on 2021-09-16_
_last verified on 2021-09-16_

## Verifying Terraform installation

```bash
terraform

wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip
unzip terraform_0.13.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

terraform -v

cat > instance.tf <<EOF
resource "google_compute_instance" "terraform" {
  project      = "<PROJECT_ID>"
  name         = "terraform"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}
EOF

sed -i 's/<PROJECT_ID>/'$GOOGLE_CLOUD_PROJECT'/g' instance.tf

cat instance.tf | grep -i 'project'

terraform init
terraform plan
terraform apply

```

Type **Yes**

> Create a VM instance in us-central1-a zone with Terraform.

## Test your understanding

> Terraform enables you to safely and predictably create, change, and improve infrastructure.
>
> **True**

> With Terraform, you can create your own custom provider plugins.
>
> **True**
