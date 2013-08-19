---
layout: post
title: "Meteor &amp; Fitbit API"
date: 2013-08-16 20:51
comments: true
published: true
categories: meteor fitbit javascript api
---
After taking Meteor for a spin *AWESOME* and having just recently bought a Fitbit Flex thought it would be cool to figure out how to get my Fitbit data in a meteor app.

Here's how I did it in case you want to try to tie into another API.

Check out the example app at github.


## Fitbit oAuth
Created an app at Fitbit. The callback URL needs to be:

Reviewed the documentation. The API tool was invaluable.

## Meteor Accounts & Ouath
Meteor allows developers to quickly log in via Twitter, Github, etc. just by running the commands:

```bash
meteor add accounts-twitter
meteor add accounts-github
```
I decided that was the way to go.

To start I revamped the code based upon upon [Meteor's Twitter Auth package](https://github.com/meteor/meteor/tree/master/packages/accounts-twitter). 

Did this because Fitbit uses oAuth1.

within 

```javascript [fitbit_common.js] [url] [fitbit_common.js]

Fitbit._urls = {
	requestToken: "http://api.fitbit.com/oauth/request_token",
	authorize: "http://www.fitbit.com/oauth/authorize",
	accessToken: "http://api.fitbit.com/oauth/access_token",
	authenticate: "https://www.fitbit.com/oauth/authenticate"
};
```

Something I noticed was that key profile information wasn't being loaded into the account so I made a slight adjustment:

``` [language] [title] [url] [link text]

	var profile = identity.user; //add all fitbit profile data
	profile["name"] = identity.user.displayName; //"name"" required to see it in default login buttons

  // include helpful fields from Fitbit
  var fields = _.pick(identity, Fitbit.whitelistedFields);
  _.extend(serviceData, fields);

  return {
    serviceData: serviceData,
    options: {
    	profile: profile
	}
  };
});

```



## Meteor-Fitbit-API Wrapper
Once I was able to create an account via Fitbit oAuth I needed to get the data from the API.

For that I revamped the code based upon [Meteor's Twitter API Package](https://github.com/Sewdn/meteor-twitter-api).

Added the Fitbit API and add two endpoints:


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
## Published to Meteorite
