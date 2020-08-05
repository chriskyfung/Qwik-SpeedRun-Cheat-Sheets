export PROJECT_ID=$(gcloud info --format='value(conf
ig.project)')
export BUCKET=${PROJECT_ID}
gsutil mb -c multi_regional gs://${BUCKET}

gcloud pubsub topics create kraken-topic

wget https://github.com/chriskyfung/Qwik-SpeedRun-Cheat-Sheets/raw/GSP315/index.js
wget https://github.com/chriskyfung/Qwik-SpeedRun-Cheat-Sheets/raw/GSP315/package.json

gcloud functions deploy function-1 --region us-east1 --runtime=nodejs8 --entry-point=thumbnail --trigger-event=google.storage.object.finalize --trigger-resource=${PROJECT_ID}

wget https://github.com/chriskyfung/Qwik-SpeedRun-Cheat-Sheets/raw/GSP315/map.jpg
gsutil cp map.jpg gs://${PROJECT_ID}