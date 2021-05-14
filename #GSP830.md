# GSP830 Prisma Cloud Scan CI/CD Pipeline Jenkins and Code Repo Github

```bash
wget https://cdn.twistlock.com/releases/f7371a8b/prisma_cloud_compute_edition_20_09_345.tar.gz
mkdir prisma_cloud_compute_edition
tar xvzf prisma_cloud_compute_edition_20_09_345.tar.gz -C prisma_cloud_compute_edition/
cd prisma_cloud_compute_edition

gcloud container clusters get-credentials k8-cluster --region us-central1-a

```

```bash
./linux/twistcli console export kubernetes --service-type LoadBalancer

```

Copy the token from the downloaded file and paste it to the Cloud Shell

```bash
kubectl create -f twistlock_console.yaml

export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
echo $GOOGLE_CLOUD_PROJECT
git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git

kubectl get service -w -n twistlock

```

> **Check my progress**
>
> Create console using twistlock_console.yaml

Once you see the EXTERNAL-IP use **Ctrl-C** to stop the wait flag and return to the command line.

Copy the External IP address for the `twistlock-console`.

Browse `https://[EXTERNAL-IP]:8083`

User: `admin`
Password: `Pal0Alt0@123`

Paste the license key in the Update your Twistlock license field, then click Register:

* * *

From the Prisma Cloud Compute Console go to **Manage** > **Defenders** then click the **Names** tab.

Press **Click to Add**

## Prisma Cloud Compute Jenkins plugin

Go to **Manage** > **System** then click on the **Downloads** tab. 

Click the download link next to **Jenkins plugin**.

```bash
cd continuous-deployment-on-kubernetes

kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin \
        --user=$(gcloud config get-value account)

helm repo add stable https://charts.helm.sh/stable

helm version

helm install cd-jenkins -f jenkins/values.yaml stable/jenkins --version 1.7.3 --set master.serviceType=LoadBalancer --wait

kubectl create clusterrolebinding jenkins-deploy --clusterrole=cluster-admin --serviceaccount=default:cd-

kubectl get pod -n default

kubectl get svc

```

> **Check my progress**
>
> Build a Continuous Deployment Pipeline with Jenkins and Kubernetes

Wait for **External-IP** populated, you will use the **External-IP** to access Jenkins.

```bash
printf $(kubectl get secret --namespace default cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

```

http://[External-IP]:8080/login

Log into Jenkins with the following:

Username: `admin`

Password: *the Jenkins admin password you saved earlier*.

* * *

Navigate to **Manage Jenkins** > **Manage Plugins** and select the **Available** tab.

Use the **Search** field at the top of the page to filter for **Dashboard View** and select it :

Use the search again to search for **Analysis Model API** and select it :

Once both are checked, click **Install without restart** at the bottom.

**Manage Plugins** on the left side then select the **Advanced tab**.

Scroll down to the Upload Plugin section, then click Choose file and browse for the file you downloaded in the first step. Press Upload.

Check the **Restart Jenkins** box.


### Install the Prisma Cloud Compute Jenkins plugin

Navigate to **Manage Jenkins** > **Configure System**

Scroll down to the Prisma Cloud section and input:

- Address: *your Prisma Cloud URL*
- User: `admin`
- Password: `Pal0Alt0@123`

Click **Test Connection** after to validate it comes back as ‘OK'.

Click the **Save** button 

Navigate to **Manage Jenkins** > **Configure System**

Scroll down to the **Cloud** section and click on the link: **a separate configuration page**.

Click to expand out **Pod Templates...** and **Pod Template Details...**

select **Add Container>Container Template**

modify Working directory path - remove "/agent" from the default:

|                                  |               |
| -------------------------------- | ------------- |
| Name                             | build         |
| Docker image                     | docker        |
| Working directory                | /home/jenkins |
| Command to run                   | /bin/sh -c    |
| Arguments to pass to the command | cat           |
| Allocate pseudo-TTY              | checked       |

select **Add Volume** > **Host Path Volume**.

- Host path: `/var/run/docker.sock`
- Mount path: `/var/run/docker.sock`

Scroll down to **Raw Yaml for the Pod**

add the following content to the field :

```yaml
spec:
  securityContext:
    fsGroup: 412

```

Click **Save**.

### Build and Scan an image in the pipeline

Click **New Item** at the top of the left panel.

- job name: **PrismaCloud Demo**
- job type: **Pipeline**

Click **OK**

scroll down to the **Pipeline** section and change the Definition type to **Pipeline Script**. Add :

```
node {

    stage ('Build image') {
      container('build') {
        sh """
        mkdir myproj
        cd myproj
        echo 'FROM alpine:3.7' > Dockerfile
        docker build -t myalpine:latest .
        """
      }
    }

    stage ('Scan Image') {
      prismaCloudScanImage ca: '',
                    cert: '',
                    dockerAddress: 'unix:///var/run/docker.sock',
                    ignoreImageBuildTime: true,
                    image: 'myalpine:latest',
                    key: '',
                    logLevel: 'info',
                    podmanPath: '',
                    project: '',
                    resultsFile: 'prisma-cloud-scan-results.json'
     }

    stage ('Publish') {
      prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
    }

  }

```

Click **Save**.

From here, click **Build** Now on the left:

### View the scan results

**Click the job number** in Stage View to see the job details.

> **Check my progress**
>
> Install the Prisma Cloud Compute Jenkins plugin

### Change the vulnerability threshold and observe the change in the scan result

Go to the **Prisma Cloud Compute Console**,

Click **Defend** > **Vulnerabilities**.

Select the tab **Images** > **CI**.

Click Add **Rule**.

Add **Rule name** `fail critical`

Change the **Failure threshold** to critical by clicking on **Critical**.

Click **Advanced Setting**, then turn on **Apply rule only when vendor fixes are available**.

Click **Save**.

* * *

Go back to the **Jenkins**

Click **Build Now**

## Scan Code Repo - Github

