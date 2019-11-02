GSP008 Rent-a-VM to Process Earthquake Data
===

**Requirements:**

1. Create Compute Engine instance with the necessary API access
2. Install software
3. Ingest USGS data
4. Transform the data
5. Create bucket and Store data


## Create Compute Engine instance with the necessary API access

Create an instance

**Allow full access to all Cloud APIs**

Click **SSH**

```bash
cat /proc/cpuinfo

# Install software
sudo apt-get update
sudo apt-get -y -qq install git
```

```bash
sudo apt-get -y install python-mpltoolkits.basemap
```

```bash
git --version

# Ingest USGS data
git clone -b GSP008 https://github.com/chriskyfung/Qwik-SpeedRun-Cheat-Sheets

cd Qwik-SpeedRun-Cheat-Sheets/CPB100/lab2b
bash ingest.sh
```

```
head earthquakes.csv

# Transform the data
bash install_missing.sh
python3 transform.py
ls -l

# Create a GCS bucket
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=${PROJECT_ID}
gsutil mb -c multi_regional gs://${BUCKET}
gsutil cp earthquakes.* gs://${BUCKET}/earthquakes/

# Add a permission for all users
gsutil acl ch -u AllUsers:R gs://${BUCKET}/earthquakes/earthquakes.csv
gsutil acl ch -u AllUsers:R gs://${BUCKET}/earthquakes/earthquakes.htm
gsutil acl ch -u AllUsers:R gs://${BUCKET}/earthquakes/earthquakes.png

echo https://storage.cloud.google.com/${BUCKET}/earthquakes/earthquakes.png
```