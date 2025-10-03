# GSP750 Infrastructure as Code with Terraform

_last updated on 2021-09-16_

## Build Infrastructure

```bash
cat > main.tf <<EOF
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}
provider "google" {
  version = "3.5.0"
  project = "<PROJECT_ID>"
  region  = "us-central1"
  zone    = "us-central1-c"
}
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
EOF

sed -i 's/<PROJECT_ID>/'$GOOGLE_CLOUD_PROJECT'/g' main.tf

grep -i 'project' main.tf

terraform init
terraform apply

```

Type **Yes**

> Creating Resources in terraform

## Change Infrastructure

```bash
cp main.tf main.tf.bak1

cat >> main.tf <<EOF
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}
EOF

cat main.tf

terraform apply

```

Type **Yes**

```bash
cp main.tf main.tf.bak2a

sed -i 's/"f1-micro"/"f1-micro"\n  tags         = ["web", "dev"]/g' main.tf

grep -i1A "f1-micro" main.tf

terraform apply
```

> Change Infrastructure

## Destructive Changes

```bash
cp main.tf main.tf.bak2b

sed -i 's/debian-cloud\/debian-9/cos-cloud\/cos-stable/g' main.tf

grep -i 'image' main.tf

terraform apply

```

Type **Yes**

```bash
terraform destroy

```

Type **Yes**

> Destructive Changes

## Create Resource Dependencies

```bash
terraform apply

```

Type **Yes**

```bash
cp main.tf main.tf.bak3

cat >> main.tf <<EOF
resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}
EOF

cat main.tf

terraform plan

sed -i 's/google_compute_network.vpc_network.name/google_compute_network.vpc_network.self_link/g' main.tf
sed -i 's/access_config {/access_config {\n         nat_ip = google_compute_address.vm_static_ip.address/g' main.tf

grep -iA3 'network' main.tf

terraform plan -out static_ip

terraform apply "static_ip"

```

Type **Yes**

## Implicit and Explicit Dependencies

```bash
cp main.tf main.tf.bak4

cat >> main.tf <<EOF
resource "google_storage_bucket" "example_bucket" {
  name     = "<UNIQUE-BUCKET-NAME>"
  location = "US"
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}
# Create a new instance that uses the bucket
resource "google_compute_instance" "another_instance" {
  # Tells Terraform that this VM instance must be created only after the
  # storage bucket has been created.
  depends_on = [google_storage_bucket.example_bucket]
  name         = "terraform-instance-2"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}
EOF

sed -i 's/<UNIQUE-BUCKET-NAME>/'$GOOGLE_CLOUD_PROJECT'/g' main.tf

cat main.tf

grep -iA3 'google_storage_bucket' main.tf

terraform plan
terraform apply

```

Type **Yes**

## Provision Infrastructure

```bash
cp main.tf main.tf.bak5

sed -i 's/\["web", "dev"\]/\["web", "dev"\]\n  provisioner "local-exec" {\n     command = "echo ${    command = "echo ${google_compute_instance.vm_instance.name}:  ${google_compute_instance.vm_instance.network_interface\[0\].access_config\[0\].nat_ip} >> ip_address.txt"\n  }/g' main.tf

grep -iA4 '\["web", "dev"\]' main.tf

terraform apply

```

Type **Yes**

```bash
terraform taint google_compute_instance.vm_instance

terraform apply

```

Type **Yes**