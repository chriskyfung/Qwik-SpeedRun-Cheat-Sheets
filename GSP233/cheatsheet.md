# GSP233 Deploy Kubernetes Load Balancer Service with Terraform

_last updated on 2021-08-25_


## Update Terraform

```bash
wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip

unzip terraform_0.13.0_linux_amd64.zip 

sudo mv terraform /usr/local/bin/

terraform -v

gsutil -m cp -r gs://spls/gsp233/* .

cd tf-gke-k8s-service-lb

terraform init
terraform apply
```

Type `yes`

### Verify resources created by Terraform

1. In the console, navigate to **Navigation menu** > **Kubernetes Engine**.
2. Click on `tf-gke-k8s` cluster and check its configuration.
3. In the left panel, click **Services & Ingress** and check the `nginx` service status.
4. Click the **Endpoints** IP address to open the `Welcome to nginx!` page in a new browser tab.

> Deploy infrastructure with Terraform

## Congratulations!
