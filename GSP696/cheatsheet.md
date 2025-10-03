# GSP696 Prisma Cloud Compute: Securing GKE Run Time

Late update: 2020-05-09

1. Create console using twistlock_console.yaml
1. Install Defender daemonset
1. Create sock-shop namespace and deploy service
1. Deploy the Graboid container yaml file


## Connect to the Kubernetes Cluster

From the Navigate menu, go to **Kubernetes Engine** > **Cluster**

Wait for your Kubernetes Cluster

Click **Connect** button, and then click **Run in Cloud Shell**.

## Install Prisma Cloud Compute

```bash
wget https://cdn.twistlock.com/releases/6e6c2d6a/prisma_cloud_compute_edition_20_04_163.tar.gz

mkdir prisma_cloud_compute_edition

tar xvzf prisma_cloud_compute_edition_20_04_163.tar.gz -C prisma_cloud_compute_edition/

cd prisma_cloud_compute_edition
```

Click the **Token link** which will open a new tab in the browser.

```bash
./linux/twistcli console export kubernetes --service-type LoadBalancer
```

Paste the `token` into Cloud Shell. **You will NOT see the token when you paste it into Cloud Shell**. Press **Enter** after the paste

```bash
kubectl create -f twistlock_console.yaml

kubectl get service -w -n twistlock
```

Once you see the EXTERNAL-IP use **Ctrl + C** to stop the wait flag

Open https://[YOUR-EXTERNAL-IP]:8083, click **Proceed Unsafe**

| user | Password |
|------|----------|
| admin|Pal0Alt0@123|

Click on **Key** on the start page, paste it in the update field and click **Register**

From the Prisma Cloud Compute Console go to **Manage** > **Defenders**.

Click on the **Deploy** tab, then the **DaemonSet** tab.

Client name: **twistlock-console**

Scroll to section 11, choose **Linux**.

Select **Copy** for the **Install** script.

Past the command to **Google Cloud Shell**

In the Prisma Cloud Console, navigate to **Manage** > **Defenders** > **Manage**

Go to **Defend** > **Firewalls**, enable **Firewall rules for containers**.

Click **Relearn**

## Install Web Services

In Google Cloud Shell,

```bash
git clone https://github.com/PaloAltoNetworks/prisma_cloud; cd prisma_cloud

kubectl create namespace sock-shop

kubectl apply -f sock-shop.yaml

kubectl get pods -o wide -n sock-shop
kubectl get pods -o wide -n sock-shop
kubectl get pods -o wide -n sock-shop

kubectl get ingress -n sock-shop
kubectl get ingress -n sock-shop
kubectl get ingress -n sock-shop
```

Copy the IP Address, and open it in a new tab.

After approximately 1-2 minutes, refresh the page

Log in the SockShop

| Username | Password |
|----------|----------|
| `user`   |`password`|

Go back to Prisma Cloud Console, and in the **Radar** view, and check **sock-shop** in **filter**, then **refresh** in the lower right-hand corner.

Type **shi** in the search box

Click the container named **shipping:0.4.8**

Click **Vulnerabilities**

Find the container **mongo:latest** and observe the network connections to the container from container **order:0.4.7** and **cart:0.4.8**

Click on the link between **order:0.4.7** and **mongo:latest**

## Runtime Security and Container Runtime Model

## Real World Use Case: Detect and Stop Crypto Mining

#### Deploy an image that seems to be a Nginx image but contains Graboid worm

```bash
kubectl create -f graboid.yaml

kubectl get pod
```

#### Use Prisma Cloud Compute to create a security policy and detect the crypto mining activity

To create a Container Policy, **Defend** > **Runtime** > **Container Policy**, click "**Add rule**"

| Rule name |
|-----------|
| `Graboid` |

Click **Custom Rules** tab, the click **Select Rule**

Select Rule "**Common Crypto mining pool ports**" and **Apply**.

Click **Save**

## Review logs

Click **Monitor** > **Events**, then click **Forensic**

Block the crypto mining activity and kill the Graboid Worm

Defend > Runtime, select Container Policy tab, click Graboid to edit the policy

Click Gaboid, the change Effect to Block, Log As to Incident, then Save the policy:

Wait one minute for the policy to update. Then go to Monitor > Runtime to observe the Incidents

Also Monitor > Event.

```bash
kubectl get pod -w
```