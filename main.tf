terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }

  backend "gcs" {
    bucket  = "qwiklabs-gcp-04-b18dcc097f14"
    prefix  = "terraform/state"
  }
}

provider "google" {
  version = "3.5.0"

  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-a"
}

module "instances" {
  source = "./modules/instances"
}

module "storage" {
  source = "./modules/storage"
}

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "2.5.0"

    project_id   = "qwiklabs-gcp-04-b18dcc097f14"
    network_name = "terraform-vpc"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-central1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-central1"
        }
    ]
}

resource "google_compute_firewall" "tf-firewall" {
  name    = "tf-firewall"
  network = "terraform-vpc"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}