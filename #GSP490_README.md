Shell script for Palo Alto Networks VM-Series Firewall: Securing GKE Clusters
=============================================================================

1. Go to the **Compute Engine** page, confirm the located **Zone** of the VM instance, called `firewall1`.
<br>

2. Create **Kubernetes Cluster**, called `cluster1`:
    - Name: cluster-1
    - Number of nodes: 2
    - Image type: Ubuntu
    - Machine type: 2vCPUs
    - Network: trust

3. Open a **Cloud Shell**
<br>

4. Go to **VPC Network** > **Routes**, Create the following **1st routing rule**:
    - Name: secure-outbound
    - Network: trust
    - Destination IP Range: 0.0.0.0/0
    - Priority: 100
    - Next Hop: Specify an instance
    - Next Hop Instance: firewall1
    **Create the rule**
<br>

5. Prepare for the **2nd routing rule**:
    - Name: apiserver-bypass
    - Network: trust
    - Destination IP Range: <LOAD-BALANCER-IP>/32
    - Priority: 100
    **DO NOT CREATE**
<br>

6. Go to the **Compute Engine** page, copy the **external IP** of the instance `firewall1` and open it with **HTTPS**: `https://<IP-of-VM-instance-firewall>`
<br>

7. **Login to Palo Alto**
    - user: paloalto
    - Password: Pal0Alt0@123
<br>

8. After the cluster is really, run the following commands in the Cloud Shell:
```bash
export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud container clusters get-credentials cluster-1 --zone us-central1-a --project $PROJECT_ID
kubectl get pods --all-namespaces -o wide
kubectl get svc

kubectl apply -f https://raw.githubusercontent.com/PaloAltoNetworks/ignite2018-how16/master/guestbook-all-in-one.yaml
kubectl get pods -o wide
kubectl get svc
```
<br>

9. Go to **Kubernetes Engine** > **Clusters**, obtain and copy the **Load Balancer IP**.
<br>

10. Go back the second routing page in **VPC Network** > **Routes**, paste the IP to the field.
<br>

11. Go to **Palo Alto** VM-Series web management **interface** > **Policies** > **NAT**,
    - **to-guestbook-nat-rule** >　**Translated Packet** tab,
    - paste the **IP** to the **Translated Address** field.
<br>

12. Go back to the **Qwiklab** page, click all three **Check my Progress**, then End the lab.