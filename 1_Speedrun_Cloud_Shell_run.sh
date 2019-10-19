git clone -b GSP168 https://github.com/chriskyfung/My-Qwiklabs-SpeedRun-Tank/
cd ~/My-Qwiklabs-SpeedRun-Tank/courses/developingapps/java/cloudstorage/start
. prepare_environment.sh
export PROJECT_ID=$(gcloud info --format='value(config.project)')
gsutil mb gs://${PROJECT_ID}-media
export GCLOUD_BUCKET=${PROJECT_ID}-media
mvn spring-boot:run
