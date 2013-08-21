---
layout: post
title: "Meteor &amp; Fitbit API - Part Two"
date: 2013-08-20 20:51
comments: true
published: true
categories: Meteor Fitbit JavaScript API Meteorite
---
This is the second part of a two-part series walking thru the steps I took to create the Fitbit oAuth &amp; Meteor Account package and the Meteor-Fitbit-API Wrapper package. 

Part one is [here](http://wbartley.github.io/blog/2013/08/19/meteor-and-fitbit-api/). To run the example in [Step 3](#step3) below you need to have a Fitbit account, create a Fitbit app and install Meteorite.

<!-- more -->

## Step 1: Meteor Fitbit API
Having the ability to log in via Fitbit is great, but what about getting activity data from Fitbit? To do that I modified the [Meteor's Twitter API](https://github.com/Sewdn/meteor-twitter-api) package.

The end result is the [Meteor Fitbit API Package](https://github.com/wbartley/meteor-fitbit-api).

There were a couple of critical adjustments that need to be made to the package.js file:
 
* Line 5 is necessary because Fitbit relies on oAuth1
* Line 7 is necessary to work with Meteor 0.6.5 

```js package.js https://github.com/wbartley/meteor-fitbit-api/blob/master/package.js 

...

Package.on_use(function (api, where) {
	
	api.use('oauth1', ['client', 'server']);
 	api.add_files(['lib/fitbit.js'], 'server');
 	api.export && api.export('Fitbit', 'server');
});

...
```
 
Within lib/fitbit.js I added a couple of endpoints for testing:

* Line 3 userProfile is to get the user profile
* Line 7 getSteps is to get the last 7 days of steps

```js fitbit.js https://github.com/wbartley/meteor-fitbit-api/blob/master/lib/fitbit.js

...

Fitbit.prototype.userProfile = function() {
  return this.get('user/-/profile.json');
};

Fitbit.prototype.getSteps = function() {
 	return this.get('user/-/activities/steps/date/today/7d.json');
};

```
## <a name="step3"></a>Step 3: Meteorite and Atmosphere
As in part one of this series, by following the directions [Building a smart package?](https://atmosphere.meteor.com/wtf/package) I created a smart.json file.

To publish you run the command

	$ mrt release [path]

## Step 4: Go for a Spin

To test it out:
	$ git clone https://github.com/wbartley/fitbit_test.git
	$ cd fitbit_test
	$ meteor add bootstrap
	$ meteor add accounts-ui
	$ mrt add accounts-fitbit
	$ mrt add fitbit-api

Prior to starting meteor, open server/config.js and insert your service and consumerKey:

```js config.js https://github.com/wbartley/fitbit_test/server/config.js

Accounts.loginServiceConfiguration.insert({
  service: "fitbit",
  consumerKey: "your key",
  secret: "your secret"
});

```

Start meteor, open http://localhost:3000/ and follow these steps:

1. Click "Sign in with Fitbit".
2. If necessary enter your Fitbit account Email and Password and click "Allow".
3. You should see your Fitbit login name, your full name, avatar picture (assuming you have one) and a "Sign Out" button.
4. Click "Get Steps".

You should see a table with the last seven days of Fitbit step activities.


## Next...

Now the fun begins. Explore the [Discover the Fitbit API](https://wiki.fitbit.com/display/API/API+Explorer)  tool provided by Apigee (@apigee) and add some additional endpoints or follow this approach to port additional API packages and add them to [Atmosphere](https://atmosphere.meteor.com/wtf/app). 



