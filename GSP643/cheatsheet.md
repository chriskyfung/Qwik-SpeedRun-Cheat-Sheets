# **GSP643** Build a Serverless Web App with Firebase

_last update: 2020-08-28 17:35_

## Enable the Google Cloud Firestore API and Setup a Firestore Database

1. Open the **Navigation menu** and select **APIs & Services** → **Library**. 
2. Enable **Google Cloud Firestore API**.
3. Navigate to **Firestore**.
4. **Select Native Mode**
5. **nam5 (United States)**

## Create a Firebase project

1. Open https://console.firebase.google.com/
2. Add Project

> **Check my progress**
>
> Create a Firebase project

## Register your app

1. Select the web icon (highlighted below) from the list of "Get started 

  ![](https://cdn.qwiklabs.com/Y1c%2B4Z8oJdTeafmgg%2Fwwa%2Bn%2FNP%2BvjvBSeVZwtY183qs%3D)

2. App nickname: `Pet Theory`

3. check **Set up Firebase hosting**

4. Click on the **Register app** button.

5. Click **Next** > **Next** > **Continue to console**.

> **Check my progress**
>
> Register your app

## Install the Firebase CLI and deploy to Firebase Hosting

```bash
git clone https://github.com/rosera/pet-theory.git
cd pet-theory/lab02
npm init --yes
npm install -g firebase-tools
Y
```

Copy and paste the URL generated in a new browser tab

```bash
gcloud config set compute/region us-central1

firebase init
```

1. Choose **Hosting: Configure and deploy Firebase Hosting sites**
2. Choose **Use an existing project**
3. Select your Qwiklabs GCP Project ID
4. Press Enter
5. Press Enter
6. **N** to keep your firestore.rules file.
7. Press Enter
8. **Y** to keep your firestore.indexes.json file.
9. Press Enter
10. **N** to disallow rewrites to your /index.html file.
11. Enter in N when prompted to overwrite your 404.html file.
12. Enter in N when prompted to overwrite your index.html file.

## Set up authentication and a database

1. Click on the **Project Overview**
2. **Develop** > **Authentication** > **Set up sign-in method**
3. click on the pencil icon next to the **Google** item
4. Select your Qwiklabs Google account for the "Project support email"
5. Click **Enable**.
6. Clcik **Save**

> **Check my progress**
>
> Set up authentication and a database

## Configure Firestore authentication and add sign-in to your web app

```bash
ls
cd pet-theory/lab02/
firebase deploy
```

## Add a customer page to your web app

```bash

cat > public/customer.js <<EOF
let user;

firebase.auth().onAuthStateChanged(function(newUser) {
  user = newUser;
  if (user) {
    const db = firebase.firestore();
    db.collection("customers").doc(user.email).onSnapshot(function(doc) {
      const cust = doc.data();
      if (cust) {
        document.getElementById('customerName').setAttribute('value', cust.name);
        document.getElementById('customerPhone').setAttribute('value', cust.phone);
      }
      document.getElementById('customerEmail').innerText = user.email;
    });
  }
});

document.getElementById('saveProfile').addEventListener('click', function(ev) {
  const db = firebase.firestore();
  var docRef = db.collection('customers').doc(user.email);
  docRef.set({
    name: document.getElementById('customerName').value,
    email: user.email,
    phone: document.getElementById('customerPhone').value,
  })
})
EOF

cat > public/styles.css <<EOF
body { background: #ECEFF1; color: rgba(0,0,0,0.87); font-family: Roboto, Helvetica, Arial, sans-serif; margin: 0; padding: 0; }
#message { background: white; max-width: 360px; margin: 100px auto 16px; padding: 32px 24px 16px; border-radius: 3px; }
#message h3 { color: #888; font-weight: normal; font-size: 16px; margin: 16px 0 12px; }
#message h2 { color: #ffa100; font-weight: bold; font-size: 16px; margin: 0 0 8px; }
#message h1 { font-size: 22px; font-weight: 300; color: rgba(0,0,0,0.6); margin: 0 0 16px;}
#message p { line-height: 140%; margin: 16px 0 24px; font-size: 14px; }
#message a { display: block; text-align: center; background: #039be5; text-transform: uppercase; text-decoration: none; color: white; padding: 16px; border-radius: 4px; }
#message, #message a { box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24); }
#load { color: rgba(0,0,0,0.4); text-align: center; font-size: 13px; }
@media (max-width: 600px) {
  body, #message { margin-top: 0; background: white; box-shadow: none; }
  body { border-top: 16px solid #ffa100; }
}
EOF

firebase deploy

```

Open the App URL

Login with Google Account

Fill in the form and submit an appointment
