# GSP499 User Authentication: Identity-Aware Proxy

_last modified: 2021-09-18_
_last verified: 2020-09-05_

### Download the Code

```bash
git clone https://github.com/googlecodelabs/user-authentication-with-iap.git

cd user-authentication-with-iap
cd 1-HelloWorld

gcloud app deploy
```

Choose `us-central`.

### Deploy to App Engine

> **Check my progress**
> Deploy an App Engine application

### Restrict Access with IAP

1. Navigation menu > **Security** > **Identity-Aware Proxy**.
2. Click **Enable API**.
3. Click **Go to Identity-Aware Proxy**.
4. Click **CONFIGURE CONSENT SCREEN**.
5. Select **Internal** under *User Type* and click **Create**.

   | Field       | Value             |
   | ---         | ---               |
   | Application name | `IAP Example`|
   | Support email |                 |
   | Authorized domain | *Do not include the starting https:// or trailing / from that URL.* |
   | Application homepage link | *The URL you used to view your app* |
   | Application privacy Policy link | /privacy |

6. Click **Save**.

   > **Check my progress**
   > Restrict Access with IAP

7. Return to the Identity-Aware Proxy page and **refresh** it
8. Toggle the IAP button in the App Engine app row.
9. Click **TURN ON**.

## Test that IAP is turned on

1. check on **App Engine app**

2. In the sidebar of App Engine app, click **ADD PRICIPAL**.

3. Add the username as **New principals**.

4. Select **Cloud IAP** > **IAP-Secured Web App User** in the **Role** dropdown.

Click **Save**

> **Check my progress**
> Enable and add policy to IAP

```bash
cd ~/user-authentication-with-iap/2-HelloUser
gcloud app deploy
```

> **Check my progress**
> Access User Identity Information

```bash
cd ~/user-authentication-with-iap/3-HelloVerifiedUser
gcloud app deploy
```

> **Check my progress**
> Use Cryptographic Verification


