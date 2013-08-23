---
layout: post
title: "Meteor &amp; Handlebars Template Helpers"
date: 2013-08-22 18:34
comments:
published: true 
categories: Meteor Handlebars
---
OK - I don't know if it was the Octopress theme I chose or what, but it was driving me crazy to be show Meteor Handlebars code snippets.

Finally I found the solution at [How to escape { in markdown on Octopress?](http://stackoverflow.com/questions/15786144/how-to-escape-in-markdown-on-octopress). 

On to template helpers...

Let's say you only want to show a table of steps per day if you have logged any steps. In Meteor to do handlebars conditionals you use template helpers.

First create the template helper:

* Line 1: `steps` references the name of the template; `hasSteps` is the helper.


``` js
Template.steps.hasSteps = function(options) {
  return ActivitiesSteps.find().count() > 0;
};

```

Then in the template put the conditional as in line 2 below:

{% raw %}
``` html

<template name="steps">		
	{{#if hasSteps}}
		{{>activitiesStepsTable}}
	{{/if}}
</template>

```
{% endraw %}






