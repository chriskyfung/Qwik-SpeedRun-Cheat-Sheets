**GSP280** Google Assistant: Customizing Templates
===

Open a new tab in your browser and go to the **Actions on Google Developer Console**
http://console.actions.google.com/

Click **New Project**

**Check my progress**
Create an Actions project and import GCP project


**Templates** > **Flash Cards**

**Build your Action** > **Add Action(s)** > **Add your first Action**

**Flash Cards Template** > **Make a copy**


| Question | Answer | Hint |
|----------|--------|------|
| What's the baby animal name for Bat? | pup | This is similar to a baby dog. |
| What's the baby animal name for Cow? | calf | This baby animal name starts with a "C". |
| What's the baby animal name for Snake? | hatchling | This name is the same as a baby alligator. |

* * *

## Create a Cloud Storage bucket

**Check my progress**
Create a Cloud Storage bucket


## Copy MP3 files to your Cloud Storage bucket

```bash
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=${PROJECT_ID}
gsutil mb gs://${BUCKET}

gsutil cp gs://spls/gsp280/gsp280-mp3-files.zip .
unzip gsp280-mp3-files.zip

gsutil cp -r gsp280-mp3-files gs://${BUCKET}
```

**Check my progress**
Copy MP3 files to your Cloud Storage bucket

## Add an MP3 file to the template

Go back to the Google Sheet, open the **Configuration** tab.

Set the `QuestionsPerGame` value to **2**

**Key**: `AudioGameOutro`

## Build and test your Action

Copy the Google Sheet url of **Copy of Flash Cards Game**

Go back to the **Actions console** and paste the url

**Upload**

Go to the Activity Controls page, 
https://myaccount.google.com/activitycontrols

**TURN ON** 
- Web & App Activity

### Test the application with the Actions simulator

`Talk to my test app`

## Add a flashcard template in another language

Modify languages

## Enable the Translation API


## Create a service account key

service account name:
`translation-api`

**Check my progress**
Create a service account key

Upload the JSON service account file to Cloud Shell

```bash
readlink -f service.json
```

```bash
export GOOGLE_APPLICATION_CREDENTIALS=$(readlink -f service.json)
```

```bash
curl -X POST \
     -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     --data "{
  'q': 'What\'s the baby animal name for bat?',
  'q': 'What\'s the baby animal name for cow?',
  'q': 'What\'s the baby animal name for snake?',
  'target': 'es'
}" "https://translation.googleapis.com/language/translate/v2"

curl -X POST \
     -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     --data "{
  'q': 'pup',
  'q': 'calf',
  'q': 'hatchling',
  'target': 'es'
}" "https://translation.googleapis.com/language/translate/v2"

curl -X POST \
     -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     --data "{
  'q': 'This is similar to a baby dog.',
  'q': 'This baby animal name starts with a C.',
  'q': 'This name is the same as a baby alligator.',
  'target': 'es'
}" "https://translation.googleapis.com/language/translate/v2"
```

| Question | Answer | Hint |
|----------|--------|------|
| ¿Cuál es el nombre del animalito para el murciélago? | cachorro | Esto es similar a un perro bebé. |
| ¿Cuál es el nombre del animalito para la vaca? | becerro | Este nombre animal de bebé comienza con una C. |
| ¿Cuál es el nombre del animalito para serpiente? | cría | Este nombre es lo mismo que un cocodrilo bebé. |
