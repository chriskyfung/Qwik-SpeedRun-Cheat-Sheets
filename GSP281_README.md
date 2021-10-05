GSP2181 [Introduction to SQL for BigQuery and Cloud SQL](https://google.qwiklabs.com/games/447/labs/1371)
===

_Last update_: 2020-06-20
_Last verified_: 2021-10-05

https://youtu.be/slaKIPNzhtQ 📹

**Tasks:**
- Create a cloud storage bucket / 25
- Upload CSV files to Cloud Storage / 25
- Create a Cloud SQL instance /25
- Create a database / 25

## Create a Cloud SQL instance

**Navigation menu** > **SQL**

**Create Instance** > **MySQL**

instance name: 
`qwiklabs-demo`

Save **Root password**. // or use `abc` as password

> Change the password in **SQL** > **Users** > **Root**, if forget.

* * *

**Answers of multiple choice questions:**
1. SELECT
2. FROM
3. WHERE

* * *

### Add "London Bicycle Hires" Dataset to BigQuery Console

**+ADD DATA** > **Explore public datasets**

`London Bicycle Hires`

**Answers of multiple choice questions:**
4. BigQuery
5. True
6. True

**Answers of multiple choice questions:**
7. GROUP BY
8. COUNT
9. AS
10. ORDER BY


## Exporting queries as CSV files

```sql
SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY num DESC;
```

**SAVE RESULTS** > **CSV(local file)** >
 `start_station_data.csv`

```sql
SELECT end_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY end_station_name ORDER BY num DESC;
```

**SAVE RESULTS** > **CSV(local file)** >
`end_station_data.csv`

## Upload CSV files to Cloud Storage

Create a cloud storage bucket.
Enter a *unique name* for your bucket, keep all other settings, and hit **Create**:
**Check my progress**

Upload CSV files to Cloud Storage.
**Check my progress**

Create a CloudSQL Instance.
**Check my progress**

* * *

## CREATE keyword (databases and tables)

Activate Google Cloud Shell

```bash
gcloud sql connect  qwiklabs-demo --user=root
```

Enter **Root password** of MySQL


**`MySQL >`** run the following lines,
```sql
CREATE DATABASE bike;
USE bike;
CREATE TABLE london1 (start_station_name VARCHAR(255), num INT);
USE bike;
CREATE TABLE london2 (end_station_name VARCHAR(255), num INT);
SELECT * FROM london1;
SELECT * FROM london2;
```

## Upload CSV files to tables


In your Cloud SQL instance page, click **IMPORT**.

**start_station_data.csv** to **bike**
`london1`

**end_station_data.csv** to **bike**
`london2`

* * *

## Finished

```sql
SELECT start_station_name AS top_stations, num FROM london1 WHERE num>100000
UNION
SELECT end_station_name, num FROM london2 WHERE num>100000
ORDER BY top_stations DESC;
```