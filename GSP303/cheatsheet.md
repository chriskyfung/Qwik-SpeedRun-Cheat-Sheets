Shell Scripts for Qwiklabs GSP303 - Configure Secure RDP using a Windows Bastion Host
=====================================================================================

This gist contains a shell script to deploy a Windows Bastion Host wtih Terraform via a Cloud Sheel in GCP. The application scenario can refer to the Lab GSP3030 entitled "Configure Secure RDP using a Windows Bastion Host" in Qwiklabs.

The script will do the following:

This gist contains a shell script to deploy a Windows Bastion Host wtih Terraform via a Cloud Sheel in GCP. The application scenario can refer to the Lab GSP3030 entitled "Configure Secure RDP using a Windows Bastion Host" in Qwiklabs.

The script will do the following:
1. Download and setup Terraform (v0.11.11)
2. Create files `provider.tf`, `securenetwork.tf`, `securehost/main.tf`, `bastionhost/main.tf`
3. Deploy the resources with Terraform,
    - Create a new VPC to host secure production Windows services.
    - Create a Windows host connected to a subnet in the new VPC with an internal only network interface.
    - Create a Windows bastion host (jump box) in with an externally accessible network interface.
    - Create a Windows bastion host (jump box) in with an externally accessible network interface.
    
For more detail, please read [this post on my GitHub Page](https://chriskyfung.github.io/blog/qwiklabs/Configure-Windows-Bastion-Host-with-Terraform-on-GCP).