# Download Terraform
wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip

# Unzip Terraform
unzip terraform_0.11.11_linux_amd64.zip

# Set the PATH environmental variable to Terraform binaries:
export PATH="$PATH:$HOME/terraform"
cd /usr/bin
sudo ln -s $HOME/terraform
cd $HOME
source ~/.bashrc

# Confirm the Terraform installation
terraform --version

# Export the GCP project into an environment variable
export GOOGLE_PROJECT=$(gcloud config get-value project)

# Create a directory for your Terraform configuration
mkdir tfnet
cd tfnet

# New file provider.tf
cat > provider.tf <<EOF
provider "google" {}
EOF

# Initialize Terraform
terraform init

### The output should look like this
### 
### * provider.google: version = "~> 1.20"
### Terraform has been successfully initialized!
###

# -------------------

### Create securenetwork and its resources
### Create the custom-mode network securenetwork along with its firewall rule and VM instance (vm-securehost).

cat > provider.tf <<EOF
# Create the securenetwork network
resource "google_compute_network" "securenetwork" {
name = "securenetwork"
auto_create_subnetworks = "false"
}

# Add a subnet to securenetwork
# Add subnet to the VPC network.

# Create subnet subnetwork
resource "google_compute_subnetwork" "securenetwork" {
name          = "securenetwork"
region        = "us-central1"
network       = "${google_compute_network.securenetwork.self_link}"
ip_cidr_range = "10.130.0.0/20"
}

# Configure the firewall rule
# Define a firewall rule to allow HTTP, SSH, and RDP traffic on securenetwork.

resource "google_compute_firewall" "bastionbost-allow-rdp" {
name = "bastionbost-allow-rdp"
network = "${google_compute_network.securenetwork.self_link}"
target_tags = ["bastion"]
allow {
    protocol = "tcp"
    ports    = ["3389"] 
	}
}

resource "google_compute_firewall" "securenetwork-allow-rdp" {
name = "securenetwork-allow-rdp"
network = "${google_compute_network.securenetwork.self_link}"
source_ranges = "10.130.0.0/20"
allow {
    protocol = "tcp"
    ports    = ["3389"] 
	}
}

# Create the vm-securehost instance
module "vm-securehost" {
  source           = "./securehost"
  instance_name    = "vm-securehost"
  instance_zone    = "us-central1-a"
  instance_tags = "secure"
  instance_subnetwork = "${google_compute_subnetwork.securenetwork.self_link}"
}

# Create the vm-bastionhost instance
module "vm-bastionhost" {
  source           = "./bastionhost"
  instance_name    = "vm-bastionhost"
  instance_zone    = "us-central1-a"
  instance_tags = "bastion"
  instance_subnetwork = "${google_compute_subnetwork.securenetwork.self_link}"
}
EOF

# -------------------

### Configure the VM instance
mkdir securehost

cat > securehost/main.tf <<EOF
# Code inside securehost.tf
variable "instance_name" {
  }
variable "instance_zone" {
  default = "us-central1-a"
  }
variable "instance_type" {
  default = "n1-standard-1"
  }
variable "instance_subnetwork" {
}
variable "instance_tags" {
  }

resource "google_compute_instance" "vm_instance" {
  name         = "${var.instance_name}"
  zone         = "${var.instance_zone}"
  machine_type = "${var.instance_type}"
  tags = ["${var.instance_tags}"]
  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2016"
	  }
  }
  network_interface {
    subnetwork = "${var.instance_subnetwork}"
  }
  network_interface {
    subnetwork = "default"
  }
}
EOF

# -------------------

# Configure the VM instance

mkdir bastionhost

cat > bastionhost/main.tf <<EOF
# Code inside main.tf
variable "instance_name" {
  }
variable "instance_zone" {
  default = "us-central1-a"
  }
variable "instance_type" {
  default = "n1-standard-1"
  }
variable "instance_subnetwork" {
}
variable "instance_tags" {
  }

resource "google_compute_instance" "vm_instance" {
  name         = "${var.instance_name}"
  zone         = "${var.instance_zone}"
  machine_type = "${var.instance_type}"
  tags = ["${var.instance_tags}"]
  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2016"
	  }
  }
  network_interface {
    subnetwork = "${var.instance_subnetwork}"
    access_config {
      # Allocate a one-to-one NAT IP to the instance
    }
  }
  network_interface {
    subnetwork = "default"
  }
}
EOF

terraform fmt
terraform init
terraform plan

terraform apply
