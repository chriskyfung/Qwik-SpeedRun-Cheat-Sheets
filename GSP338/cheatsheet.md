# GSP338 Monitor and Log with Google Cloud Operations Suite: Challenge Lab

Topics tested

Initialize Cloud Monitoring.
Configure a Compute Engine application for Cloud Operations Monitoring custom metrics.
Create a custom metric using Cloud Operations logging events.
Add custom metrics to a Cloud Monitoring Dashboard.
Create a Cloud Operations alert.


Create all resources in the us-east1 region and us-east1-b zone, unless otherwise directed.

Naming is team-resource, e.g. an instance could be named video-webserver1.

Tips and Tricks
Tip 1. The startup script for the Compute Instance is in the Compute Instance metadata key called startup_script.

Tip 2. The Compute Instance must have the Cloud Monitoring agent installed and the Go application requires environment variables to be configured with the Google Cloud project, the instance ID, and the compute engine zone.

Tip 3. The Video Queue length monitoring Go application writes the queue length metric data to a metric called custom.googleapis.com/opencensus/my.videoservice.org/measure/input_queue_size associated with the gce_instance resource type.

Tip 4. To create the custom log based metric, the easiest filter to use is the advanced filter query textPayload=~"file_format\: ([4,8]K).*". That is a regular expression that matches all Cloud Operations events for the two high resolution video formats you are interested in. You can use the same regular expression and configure labels in the metric definition, which creates a separate time series for each of the two high resolution formats.

Tip 5. You must use the name provided for the custom log based metric that monitors the rate at which high resolution videos are processed: large_video_upload_rate.

