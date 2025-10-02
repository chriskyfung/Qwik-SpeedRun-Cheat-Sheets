variable "project_id" {
  description = "The ID of the project"
  type        = string
  default     = "qwiklabs-gcp-04-b18dcc097f14"
}

variable "region" {
  description = "The region where infrastructure will be created"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone where infrastructure will be created"
  type        = string
  default     = "us-central1-a"
}