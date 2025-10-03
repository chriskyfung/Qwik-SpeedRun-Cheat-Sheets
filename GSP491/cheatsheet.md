# GSP491 SpeedRun for Palo Alto Networks VM-Series Firewall: Scale Out Protection with Load Balancers

1. Go to **Compute Engines**, click `firewall-instance-1`, Copy the External IP of `nic1` network interface.
<br>

2. **Open** the IP with **HTTPS**
   - username: `paloalto`
   - password: `Pal0Alt0@123`
<br>

3. Open **Network** tab, click `ethernet1/1`, confirm the IP.
<br>

4. Go to **Policies** tab > **NAT**, click Add
   - Tab-1(General), **Name**: `Inbound-80`
   - Tab-2(Original Packet), 
      - **Source Zone** : Add `untrust`
      - **Destination Zone** : `untrust`
      - **Service** : `service-http`
      - **Destination Address** : IP of ethernet1/1 (_default: `10.5.1.2`_)
   - Tab-3(Translated Packet), 
      - **Interface**: ethernet1/2
      - **Static IP**: Load Balancer IP (_default: `10.5.2.7`_)

    Click **OK**
<br>

5. Click **Commit**
<br>

6. Go to **Pollices** tab > **Security**, click Add            
   - Tab-1(General), **Name**: `Inbound-80`
   - Tab-2(Source),  **Source Zone** : Add `untrust`
     **⇒ Tab-4**
   - Tab-4(Destination), **Destination Zone** : Add `trust`
      - **Destination Address** : IP of ethernet1/1 (_default: `10.5.1.2`_)
   - Tab-5(Application), Add **web-browsing**
     **=> Tab-7**
   - Tab-7(Actions),
      - **Profile Type** : Profiles
      - **Vulnerability** : Default
      - **File Blocking** : Basic file blocking
      - **WildFire** : Default
    
    Click **OK**
    <br>

7. Click **Commit**

* * *

1. Go to **Compute Engines**, click `firewall-instance-2`, Copy the External IP of `nic1` network interface.
<br>

2. **Open** the IP with **HTTPS**
   - username: `paloalto`
   - password: `Pal0Alt0@123`
<br>

3. Open **Network** tab, click `ethernet1/1`, confirm the IP.
<br>

4. Go to **Policies** tab > **NAT**, click Add
   - Tab-1(General), **Name**: `Inbound-80`
   - Tab-2(Original Packet), 
      - **Source Zone** : Add `untrust`
      - **Destination Zone** : `untrust`
      - **Service** : `service-http`
      - **Destination Address** : IP of ethernet1/1 (_default: `10.5.1.3`_)
   - Tab-3(Translated Packet), 
      - **Interface**: ethernet1/2
      - **Static IP**: Load Balancer IP (_default: `10.5.2.7`_)

    Click **OK**
<br>

5. Click **Commit**
<br>

6. Go to **Pollices** tab > **Security**, click Add            
   - Tab-1(General), **Name**: `Inbound-80`
   - Tab-2(Source),  **Source Zone** : Add `untrust`
     **⇒ Tab-4**
   - Tab-4(Destination), **Destination Zone** : Add `trust`
      - **Destination Address** : IP of ethernet1/1 (_default: `10.5.1.3`_)
   - Tab-5(Application), Add **web-browsing**
     **=> Tab-7**
   - Tab-7(Actions),
      - **Profile Type** : Profiles
      - **Vulnerability** : Default
      - **File Blocking** : Basic file blocking
      - **WildFire** : Default
    
    Click **OK**
    <br>

7. Click **Commit**
