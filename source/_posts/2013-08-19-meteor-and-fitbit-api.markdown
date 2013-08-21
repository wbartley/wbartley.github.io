---
layout: post
title: "Meteor &amp; Fitbit API - Part One"
date: 2013-08-19 20:51
comments: true
published: true
categories: Meteor Fitbit JavaScript API Meteorite
---
After taking [Meteor](http://www.meteor.com/) for a spin **(AWESOME)** and having just recently bought a Fitbit Flex I wanted a way to get my Fitbit data into Meteor apps.

In this two-part series I'll walk thru the steps I took to create the Fitbit oAuth &amp; Meteor Account package and then the Meteor-Fitbit-API Wrapper package. I'll also show how to use [Meteorite](http://oortcloud.github.io/meteorite/) to add and install smart packages from [Atmosphere](https://atmosphere.meteor.com/wtf/app). The hope is that others follow this approach and port additional API packages. 

<!-- more -->

## Step 1: Fitbit oAuth
Sign up for an account and create an app at Fitbit. The callback URL needs to be:

	[your site url]/_oauth/fitbit?close 

It is ok to use localhost for your dev environment. For meteor apps the default port is 3000:

	https://localhost:3000/_oauth/fitbit?close


Here's the [Fibit API documentation](https://wiki.fitbit.com/display/API/Fitbit+API) for reference. Fitbit offers a [Discover the Fitbit API](https://wiki.fitbit.com/display/API/API+Explorer) tool provided by Apigee (@apigee) that was a ton of help.

## Step 2: Meteor Accounts & oAuth
Meteor allows developers to quickly add log in functionality via Twitter, Github, etc. by running the commands:


	$ meteor add accounts-twitter
	$ meteor add accounts-github

so I decided that was the only way to go.

Because Fitbit uses oAuth1 I modified the [Meteor Twitter Auth](https://github.com/meteor/meteor/tree/master/packages/accounts-twitter) and [Meteor Twitter](https://github.com/meteor/meteor/tree/master/packages/twitter) packages. The end results are the [Fitbit OAuth for Meteor](https://github.com/wbartley/accounts-fitbit) and [Fitbit](https://github.com/wbartley/fitbit) packages. 

A few code snippets to note from the fitbit/fitbit_server.js file:

* Lines 2 - 5 are required URLs for request/access tokens and to authorize/authenticate.
* Line 11 is the endpoint for getting profile data.
* Lines 15 - 16 and 24 - 25 are changes to the original code to load the entire Fitbit user profile on account creation. I didn't have to do that, but I wanted to load my avatar picture and other details.

``` javascript fitbit_server.js https://github.com/wbartley/fitbit/blob/master/fitbit_server.js fitbit_server.js

urls = {
	requestToken: "https://api.fitbit.com/oauth/request_token",
	authorize: "https://www.fitbit.com/oauth/authorize",
	accessToken: "https://api.fitbit.com/oauth/access_token",
	authenticate: "https://www.fitbit.com/oauth/authenticate"
};

...

Oauth.registerService('fitbit', 1, urls, function(oauthBinding) {
  var identity = oauthBinding.get('https://api.fitbit.com/1/user/-/profile.json').data;

...

	var profile = identity.user; //add all fitbit profile data
	profile["name"] = identity.user.displayName; //add name to see in default login buttons

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


It was also important to update the fitbit/fitbit_configure.html file with the information from Step 1 above:


``` html fitbit_configure.html https://github.com/wbartley/fitbit/blob/master/fitbit_configure.html fitbit_configure.html
<template name="configureLoginServiceDialogForFitbit">
  <p>
    First, you&#39;ll need to get a Fitbit Consumer Key. Follow these steps:
  </p>
  <ol>
    <li>
      Visit <a href="https://dev.fitbit.com/apps/new" target="blank">https://dev.fitbit.com/apps/new</a>
    </li>
    <li>
      Set Main URL to to: <span class="url">{{siteUrl}}</span>
    </li>
    <li>
      Set Callback URL to: <span class="url">{{siteUrl}}_oauth/fitbit?close</span>
    </li>
  </ol>
</template>

```

## Step 3: Meteorite and Atmosphere
To add and install smart packages from [Atmosphere](https://atmosphere.meteor.com/wtf/app) I needed to install  [Meteorite](http://oortcloud.github.io/meteorite/).

A critical piece was making sure that the Meteor and Meteorite smart packages were setup correctly. Meteor uses packages.js and Meteorite uses smart.json.

For me the [path] was the current package directory.
 
Note: each time you publish you need to increment the smart.json version, add/commit to your git repo and then run the mrt release command.


## Step 4: Go for a Spin

To test it out create a meteor app and add the packages. For example:

	$ meteor create fitbit_test 
	$ cd fitbit_test
	$ meteor add accounts-ui
	$ mtr add accounts-fitbit

Then open fitbit_test.html and replace **\{\{> hello}}** with **\{\{loginButtons}}** .

Start Meteor and open [http://localhost:3000](http://localhost:3000):

	$ meteor  

Finally follow these steps:

1. Click "Configure Fitbit Login". Fill in the consumer_key and consumer_secret details from when you created your Fitbit app in Step 1.
2. Click "Save Configuration".
3. Click "Sign in with Fitbit".
4. Enter your Fitbit account Email and Password and click "Allow".

If you see your Fitbit login name and a "Sign Out" button - Success! If you want to see your avatar picture (assuming you have one) then add the following to fitbit_test.html:

```html
<img src="{{currentUser.profile.avatar}}" class="img-rounded" style="width:50px" />
```

with the **src="\{\{currentUser.profile.avatar}}"**.

You should then see your avatar picture.

## Next Steps...
Now that you can login in and create an account with Fitbit, the next step is to get your activity data from the Fitbit API. That will be covered in part two of this series.




