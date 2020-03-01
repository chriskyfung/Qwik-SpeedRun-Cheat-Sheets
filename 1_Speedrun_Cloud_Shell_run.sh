#git clone https://github.com/GoogleCloudPlatform/training-data-analyst
#cd ~/training-data-analyst/courses/developingapps/java/cloudstorage/start
git clone -b GSP168 https://github.com/chriskyfung/Qwik-SpeedRun-Cheat-Sheets/
cd ~/Qwik-SpeedRun-Cheat-Sheets/courses/developingapps/java/cloudstorage/start
. prepare_environment.sh
export PROJECT_ID=$(gcloud info --format='value(config.project)')
gsutil mb gs://${PROJECT_ID}-media
export GCLOUD_BUCKET=${PROJECT_ID}-media
mvn spring-boot:run
