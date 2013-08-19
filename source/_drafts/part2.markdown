---
layout: post
title: "Meteor &amp; Fitbit API"
date: 2013-08-16 20:51
comments: true
published: false
categories: meteor fitbit javascript api
---
## Step 3: Meteor-Fitbit-API Wrapper
Once I was able to create an account via Fitbit oAuth I needed to get the data from the API.

For that I revamped the [Meteor's Twitter API](https://github.com/Sewdn/meteor-twitter-api) package.

I added the Fitbit API URL and two endpoints:


```javascript [title] [url] [link text]

Fitbit = function(options) {
  this._url = "http://api.fitbit.com";
  this._version = "1";
  if (options) _.extend(this, options);
};

...

Fitbit.prototype.userProfile = function() {
  return this.get('user/-/profile.json');
};

...

Fitbit.prototype.getSteps = function() {
	console.log("in getSteps prototype");
 	return this.get('user/-/activities/steps/date/today/7d.json');
};


```