**GSP290** ETL Processing on GCP Using Dataflow and BigQuery

##Download the Starter Code

```bash
gsutil -m cp -R gs://spls/gsp290/dataflow-python-examples .

export PROJECT=$(gcloud info --format='value(config.project)')

gcloud config set project $PROJECT

gsutil mb -c regional -l us-central1 gs://$PROJECT

gsutil cp gs://spls/gsp290/data_files/usa_names.csv gs://$PROJECT/data_files/
gsutil cp gs://spls/gsp290/data_files/head_usa_names.csv gs://$PROJECT/data_files/

bq mk lake
```
## Create Cloud Storage Bucket

> Click **Check my progress** 
> *Create a Cloud Storage Bucket*

## Copy Files to Your Bucket

> Click **Check my progress**
> *Copy Files to Your Bucket*

## Create the BigQuery Dataset

Click **Check my progress** *Create the BigQuery Dataset (name: lake)*


## Data Ingestion
### Run the Apache Beam Pipeline

```
export PROJECT=$(gcloud info --format='value(config.project)')

cd dataflow-python-examples/
# Here we set up the python environment.
# Pip is a tool, similar to maven in the java world

sudo pip install virtualenv

#Dataflow requires python 3.7
virtualenv -p python3 venv

source venv/bin/activate
pip install apache-beam[gcp]

python dataflow_python_examples/data_ingestion.py --project=$PROJECT --region=us-central1 --runner=DataflowRunner --staging_location=gs://$PROJECT/test --temp_location gs://$PROJECT/test --input gs://$PROJECT/data_files/head_usa_names.csv --save_main_session
```

> Click **Check my progress**
> *Build a Data Ingestion Dataflow Pipeline*


## Data Transformation
### Run the Apache Beam Pipeline

```
export PROJECT=$(gcloud info --format='value(config.project)')

cd dataflow-python-examples/
# Here we set up the python environment.
# Pip is a tool, similar to maven in the java world

sudo pip install virtualenv

#Dataflow requires python 3.7
virtualenv -p python3 venv

python dataflow_python_examples/data_transformation.py --project=$PROJECT --region=us-central1 --runner=DataflowRunner --staging_location=gs://$PROJECT/test --temp_location gs://$PROJECT/test --input gs://$PROJECT/data_files/head_usa_names.csv --save_main_session
```

> Click **Check my progress**
> *Build a Data Transformation Dataflow Pipeline*

## Data Enrichment
### Run the Apache Beam Pipeline

```
export PROJECT=$(gcloud info --format='value(config.project)')

cd dataflow-python-examples/
# Here we set up the python environment.
# Pip is a tool, similar to maven in the java world

sudo pip install virtualenv

#Dataflow requires python 3.7
virtualenv -p python3 venv

python dataflow_python_examples/data_enrichment.py --project=$PROJECT --region=us-central1 --runner=DataflowRunner --staging_location=gs://$PROJECT/test --temp_location gs://$PROJECT/test --input gs://$PROJECT/data_files/head_usa_names.csv --save_main_session
```

> Click **Check my progress**
> *Build a Data Enrichment Dataflow Pipeline*

## Data lake to Mart
### Run the Apache Beam Pipeline

```
export PROJECT=$(gcloud info --format='value(config.project)')

cd dataflow-python-examples/
# Here we set up the python environment.
# Pip is a tool, similar to maven in the java world

sudo pip install virtualenv

#Dataflow requires python 3.7
virtualenv -p python3 venv

python dataflow_python_examples/data_lake_to_mart.py --worker_disk_type="compute.googleapis.com/projects//zones//diskTypes/pd-ssd" --max_num_workers=4 --project=$PROJECT --runner=DataflowRunner --staging_location=gs://$PROJECT/test --temp_location gs://$PROJECT/test --save_main_session --region=us-central1
```

> Click **Check my progress**
> *Build a Data lake to Mart CoGroupByKey Dataflow Pipeline*

## Test your Understanding

> ETL stands for ____.
> - **Extract, Transform and Load**
