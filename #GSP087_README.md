# **GSP087** Autoscaling an Instance Group with Stackdriver Custom Metrics

```
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=${PROJECT_ID}
gsutil mb -c multi_regional gs://${BUCKET}

gsutil cp -r gs://spls/gsp087/* gs://${BUCKET}
```

## Creating an instance template

1. Navigation menu > Compute Engine > Instance templates

autoscaling-instance01

2. Management, security, disks, networking

Management > Metadata

startup-script-url

gs://[YOUR_BUCKET_NAME]/startup.sh

gcs-bucket

gs://[YOUR_BUCKET_NAME]

Click Create.

Test Completed Task
Create an instance template

## Creating the instance group

*DO NOT START UNTIL COMPLETE CREATING INSTANCE TEMPLATE*

autoscaling-instance-group-1

Don't autoscale

Click Create.

Test Completed Task

Create an instance group

## Configure autoscaling for the instance group

Compute Engine > Instance groups

Configure autoscaling

Autoscale

Metric Type: Stackdriver monitoring metric

Metric export scope: Time series per instance

Metric identifier: custom.googleapis.com/appdemo_queue_depth_01

Utilization target: 150

Utilization target type: Gauge

Minimum number of instances: 1

Maximum number of instances: 3

Test Completed Task

Configure autoscaling for the instance group


## Watching the instance group perform autoscaling

1. Monitoring tab to view the Autoscaled size graph
2. In the left pane, click Instance groups.
3. Click the `builtin-igm` instance group in the list.
4. Click the Monitoring tab.



