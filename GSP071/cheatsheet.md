# GSP071 BigQuery: Qwik Start - Command Line

_last update: 2020-11-27_
_last verified: 2021-09-15_

```bash
bq show bigquery-public-data:samples.shakespeare

bq query --use_legacy_sql=false \
'SELECT
   word,
   SUM(word_count) AS count
 FROM
   `bigquery-public-data`.samples.shakespeare
 WHERE
   word LIKE "%raisin%"
 GROUP BY
   word'

bq query --use_legacy_sql=false \
'SELECT
   word
 FROM
   `bigquery-public-data`.samples.shakespeare
 WHERE
   word = "huzzah"'

bq mk babynames

wget http://www.ssa.gov/OACT/babynames/names.zip
unzip names.zip

bq load babynames.names2010 yob2010.txt name:string,gender:string,count:integer

bq query "SELECT name,count FROM babynames.names2010 WHERE gender = 'F' ORDER BY count DESC LIMIT 5"

bq query "SELECT name,count FROM babynames.names2010 WHERE gender = 'M' ORDER BY count ASC LIMIT 5"

```

> You can access BigQuery using:
>
> - BigQuery REST API
> - Command line tool
> - Web UI
^
> Which CLI tool is used to interact with BigQuery service?
>
> - bq

```bash
bq rm -r babynames

```
