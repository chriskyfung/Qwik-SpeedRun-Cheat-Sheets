# GSP486 Google Assistant: Build a Restaurant Locator with the Places API

_last update_: 2021-02-10

**Tasks**:

1. Create a Dialogflow Agent traverse from Action Project
1. Configure the Default Welcome
1. Build the Custom Intent (name: get_restaurant)
1. Initialize and Configure a Cloud Function

**Prep**:
📹 Watch Demo on YouTube 👉 https://youtu.be/CjNwkE6Wisk

## Create an Actions project

1. Open http://console.actions.google.com/
2. Click **New Project**
3. Click **Import project**

## Build an Action

1. **Build your action** > **Add Action(s)** > **Get Started**. Then select **Custom Intent**
2. Click **BUILD**

3. Click **CREATE** to Create Agent

> Create a Dialogflow Agent traverse from Action Project

## Build the Default Welcome Intent

1. Open **Default Welcome Intent**
2. Click 🚮 under **Responses**
3. click on **ADD RESPONSES** > **Text response**

    _`Hello there and welcome to Restaurant Locator! What is your location?`_

4. Click **Save** in the top-right corner.

> Configure the Default Welcome Intent

Enter the dummy URL `https://google.com` to **Fulfillment**

## Build the Custom Intent

1. Click on the ➕ icon by the **Indents**
2. Enter `get_restaurant` as the **Indent name**
3. Click **Add Training Phrases**

    `345 Spear Street`
    `1600 Amphitheatre Parkway, Mountain View`
    `20 W 34th St, New York, NY 10001`
    
    and assign them the `@sys.location` entity
4. Expand the **Actions and parameters**

    ☑ REQUIRED for `@sys.location`
5. Click **Define prompts** and enter
    `What is your address?`

6. **+ New Parameter**
    ☑ REQUIRED
    `proximity`
    `@sys.unit-length`
    `$proximity`
    `How far are you willing to travel?`

6. **+ New Parameter**
    ☑ REQUIRED
    `cuisine`
    `@sys.any`
    `$cuisine`
    `What type of food or cuisine are you looking for?`

7. **Enable Fulfillment**

    Click ➕ and select `Google Assistant` tab

    ✅ **Set this intent as end of conversation**

8. Click **Save**

> Build the Custom Intent (name: get_restaurant)

## Enable APIs and retrieve an API key

1. Enable the following API services
    - Places API
    - Maps JavaScript API
    - Geocoding API

2. Navigate to **APIs & Services** > **Credentials**
3. Create an **API Key**

## Initialize a Cloud Function

- Function name
    `restaurant_locator`
- Trigger
    **HTTP**
- Authentication
    ☑ Allow unauthenticated invocations
- index.js
    ```js
    'use strict';

    const {
    dialogflow,
    Image,
    Suggestions
    } = require('actions-on-google');

    const functions = require('firebase-functions');
    const app = dialogflow({debug: true});

    function getMeters(i) {
        return i*1609.344;
    }

    app.intent('get_restaurant', (conv, {location, proximity, cuisine}) => {
        const axios = require('axios');
        var api_key = "<YOUR_API_KEY_HERE>";
        var user_location = JSON.stringify(location["street-address"]);
        var user_proximity;
        if (proximity.unit == "mi") {
            user_proximity = JSON.stringify(getMeters(proximity.amount));
        } else {
            user_proximity = JSON.stringify(proximity.amount * 1000);
        }
        var geo_code = "https://maps.googleapis.com/maps/api/geocode/json?address=" + encodeURIComponent(user_location) + "&region=us&key=" + api_key;
        return axios.get(geo_code)
            .then(response => {
            var places_information = response.data.results[0].geometry.location;
            var place_latitude = JSON.stringify(places_information.lat);
            var place_longitude = JSON.stringify(places_information.lng);
            var coordinates = [place_latitude, place_longitude];
            return coordinates;
        }).then(coordinates => {
            var lat = coordinates[0];
            var long = coordinates[1];
            var place_search = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=" + encodeURIComponent(cuisine) +"&inputtype=textquery&fields=photos,formatted_address,name,opening_hours,rating&locationbias=circle:" + user_proximity + "@" + lat + "," + long + "&key=" + api_key;
            return axios.get(place_search)
            .then(response => {
                var photo_reference = response.data.candidates[0].photos[0].photo_reference;
                var address = JSON.stringify(response.data.candidates[0].formatted_address);
                var name = JSON.stringify(response.data.candidates[0].name);
                var photo_request = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=' + photo_reference + '&key=' + api_key;
                conv.ask(`Fetching your request...`);
                conv.ask(new Image({
                    url: photo_request,
                    alt: 'Restaurant photo',
                }))
                conv.close(`Okay, the restaurant name is ` + name + ` and the address is ` + address + `. The following photo uploaded from a Google Places user might whet your appetite!`);
            })
        })
    });

    exports.get_restaurant = functions.https.onRequest(app);

    ```

    Replace **<YOUR_API_KEY_HERE>** (line 18) with the API key

    Replace <YOUR_REGION> (line 26) with `us`
- package.json
    ```json
    {
        "name": "get_reviews",
        "description": "Get restaurant reviews.",
        "version": "0.0.1",
        "author": "Google Inc.",
        "engines": {
            "node": "8"
        },
        "dependencies": {
            "actions-on-google": "^2.0.0",
            "firebase-admin": "^4.2.1",
            "firebase-functions": "1.0.0",
            "axios": "0.16.2"
        }
    }

    ```
- Entry point
    `get_restaurant`

Click **Deploy**

**Copy** the function URL

> Initialize and Configure a Cloud Function

## Configure the webhook

Return to the Dialogflow console and click on the **Fulfillment** menu item

## Change your Google permission settings

visit the [Activity Controls page](https://myaccount.google.com/activitycontrols)

    ✅ Web & App Activit