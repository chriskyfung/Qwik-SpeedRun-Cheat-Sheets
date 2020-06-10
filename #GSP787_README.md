# GSP787

## Query 1: Total Confirmed Cases

```sql
SELECT
    SUM(confirmed) AS total_cases_worldwide
FROM
    `bigquery-public-data.covid19_jhu_csse_eu.summary`
WHERE
    date = "2020-04-15"
```

## Query 2: Worst Affected Areas

```sql
SELECT
    COUNT(*) AS count_of_states
FROM (
    SELECT
        province_state AS state
        SUM(death) AS total_deaths
    FROM
        `bigquery-public-data.covid19_jhu_csse_eu.summary`
    WHERE
        date = "2020-04-10"
        AND country_region="US"
    GROUP BY
        state
    HAVING
        total_deaths > 100
)
```

## Query 3: Identifying Hotspots

## Query 2: Worst Affected Areas

```sql
SELECT
    province_state AS state
    SUM(death) AS total_confirmed_cases
FROM
    `bigquery-public-data.covid19_jhu_csse_eu.summary`
WHERE
    date = "2020-04-10"
    AND country_region="US"
GROUP BY
    state
HAVING
    total_confirmed_cases > 1000
ORDER BY
    total_confirmed_cases DESC
```

## Query 4: Fatality Ratio

```sql
SELECT
    SUM(confirmed) AS total_confirmed_cases,
    SUM(death) AS total_deaths,
    (SUM(death)/SUM(confirmed)) * 100 AS case_fatality_ratio
FROM
    `bigquery-public-data.covid19_jhu_csse_eu.summary`
WHERE
    date = "2020-04-30"
    AND country_region="Italy"
GROUP BY
    country_region
```

## Query 5: Identifying specific day

```sql
SELECT date
    FROM (
        SELECT
            date,
            sum(deaths) AS total_deaths
        FROM `bigquery-public-data.covid19_jhu_csse_eu.summary` 
        WHERE country_region="Italy" 
        GROUP BY date ORDER BY date
        )
WHERE total_deaths > 10000 
LIMIT 1
```

## Query 6: Finding days with zero net new cases

```sql
WITH india_cases_by_date AS (
  SELECT
    date,
    SUM(confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_jhu_csse_eu.summary`
  WHERE
    country_region="India"
    AND date between '2020-02-21' and '2020-03-15'
  GROUP BY
    date
  ORDER BY
    date ASC
 )

, india_previous_day_comparison AS
(SELECT
  date,
  cases,
  LAG(cases) OVER(ORDER BY date) AS previous_day,
  cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
FROM india_cases_by_date
)
SELECT
  COUNT(date)
FROM
  india_previous_day_comparison
WHERE
  net_new_case = 0
```

## Query 7: Doubling rate

```sql
WITH us_cases_by_date AS (
  SELECT
    date,
    SUM(confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_jhu_csse_eu.summary`
  WHERE
    country_region="India"
    AND date between '2020-03-22' and '2020-04-20'
  GROUP BY
    date
  ORDER BY
    date ASC
 )

, us_previous_day_comparison AS
(SELECT
  date,
  cases,
  LAG(cases) OVER(ORDER BY date) AS previous_day,
  cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
FROM us_cases_by_date
)
SELECT
  date AS Date,
  cases AS Confirmed_Cases_On_Day,
  previous_day AS Confirmed_Cases_Previous_Day
  (net_new_cases/previous_day) * 100 AS Percentage_Increase_In_Cases
FROM
  us_previous_day_comparison
HAVING
  Percentage_Increase_In_Cases > 10
```

## Query 8: Recovery rate

```sql
SELECT
    country_region AS country,
    SUM(recovered) AS recoverd_cases,
    SUM(confirmed) AS confirmed_cases,
    SUM(recovered) / SUM(confirmed) AS recovery_rate
FROM
    `bigquery-public-data.covid19_jhu_csse_eu.summary`
WHERE
    date="2020-05-10"
    AND confirmed > 50000
GROUP BY
    country_region
ORDER BY
    recovery_rate DESC
LIMIT 10
 ```

## Query 9: CDGR - Cumulative Daily Growth Rate

```sql
WITH
  france_cases AS (
  SELECT
    date,
    SUM(confirmed) AS total_cases
  FROM
    `bigquery-public-data.covid19_jhu_csse_eu.summary`
  WHERE
    country_region="France"
    AND date IN ('2020-01-24',
      '2020-05-10')
  GROUP BY
    date
  ORDER BY
    date)
, summary as (
SELECT
  total_cases AS first_day_cases,
  LEAD(total_cases) OVER(ORDER BY date) AS last_day_cases,
  DATE_DIFF(LEAD(date) OVER(ORDER BY date),date, day) AS days_diff
FROM
  france_cases
LIMIT 1
)

select first_day_cases, last_day_cases, days_diff, POWER(last_day_cases/first_day_cases,1/days_diff)-1 as cdgr
from summary
```