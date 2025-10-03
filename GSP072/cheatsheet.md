# GSP072 BigQuery: Qwik Start - Console

_last update_: 2020-08-15
_last verified: 2020-08-15

## Query a public dataset

Navigate to **BigQuery**, and run:

```sql
#standardSQL
SELECT
 weight_pounds, state, year, gestation_weeks
FROM
 `bigquery-public-data.samples.natality`
ORDER BY weight_pounds DESC LIMIT 10;
```

> **Check my progress**
> Query a public dataset (dataset: samples, table: natality)

## Load custom data into a table

### Create a dataset

```bash
bq --location=US mk -d babynames
gsutil cp gs://spls/gsp072/baby-names.zip .
unzip baby-names
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=${PROJECT_ID}
gsutil mb -c multi_regional gs://${BUCKET}
gsutil cp yob2014.txt gs://${BUCKET}
bq load --source_format=CSV babynames.names_2014 gs://${BUCKET}/yob2014.txt name:string,gender:string,count:integer
```

> **Check my progress**
> Create a new dataset

## Add custom data

## Create a Cloud Storage bucket

> **Check my progress**
> Create a bucket
> Copy file in your bucket

## Load the data into a new table

| Field | Value |
| --- | --- |
| Create table from | **Google Cloud Storage** |
| Select file from GCS bucket | `<bucket_name>/yob2014.txt` |
| File format | **CSV** |
| Table name | `names_2014` |
| Schema > Edit as text | `name:string,gender:string,count:integer` |

> **Check my progress**
> Load data into your table

## Test your Understanding

> BigQuery is fully-managed enterprise data warehouse that enable super-fast SQL queries.
> **True**

## Query a custom dataset

Go back to the **BigQuery** page, run:

```sql
#standardSQL
SELECT
 name, count
FROM
 `babynames.names_2014`
WHERE
 gender = 'M'
ORDER BY count DESC LIMIT 5;
```

> **Check my progress**
> Query a custom dataset