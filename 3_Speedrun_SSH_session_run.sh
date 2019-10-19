sudo pip install -r requirements.txt

export PROJECT_ID=$(gcloud info --format='value(config.project)')

python list-gce-instances.py ${PROJECT_ID} --zone=us-central1-a