# GSP499 User Authentication: Identity-Aware Proxy

_last modified: 2020-08-10_

### Download the Code

```bash
git clone https://github.com/googlecodelabs/user-authentication-with-iap.git

cd user-authentication-with-iap
cd 1-HelloWorld

gcloud app deploy
```

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

7. Click **Save**.

> **Check my progress**
> Restrict Access with IAP

8. Return to the Identity-Aware Proxy page and **refresh** it
9. Toggle the IAP button in the App Engine app row.
10. Click **TURN ON**.
