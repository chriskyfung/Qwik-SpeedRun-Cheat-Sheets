sudo apt-get update && sudo apt-get install git -y && sudo apt-get install python-setuptools python-dev build-essential -y && sudo easy_install pip && python --version && pip --version


git clone -b GSP183 https://github.com/chriskyfung/Qwik-SpeedRun-Cheat-Sheets

cd ~/Qwik-SpeedRun-Cheat-Sheets/courses/developingapps/python/devenv/

sudo python server.py



sudo pip install -r requirements.txt

export PROJECT_ID=$(gcloud info --format='value(config.project)')

python list-gce-instances.py ${PROJECT_ID} --zone=us-central1-a
