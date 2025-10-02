# GSP852 Building Demand Forecasting with BigQuery ML

[NYC Citi Bike Trips](https://console.cloud.google.com/marketplace/product/city-of-new-york/nyc-citi-bike?project=qwiklabs-gcp-03-3ce9522a0123&folder=&organizationId=)


```sql
SELECT
   bikeid,
   starttime,
   start_station_name,
   end_station_name,
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`
LIMIT 5

```

> **Whats the purpose of the LIMIT keyword?**
> 
> LIMIT the number of results returned

```sql
SELECT
  EXTRACT (DATE FROM TIMESTAMP(starttime)) AS start_date,
  start_station_id,
  COUNT(*) as total_trips
FROM
 `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE
   starttime BETWEEN DATE('2016-01-01') AND DATE('2017-01-01')
GROUP BY
    start_station_id, start_date
LIMIT 5

```

> **How would you display the time element of a TIMESTAMP?**
>
> TIME FROM TIMESTAMP(...)

Create a dataset `bqmlforecast`

```sql
SELECT
 DATE(starttime) AS trip_date,
 start_station_id,
 COUNT(*) AS num_trips
FROM
 `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE
 starttime BETWEEN DATE('2014-01-01') AND ('2016-01-01')
 AND start_station_id IN (521,435,497,293,519)
GROUP BY
 start_station_id,
 trip_date

```

**SAVE RESULTS** > BigQuery table > `training_data`

```sql
CREATE OR REPLACE MODEL bqmlforecast.bike_model
  OPTIONS(
    MODEL_TYPE='ARIMA',
    TIME_SERIES_TIMESTAMP_COL='trip_date',
    TIME_SERIES_DATA_COL='num_trips',
    TIME_SERIES_ID_COL='start_station_id',
    HOLIDAY_REGION='US'
  ) AS
  SELECT
    trip_date,
    start_station_id,
    num_trips
  FROM
    bqmlforecast.training_data

```

> **What type of tuning is performed by the ARIMA algorithm?**
>
> Hyper-parameter

```sql
SELECT
  *
FROM
  ML.EVALUATE(MODEL bqmlforecast.bike_model)

```

> **Where can you find helpful information and tutorials on BigQuery ML?**
>
> cloud.google.com/bigquery-ml

```sql
 DECLARE HORIZON STRING DEFAULT "30"; #number of values to forecast
 DECLARE CONFIDENCE_LEVEL STRING DEFAULT "0.90";

 EXECUTE IMMEDIATE format("""
     SELECT
         *
     FROM
       ML.FORECAST(MODEL bqmlforecast.bike_model,
                   STRUCT(%s AS horizon,
                          %s AS confidence_level)
                  )
     """, HORIZON, CONFIDENCE_LEVEL)

```

> **Whats types of Models does BigQuery support?**
>
> Linear Regression


