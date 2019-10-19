1. Go to the **Compute Engine** page, confirm the located **Zone** of the VM instance, called `firewall1`.

2. Create **Kubernetes Cluster**, called `cluster1`:
    - Name: cluster-1
    - Number of nodes: 2
    - Image type: Ubuntu
    - Machine type: 2vCPUs
    - Network: trust

3. Open a **Cloud Shell**

4. Go to **VPC Network** > **Routes**, Create the following rule:
    - Name: secure-outbound
    - Network: trust
    - Destination IP Range: 0.0.0.0/0
    - Priority: 100
    - Next Hop: Specify an instance
    - Next Hop Instance: firewall1
    - Create the rule

## Prepare for the second routing rule
    - Name: apiserver-bypass
    - Network: trust
    - Destination IP Range: <LOAD-BALANCER-IP>/32
    - Priority: 100
    - ** DO NOT CREATE


## Go to the Compute Engine page, copy the external IP of the instance 'firewall1' and open it with HTTPS
https://<IP-of-VM-instance-firewall>

# user: paloalto
# Password: Pal0Alt0@123


## After the cluster is really, run the following commands in the Cloud Shell