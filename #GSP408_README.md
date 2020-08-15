# GSP408 Troubleshooting Common SQL Errors with BigQuery

Navigate to **BigQuery**

## Find the total number of customers who went through checkout

### Troubleshoot queries that contain query validator, alias, and comma errors

```sql
#standardSQL
SELECT  FROM `data-to-inghts.ecommerce.rev_transactions` LIMIT 1000
```

> What's wrong with the previous query to view 1000 items?
> - **We have not specified any columns in the SELECT**
> - **There is a typo in the dataset name**

What about this updated query?

```sql
#standardSQL
SELECT * FROM [data-to-insights:ecommerce.rev_transactions] LIMIT 1000
```

> What's wrong with the new previous query to view 1000 items?
> - **We are using legacy SQL**

What about this query that uses Standard SQL?

```sql
#standardSQL
SELECT FROM `data-to-insights.ecommerce.rev_transactions`
```

> What is wrong with the previous query?
> - **Still no columns defined in SELECT**

What about now? This query has a column.

```sql
#standardSQL
SELECT
fullVisitorId
FROM `data-to-insights.ecommerce.rev_transactions`
```

> What is wrong with the previous query?
> - **Without aggregations, limits, or sorting, this query is not insightful**
> - **The page title is missing from the columns in SELECT**

What about now? The following query has a page title.

```sql
#standardSQL
SELECT fullVisitorId hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions` LIMIT 1000
```

> How many columns will the previous query return?
> - **1, a column named hits_page_pageTitle**

What about now? The missing comma has been corrected.

```sql
#standardSQL
SELECT
  fullVisitorId
  , hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions` LIMIT 1000
```

### Troubleshoot queries that contain logic errors, GROUP BY statements, and wildcard filters

Aggregate the following query to answer the question: How many unique visitors reached checkout?

```sql
#standardSQL
SELECT
  fullVisitorId
  , hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions` LIMIT 1000
```

What about this? An aggregation function, COUNT(), was added.

```sql
#standardSQL
SELECT
COUNT(fullVisitorId) AS visitor_count
, hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions`
```

> What is wrong with the previous query?
> - **The COUNT() function does not de-deduplicate the same fullVisitorId**
> - **It is missing a GROUP BY clause**

In this next query, `GROUP` BY and `DISTINCT` statements were added.

```sql
#standardSQL
SELECT
COUNT(DISTINCT fullVisitorId) AS visitor_count
, hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions`
GROUP BY hits_page_pageTitle
```

Great! The results are good, but they look strange. Filter to just "Checkout Confirmation" in the results.

```sql
#standardSQL
SELECT
COUNT(DISTINCT fullVisitorId) AS visitor_count
, hits_page_pageTitle
FROM `data-to-insights.ecommerce.rev_transactions`
WHERE hits_page_pageTitle = "Checkout Confirmation"
GROUP BY hits_page_pageTitle
```

> **Check my progress**
> Find the total number of customers went through checkout

## List the cities with the most transactions with your ecommerce site

### Troubleshoot ordering, calculated fields, and filtering after aggregating errors

```sql
#standardSQL
SELECT
geoNetwork_city,
SUM(totals_transactions) AS totals_transactions,
COUNT( DISTINCT fullVisitorId) AS distinct_visitors
FROM
`data-to-insights.ecommerce.rev_transactions`
GROUP BY geoNetwork_city
ORDER BY distinct_visitors DESC
```

> Which city had the most distinct visitors? Ignore the value: 'not available in this demo dataset'
> Mountain View

What's wrong with the following query?

```sql
#standardSQL
SELECT
geoNetwork_city,
SUM(totals_transactions) AS total_products_ordered,
COUNT( DISTINCT fullVisitorId) AS distinct_visitors,
SUM(totals_transactions) / COUNT( DISTINCT fullVisitorId) AS avg_products_ordered
FROM
`data-to-insights.ecommerce.rev_transactions`
WHERE avg_products_ordered > 20
GROUP BY geoNetwork_city
ORDER BY avg_products_ordered DESC
```

> What is wrong with the previous query?
> - **You cannot filter on aliased fields within the `WHERE` clause**
> - **You cannot filter aggregated fields in the `WHERE` clause (use `HAVING` instead)**

```sql
#standardSQL
SELECT
geoNetwork_city,
SUM(totals_transactions) AS total_products_ordered,
COUNT( DISTINCT fullVisitorId) AS distinct_visitors,
SUM(totals_transactions) / COUNT( DISTINCT fullVisitorId) AS avg_products_ordered
FROM
`data-to-insights.ecommerce.rev_transactions`
GROUP BY geoNetwork_city
HAVING avg_products_ordered > 20
ORDER BY avg_products_ordered DESC
```

> **Check my progress**
> List the cities with the most transactions with your ecommerce site

## Find the total number of products in each product category

### Find the top selling products by filtering with NULL values

What's wrong with the following query? How can you fix it?

```sql
#standardSQL
SELECT hits_product_v2ProductName, hits_product_v2ProductCategory
FROM `data-to-insights.ecommerce.rev_transactions`
GROUP BY 1,2
```
> What is wrong with the previous query?
> - **No aggregate functions are used**

What is wrong with the following query?
> - **Large GROUP BYs really hurt performance (consider filtering first and/or using aggregation functions)**
> - **No aggregate functions are used**

```sql
#standardSQL
SELECT
COUNT(hits_product_v2ProductName) as number_of_products,
hits_product_v2ProductCategory
FROM `data-to-insights.ecommerce.rev_transactions`
WHERE hits_product_v2ProductName IS NOT NULL
GROUP BY hits_product_v2ProductCategory
ORDER BY number_of_products DESC
```

> What is wrong with the previous query which lists products?
> - **The COUNT() function is not the distinct number of products in each category**

```sql
#standardSQL
SELECT
COUNT(DISTINCT hits_product_v2ProductName) as number_of_products,
hits_product_v2ProductCategory
FROM `data-to-insights.ecommerce.rev_transactions`
WHERE hits_product_v2ProductName IS NOT NULL
GROUP BY hits_product_v2ProductCategory
ORDER BY number_of_products DESC
LIMIT 5
```

> Which category has the most distinct number of products offered?
> (not set)

> **Check my progress**
> Find the total number of products in each product category