
# GSP647 Configuring IAM Permissions with gcloud

_last modified: 2020-08-10_

## Download and install the gcloud sdk

Nav to Compute Engine

Click SSH button next to `centos-clean`

In the SSH session, run:

```bash
curl https://sdk.cloud.google.com | bash

exec -l $SHELL

gcloud init
```

> **Check my progress**
> Download and install Google Cloud SDK

Do you want to continue (Y/n)?, press Enter.

open a Sign in with Google web page. 

> **Check my progress**
> Initialize Google Cloud SDK

### Manage Google Cloud SDK components

```bash
gcloud components list
gcloud components install beta
```

Press **Enter** when you see the prompt **Do you want to continue (Y/n)**?.

> What command will perform an update to the beta component?
> - **gcloud components update beta**

> **Check my progress**
> Install Google Cloud SDK beta component

### Configure the gcloud environment

```bash
gcloud compute instances create lab-1
gcloud config set compute/zone us-central1-f
cat ~/.config/gcloud/configurations/config_default
```

> **Check my progress**
> Create an instance with name as lab-1 in Project 1

> **Check my progress**
> Update the default zone

> What are two ways you can install the Google Cloud SDK?
> - **Use the system package manager to install.**
> - **Download and run the installer from the Google Cloud site.**

## Create and switch between multiple IAM configurations

### Create a new IAM configuration

```bash
gcloud init
```

- Select option 2, Create a new configuration.
- Type **user2**
- Select option 2, Log in with a new account
- Press Enter when you see the prompt Do you want to continue (Y/n)?
- Click on the link displayed.
- Click Use another account
- Pick cloud project to use

> **Check my progress**
> Check gcloud user2 configuration was created

## Test the new account

```bash
gcloud config configurations activate default
sudo yum -y install -y epel-release
sudo yum -y install -y jq
```

> When running a gcloud command, how do you override the configured zone for just that one time?
> - **Add the switch --zone DIFFERENT_ZONE to the command**

## Identify and assign correct IAM permissions

### Examine roles and permissions

```bash
echo "export USERID2=" >> ~/.bashrc
echo "export PROJECTID2=" >> ~/.bashrc
. ~/.bashrc
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=roles/viewer
gcloud iam roles create devops --project $PROJECTID2 --permissions "compute.instances.create,compute.instances.delete,compute.instances.start,compute.instances.stop,compute.instances.update,compute.disks.create,compute.subnetworks.use,compute.subnetworks.useExternalIp,compute.instances.setMetadata,compute.instances.setServiceAccount"
```

***Insert the second user ID and the Project2 ID***

> **Check my progress**
> Restricting Username 2 to roles/viewer in Project 2

## Test that user2 has access

### Create a new role with permissions

Press **Enter** when you see the message Are you sure you want to make this change? (Y/n)?.

> **Check my progress**
> Create a new role with permissions for the devops team

### Bind the role to the second account to both projects

```bash
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=projects/$PROJECTID2/roles/devops
gcloud config configurations activate user2
gcloud config set project $PROJECTID2
gcloud compute instances create lab-2
gcloud config configurations activate default
gcloud config set project $PROJECTID2
gcloud iam service-accounts create devops --display-name devops
```

> **Check my progress**
> Check user2 is bound to project2 and the role roles/iam.serviceAccountUser

> **Check my progress**
> Bound Username 2 to devops role

### Test the newly assigned permissions.

> **Check my progress**
> Create an instance with name as lab-2 in Project 

### Your environment

> What are two of the three items you need to provide when binding an IAM role to a project?
> - **account**
> - **project id**

## Using a service account

> **Check my progress**
> Check the created devops service account

```bash
SA=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=devops")
gcloud projects add-iam-policy-binding $PROJECTID2 --member serviceAccount:$SA --role=roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding $PROJECTID2 --member serviceAccount:$SA --role=roles/compute.instanceAdmin
gcloud compute instances create lab-3 --service-account $SA --scopes "https://www.googleapis.com/auth/compute"
```

> **Check my progress**
> Check devops service account is bound to project2 and the role roles/iam.serviceAccountUser

## Using the service account with a compute instance

> **Check my progress**
> Check devops service account is bound to project2 and the role roles/compute.instanceAdmin

> **Check my progress**
> Check lab-3 has the service account attached

## Test the service account

> What is NOT true about service accounts?
> - **Service accounts always provide full admin rights to the project.**