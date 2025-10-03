# GSP665 Exploring the Public Cryptocurrency Datasets Available in BigQuery

_Last update_: 2020-06-20_
_Last verified: 2021-09-17_

📹 <https://youtu.be/I4UXjASFaz4>

## Tasks

1. Check pizza query / 10
2. Check dogecoin query / 10
3. transaction hash query / 40
4. Calculate balance query / 40

## Task 1: View the cryptocurrencies in the public dataset

1. Open **Navigation Menu** > **BigQuery**.

2. Click **+ ADD DATA** > **Explore public datasets** .

3. Seach `bitcoin`, select **Bitcoin Cash Cryptocurrency Dataset**.

4. View table `crypto`.

## Task 2: Perform a simple query

```sql
SELECT * FROM `bigquery-public-data.crypto_bitcoin.transactions` as transactions WHERE transactions.hash = 'a1075db55d416d3ca199f55b6084e2115b9345e16c5cf302fc80e9d5fbf5d48d'
```

> **Check my progress**
> Return the 10,000 BTC pizza purchase transaction.

## Task 3: Validate the data

### Double-entry book query of Dogecoin

```sql
-- SQL source from https://cloud.google.com/blog/products/data-analytics/introducing-six-new-cryptocurrencies-in-bigquery-public-datasets-and-how-to-analyze-them
WITH double_entry_book AS (
   -- debits
   SELECT
    array_to_string(inputs.addresses, ",") as address
   , inputs.type
   , -inputs.value as value
   FROM `bigquery-public-data.crypto_dogecoin.inputs` as inputs
   UNION ALL
   -- credits
   SELECT
    array_to_string(outputs.addresses, ",") as address
   , outputs.type
   , outputs.value as value
   FROM `bigquery-public-data.crypto_dogecoin.outputs` as outputs
)
SELECT
   address
,   type   
,   sum(value) as balance
FROM double_entry_book
GROUP BY 1,2
ORDER BY balance DESC
LIMIT 100
```

> **Check my progress**
> Calculate the balance for dogecoin.

## Task 5: Explore two famous cryptocurrency events

```sql
CREATE OR REPLACE TABLE lab.51 (transaction_hash STRING) as 
SELECT transaction_id FROM `bigquery-public-data.bitcoin_blockchain.transactions` , UNNEST( outputs ) as outputs
where outputs.output_satoshis = 19499300000000
```

> **Check my progress**
> Store the transaction hash of the large mystery transfer of 194993 BTC in the table 51 inside the lab dataset.

```sql
-- SQL source from https://cloud.google.com/blog/product...
CREATE OR REPLACE TABLE lab.52 (balance NUMERIC) as
WITH double_entry_book AS (
   -- debits
   SELECT
    array_to_string(inputs.addresses, ",") as address
   , -inputs.value as value
   FROM `bigquery-public-data.crypto_bitcoin.inputs` as inputs
   UNION ALL
   -- credits
   SELECT
    array_to_string(outputs.addresses, ",") as address
   , outputs.value as value
   FROM `bigquery-public-data.crypto_bitcoin.outputs` as outputs 
)
SELECT   
sum(value) as balance
FROM double_entry_book
where address = "1XPTgDRhN8RFnzniWCddobD9iKZatrvH4"
```

> **Check my progress**
> Store the balance of the pizza purchase address in the table 52 inside the lab dataset.
