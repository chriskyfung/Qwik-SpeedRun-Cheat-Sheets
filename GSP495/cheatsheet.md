# GSP495 Palo Alto Networks Security Adapter for the Istio Service Mesh

1. Create **Kubernetes cluster** 
   - Name: `pan-istio-adapter`
   - Location type: **Zonal**
   - Master Version: **default**
   - Number of nodes: **4**
   - Cores: **2 vCPU**
   - Memory: **8GB*** with **"Extend memory"**
<br>

2. Open a **Cloud Shell** and Clone the following 3 repositories

```bash
git clone https://github.com/PaloAltoNetworks/pan_google_next_istio_lab
git clone https://github.com/vinayvenkat/pan_istio_policy_simulator
git clone http://github.com/PaloAltoNetworks/istio

edit istio/GKE/operatorconfig/pan-servicemesh-security-k8s.yaml
```

* * *

3. **After the cluster is really**, run the following scripts in the **Cloud Shell**

```bash
export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud container clusters get-credentials pan-istio-adapter --zone us-central1-a --project $PROJECT_ID

kubectl get pods --all-namespaces -o wide
kubectl get svc

kubectl create clusterrolebinding cluster-admin-binding \
   --clusterrole=cluster-admin \
    --user=$(gcloud config get-value core/account)
	
cd $HOME/pan_google_next_istio_lab
./download_istio.sh
./istio-cfg.sh install_istio
kubectl get pod -n istio-system
./istio-cfg.sh create_namespace pan-gcp-lab

./manage_app.sh create
source ./config.sh
cat config.sh
curl -o /dev/null -s -w "%{http_code}\n" http://${GATEWAY_URL}/productpage

echo http://${GATEWAY_URL}/productpage

kubectl get pod -n pan-gcp-lab

cd $HOME

cd pan_istio_policy_simulator
kubectl create configmap panw-security-policies --from-file sec_policy.json
kubectl apply -f panw_policy.yaml
kubectl get svc panw-policy
kubectl get deployment panw-policy
kubectl get pod
```
<br>

4. **Replace** the <span style="color:red;font-weight:bold;">\<POD-ID\></span> of **panw-policy** below, and then run the command

```bash
kubectl get pod panw-policy-<POD-ID>  -o yaml | grep podIP
```
<br>

5. apply new pod to the cluster

```bash
cd $HOME
cd istio/GKE
kubectl apply -f operatorconfig
kubectl get pod -n istio-system
```
<br>

6. **Replace** the <span style="color:red;font-weight:bold;">\<POD-ID\></span> of **pansecurityadapter**, and then run the command

```bash
kubectl logs -n istio-system \pansecurityadapter-<POD-ID>   | more
```
