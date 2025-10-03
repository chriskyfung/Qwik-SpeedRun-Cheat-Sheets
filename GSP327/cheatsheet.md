# GSP327 Engineer Data in Google Cloud: Challenge Lab

_last update_: 2020-06-17

### Tasks

1. Clean your training data
1. Create a BQML model called taxirides.fare_model
1. Perform a batch prediction on new data

## Task 1: Clean your training data

Make a copy of `historical_taxi_rides_raw` to `taxi_training_data` in the same dataset

Make sure:
- target column is called `fare_amount`

Data Cleaning Tasks:
- Keep rows for `trip_distance` > 0
- Remove rows for `fare_amount` > 2.5
- Ensure that the latitudes and longitudes are reasonable for the use case. ??
- Create a new column called `total_amount` from tolls_amount + fare_amount
- Sample the dataset < 1,000,000 rows
- Only copy fields that will be used in your model

1. Navigate to **BigQuery**
2. Click on **More** > **Query settings**
3. Select **Set a destination table for query results** under Destination; Enter `taxi_training_data` as the Table name
4. Click **Save**
5. Run the following SQL query

```sql
Select
  pickup_datetime,
  pickup_longitude AS pickuplon,
  pickup_latitude AS pickuplat,
  dropoff_longitude AS dropofflon,
  dropoff_latitude AS dropofflat,
  passenger_count AS passengers,
  ( tolls_amount + fare_amount ) AS fare_amount
FROM
  `taxirides.historical_taxi_rides_raw`
WHERE
  trip_distance > 0
  AND fare_amount >= 2.5
  AND pickup_longitude > -75 #limiting of the distance the taxis travel out
  AND pickup_longitude < -73
  AND dropoff_longitude > -75
  AND dropoff_longitude < -73
  AND pickup_latitude > 40
  AND pickup_latitude < 42
  AND dropoff_latitude > 40
  AND dropoff_latitude < 42
  AND passenger_count > 0
  AND RAND() < 999999 / 1031673361
```

> **Check my progress**
> Create a cleaned copy of the data in `taxi_training_data`

## Task 2: Create a BQML model called `taxirides.fare_model`

- Create a model called `taxirides.fare_model`
- Train the model with an RMSE < 10

#### Create a model

```sql
CREATE or REPLACE MODEL
  taxirides.fare_model OPTIONS (model_type='linear_reg',
    labels=['fare_amount']) AS
WITH
  taxitrips AS (
  SELECT
    *,
    ST_Distance(ST_GeogPoint(pickuplon, pickuplat), ST_GeogPoint(dropofflon, dropofflat)) AS euclidean
  FROM
    `taxirides.taxi_training_data` )
  SELECT
    *
  FROM
    taxitrips
```

#### Evaluate model performance

```sql
#standardSQL
SELECT
  SQRT(mean_squared_error) AS rmse
FROM
  ML.EVALUATE(MODEL taxirides.fare_model,
    (
    WITH
      taxitrips AS (
      SELECT
        *,
        ST_Distance(ST_GeogPoint(pickuplon, pickuplat), ST_GeogPoint(dropofflon, dropofflat)) AS euclidean
      FROM
        `taxirides.taxi_training_data` )
      SELECT
        *
      FROM
        taxitrips ))
```

## Task 3: Perform a batch prediction on new data

1. Select **Set a destination table for query results** under Destination; Enter `2015_fare_amount_predictions` as the Table name
2. Click **Save**
3. Run the following SQL query

```sql
#standardSQL
SELECT
  *
FROM
  ML.PREDICT(MODEL `taxirides.fare_model`,
    (
    WITH
      taxitrips AS (
      SELECT
        *,
        ST_Distance(ST_GeogPoint(pickuplon, pickuplat), ST_GeogPoint(dropofflon, dropofflat)) AS euclidean
      FROM
        `taxirides.report_prediction_data` )
    SELECT
      *
    FROM
      taxitrips ))
```
