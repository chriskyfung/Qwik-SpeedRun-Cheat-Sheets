**GSP290** ETL Processing on GCP Using Dataflow and BigQuery

##Download the Starter Code

```bash
git clone https://github.com/GoogleCloudPlatform/professional-services.git

export PROJECT=$(gcloud info --format='value(config.project)')

gcloud config set project $PROJECT

gsutil mb -c regional -l us-central1 gs://$PROJECT

gsutil cp gs://python-dataflow-example/data_files/usa_names.csv gs://$PROJECT/data_files/

gsutil cp gs://python-dataflow-example/data_files/head_usa_names.csv gs://$PROJECT/data_files/

bq mk lake

cd professional-services/examples/dataflow-python-examples/

# edit data_ingestion.py

sudo pip install --upgrade virtualenv

virtualenv -p `which python 2.7` dataflow-env

source dataflow-env/bin/activate
pip install apache-beam[gcp]

python dataflow_python_examples/data_ingestion.py --project=$PROJECT --runner=DataflowRunner --staging_location=gs://$PROJECT/test --temp_location gs://$PROJECT/test --input gs://$PROJECT/data_files/head_usa_names.csv --save_main_session

```

Click **Check my progress** *Create a Cloud Storage Bucket*

## Copy Files to Your Bucket

Click **Check my progress** *Copy Files to Your Bucket*

## Create the BigQuery Dataset

Click **Check my progress** *Create the BigQuery Dataset (name: lake)*

## Build a Dataflow Pipeline

### Step 1 - Open Code Editor

Open **Code Editor** in **Cloud Shell**

### Step 2 - Data Ingestion

#### Review Pipeline Python Code
#### Run the Apache Beam Pipeline

Return to the GCP Console and open the **Navigation menu** > **Dataflow** to view the status of your job.

Wait for the **Job Status** to be **Succeeded**

**Navigation menu** > **BigQuery**

Click **Check my progress** *Build a Data Ingestion Dataflow Pipeline*

## Step 3 - Data Transformation

### Review Pipeline Python Code
### Run the Apache Beam Pipeline

```bash
export PROJECT=$(gcloud info --format='value(config.project)')

gcloud config set project $PROJECT

cd professional-services/examples/dataflow-python-examples/

virtualenv -p `which python 2.7` dataflow-env

source dataflow-env/bin/activate
pip install apache-beam[gcp]
python dataflow_python_examples/data_transformation.py --project=$PROJECT --runner=DataflowRunner --staging_location=gs://$PROJECT/test --temp_location gs://$PROJECT/test --input gs://$PROJECT/data_files/head_usa_names.csv --save_main_session
```

Wait for the **Job Status** to be **Succeeded**

Click **Check my progress** *Build a Data Transformation Dataflow Pipeline*

## Step 4 - Data Enrichment

```bash
export PROJECT=$(gcloud info --format='value(config.project)')

gcloud config set project $PROJECT

cd professional-services/examples/dataflow-python-examples/

virtualenv -p `which python 2.7` dataflow-env

source dataflow-env/bin/activate
pip install apache-beam[gcp]

python dataflow_python_examples/data_enrichment.py --project=$PROJECT --runner=DataflowRunner --staging_location=gs://$PROJECT/test --temp_location gs://$PROJECT/test --input gs://$PROJECT/data_files/head_usa_names.csv --save_main_session
```

Wait for the **Job Status** to be **Succeeded**

Click **Check my progress** *Build a Data Enrichment Dataflow Pipeline*

## Step 5 - Data lake to Mart

```bash
export PROJECT=$(gcloud info --format='value(config.project)')

gcloud config set project $PROJECT

cd professional-services/examples/dataflow-python-examples/

virtualenv -p `which python 2.7` dataflow-env

source dataflow-env/bin/activate
pip install apache-beam[gcp]

python dataflow_python_examples/data_lake_to_mart.py --worker_disk_type="compute.googleapis.com/projects//zones//diskTypes/pd-ssd" --max_num_workers=4 --project=$PROJECT --runner=DataflowRunner --staging_location=gs://$PROJECT/test --temp_location gs://$PROJECT/test --save_main_session
```

Wait for the **Job Status** to be **Succeeded**

Click **Check my progress** *Build a Data lake to Mart Dataflow Pipeline*

```bash
export PROJECT=$(gcloud info --format='value(config.project)')

gcloud config set project $PROJECT

cd professional-services/examples/dataflow-python-examples/

virtualenv -p `which python 2.7` dataflow-env

source dataflow-env/bin/activate
pip install apache-beam[gcp]

python dataflow_python_examples/data_lake_to_mart_cogroupbykey.py --worker_disk_type="compute.googleapis.com/projects//zones//diskTypes/pd-ssd" --max_num_workers=4 --project=$PROJECT --runner=DataflowRunner --staging_location=gs://$PROJECT/test --temp_location gs://$PROJECT/test --save_main_session
```

Wait for the **Job Status** to be **Succeeded**

Click **Check my progress** *Build a Data lake to Mart CoGroupByKey Dataflow Pipeline*

## Test your Understanding

**Select**
- Extract, Transform and Load
