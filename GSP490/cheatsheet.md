# GSP490 Palo Alto Networks VM-Series Firewall: Securing the GKE Perimeter

Last update: 2020-05-09

=============================================================================

## Networks

## VM-Series firewall

1. Go to the **Compute Engine** page, confirm the located **Zone** of the VM instance, called `firewall1`.

2. Copy the **External IP** and open it **HTTPS** in a new tab.

## Create a Kubernetes cluster

2. Create **Kubernetes Cluster**, called `cluster1`:

   | Fields    |   Value      |
   |-----------|--------------|
   | Name      | **cluster-1**  |
   | Region    | us-central1-a |
   | Number of nodes | **2**    |
   | Image type      | **Ubuntu** |
   | Machine type | **2vCPUs** |
   | Network      | **trust**  |

## Log in to the firewall

Login to Palo Alto

    | user  | Password |
    |-------|----------|
    | `paloalto` | `Pal0Alt0@123` |

1. Click **Policies** tab

2. Click **Security** in the left pane.

3. Click **NAT** in the left pane.

4. Click **Dashboard** tab, check **Serial #**

## Explore the cluster

After the cluster is really, run the following commands in the Cloud Shell:

```bash
export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud container clusters get-credentials cluster-1 --zone us-central1-a --project $PROJECT_ID
kubectl get pods --all-namespaces -o wide
kubectl get svc
```

> **Check my progress**
> Create a Kubernetes cluster

## Launch a two tiered application

```bash
kubectl apply -f https://raw.githubusercontent.com/PaloAltoNetworks/ignite2018-how16/master/guestbook-all-in-one.yaml
kubectl get pods -o wide
kubectl get svc
```

Go to **Kubernetes Engine** > **Clusters**, obtain and copy the **Load Balancer IP**.

> **Check my progress**
> Launch a two-tiered application

## Securing Inbound Traffic

1. Go to **Palo Alto** VM-Series web management interface > **Policies** > **NAT**,

2. Click on **to-guestbook-nat-rule** >　**Translated Packet** tab,

3. Paste the **load balancer IP** to the **Translated Address** field.

4. Click **OK**

5. Click **commit** on the top right, then click Commit to push the changes.

## Connect to the Guestbook Frontend

1. In the Cloud Console, select **Compute Engine** > **VM Instances**

2. Click **firewall1** and copy the External IP

3. Open the IP in a new tab

4. Type a message in the dialog box and click Submit in the guestbook application

5. Go back to Palo Alto interface, click **Monitor** tab.

6. Add the **NAT Dest IP** column

7. uncheck **Source User**

## Securing Outbound Traffic

Go to **VPC Network** > **Routes**, Create the following **1st routing rule**:
    
    | Field | Value |
    |-------|-------|
    | Name  | secure-outbound |
    | Network | trust |
    | Destination IP Range | 0.0.0.0/0 |
    | Priority | 100 |
    | Next Hop | Specify an instance |
    | Next Hop Instance | firewall1 |

Click **Create**

## Add Kube-Apiserver route

1. Select Navigation menu > Kubernetes Engine > Clusters

2. click on **cluster-1**, and copy the load balancer IP

3. Go to **VPC Network** > **Routes**, Create the following the **2nd routing rule**:

    | Field | Value |
    |-------|-------|
    | Name  | apiserver-bypass |
    | Network | trust |
    | Destination IP Range | <LOAD-BALANCER-IP>/32 |
    | Priority | 100 |
    | Next Hop | Default internet gateway

 4. Click **Create**

5. Go back to Palo Alto interface, click **Monitor** tab.

> **Check my progress**
> Securing Outbound Traffic