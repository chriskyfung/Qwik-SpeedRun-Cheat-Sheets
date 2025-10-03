# GSP425 Site Reliability Troubleshooting with Cloud Monitoring APM

_last updated on 2021-08-25_
_last verified on 2021-08-25_

## Create a Monitoring workspace

In the Cloud Console, click **Navigation menu** > **Monitoring**.

## Infrastructure setup

```bash
gcloud config set compute/zone us-west1-b
export PROJECT_ID=$(gcloud info --format='value(config.project)')

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/blogs/microservices-demo-1 ~/microservices-demo-1

curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/v0.36.0/skaffold-linux-amd64 && chmod +x skaffold && sudo mv skaffold /usr/local/bin

gcloud container clusters get-credentials shop-cluster --zone us-west1-b

kubectl get nodes

cd microservices-demo-1
skaffold run

kubectl get pods
```

> Deploy application

```bash
export EXTERNAL_IP=$(kubectl get service frontend-external | awk 'BEGIN { cnt=0; } { cnt+=1; if (cnt > 1) print $4; }')

curl -o /dev/null -s -w "%{http_code}\n"  http://$EXTERNAL_IP

./setup_csr.sh
```

## Configure Latency SLI

1. In the Cloud Monitoirng window, click **Alerting** from the left menu, then click **Create Policy**.

2. Click **Add Condition**

3. Find resource type and metric:

   `custom.googleapis.com/opencensus/grpc.io/client/roundtrip_latency`

4. In the Resource Type type in `Global`.

5. Click into the **Filter** field and select `opencensus_task`.

6. Set the Aggregator to **99th percentile**.

   ![](https://cdn.qwiklabs.com/MRuoV5YYtmdGz%2BhAWFwONbPlkbKs7Igqem6KO%2BiDhOc%3D)

7. In the Configuration area,

   - Condition triggers if **Any time series violates**
   - Condition: **is above**
   - Threshold: **500**
   - For: **Most recent value**

8. Skip the **Who should be notified?**

9. name the alerting policy as `Latency Policy`.

> Configure Latency SLI

## Configure Availability SLI

1. In the Console, select **Navigation menu** > **Logging** > **Logs Explorer**.

2. Filter:

  - Resource type: **Kubernetes Container**
  - Log Level: **ERROR**
  - filter search bar: `label:k8s-pod/app:"currencyservice"`

3. Click **Create Metric**.

4. Name the metric `Error_Rate_SLI`

5. In the Console, select **Logging** > **Logs-based Metrics**

6. Click 3 dots ( ⁝ ) , then select **Create alert from metric**.

7. Name the condition `Error Rate SLI`.

8. Click the **Show Advanced Options** link, and set:

   - Aligner: **rate**
   - Threshold: **0.5** for **1 minute**

9. Skip the `Who should be notified?`

10. name the alerting policy as **Error Rate SLI**.

> Configure Availability SLI

## Deploy new release

In the Cloud Shell, open Editor.

 ⁝ 
 ⁝ 