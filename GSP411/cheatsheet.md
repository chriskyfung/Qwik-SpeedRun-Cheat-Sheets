# GSP411 Ingesting New Datasets into BigQuery

_last update: 2020-11-27_

```bash
bq mk ecommerce

wget https://storage.googleapis.com/data-insights-course/exports/products.csv

bq load --source_format=CSV ecommerce.products products.csv --autodetect

bq query --use_legacy_sql=false \
'#standardSQL
SELECT
  *
FROM
  ecommerce.products
ORDER BY
  stockLevel DESC
LIMIT  5'
```

> How many rows are in the table?
> - 1090



> You can access BigQuery using:
>
> - BigQuery REST API
> - Command line tool
> - Web UI

> Which CLI tool is used to interact with BigQuery service?
> 
> - bq

```bash
bq rm -r babynames

```