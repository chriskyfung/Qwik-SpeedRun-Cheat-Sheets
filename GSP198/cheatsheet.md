# GSP198 Processing Data with Google Cloud Dataflow

_last updated on 2021-10-06_
_last verified on 2021-10-06_

```bash
# Enter the following commands to clone the repository:

git clone https://github.com/GoogleCloudPlatform/data-science-on-gcp/

# Change to the repository source directory for this lab:

cd ~/data-science-on-gcp/04_streaming/simulate

# Create isolated Python environment:

virtualenv data-sci-env -p python3

# Activate isolated Python environment:

source data-sci-env/bin/activate

```

```bash
# Install the python packages that are required:

pip install timezonefinder pytz
pip install apache-beam[gcp]

```

```bash
python ./df05.py

tail all_events-00000-of-00001

export PROJECT_ID=$(gcloud info --format='value(config.project)')
bq mk --project_id $PROJECT_ID flights

cd ~/data-science-on-gcp/04_streaming/simulate

export BUCKET=${PROJECT_ID}-ml
gsutil cp airports.csv.gz gs://$BUCKET/flights/airports/airports.csv.gz

# Process the Data using Cloud Dataflow

python df06.py -p $PROJECT_ID -b $BUCKET -r us-central1

```

> Create a BigQuery Dataset.

> Copy the airport geolocation file to your Cloud Storage bucket.

> Process the Data using Cloud Dataflow (submit Dataflow job).

## Monitor the Cloud Dataflow job and inspect the processed data

1. Open Dataflow to monitor the progress of your job.

2. Open BigQuery.

  ```sql
  SELECT
  FL_NUM,
  ORIGIN,
  DEP_TIME,
  DEP_DELAY,
  DEST,
  ARR_TIME,
  ARR_DELAY,
  EVENT,
  NOTIFY_TIME
FROM
  `flightssample.simevents`
WHERE
  (DEP_DELAY > 15 and ORIGIN = 'SEA') or
  (ARR_DELAY > 15 and DEST = 'SEA')
ORDER BY
  NOTIFY_TIME ASC
LIMIT
  10

  ```

> Compose Queries.

```sql
SELECT
  EVENT,
  NOTIFY_TIME,
  EVENT_DATA
FROM
  `flightssample.simevents`
WHERE
  NOTIFY_TIME >= TIMESTAMP('2015-01-01 00:00:00 UTC')
  AND NOTIFY_TIME < TIMESTAMP('2015-01-03 00:00:00 UTC')
ORDER BY
  NOTIFY_TIME ASC
LIMIT
  10

```

## Test your Understanding

> To interact with BigQuery resources which CLI tool used in the lab?
>
> **bq**

> Which unified programming model is used to process data with Cloud Dataflow in the lab?
>
> Apache Beam

## Congratulations!
