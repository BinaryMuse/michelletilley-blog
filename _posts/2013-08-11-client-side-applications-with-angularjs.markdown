---
layout: post
title: Client-Side Applications with AngularJS
date: 2013-08-12 09:18:00
description: AngularJS is a client-side application framework that's growing in popularity. Let's take a look.
---

The [last time I wrote about client-side applications](/2011/04/18/give-your-javascript-a-coffee-infused-backbone.html), I demonstrated an application I had built using Backbone. Since then, I, like many others, have tried out many other libraries for building client-side applications with JavaScript. Recently, I've taken a strong liking to [AngularJS](http://angularjs.org/) by Google. Let's take a look at Angular by comparing the app I built last time with a version built using Angular.

The full source code for the application is [available on GitHub](https://github.com/BinaryMuse/wow-realm-status-angular), and the application is [running on GitHub pages](http://binarymuse.github.io/wow-realm-status-angular/). Just as in the Backbone example, this application is written in CoffeeScript.

AngularJS Basics
================

One of the core concepts in AngularJS is two-way data binding. This means that manipulating a variable controlled by Angular---for example, in a text box---will automatically update any other places that variable is bound. Here's a very basic example: a text box that updates a value in the DOM as you type.

<iframe width="100%" height="150" src="http://jsfiddle.net/BinaryMuse/HQ56V/embedded/html,result" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

AngularJS uses dirty-checking for data binding, meaning that you get to use plain ol' JavaScript objects---POJSO's, if you will---as your models. It also supports a robust dependency injection system, which aids in testing, and allows for the registration various application components, including controllers, services, and filters.

A full exploration of the Angular framework is beyond the scope of this post, so we'll stick to the features I used in rebuilding the app.

Services
------------

In Angular, services are where you put your business logic; you can liken them to models in a server-side MVC framework like Ruby on Rails, but are more generic. In our case, we've created two new services.

{% gist 6207991 services.coffee %}

`Realms`, which depends on [the built-in `$http` service](http://docs.angularjs.org/api/ng.$http) (Angular's built-in services begin with a dollar sign), simply defines a function that takes a callback, makes the JSONP request to the Blizzard API, and then calls the callback with the resulting data once complete. This replaces the `RealmList` collection from the Backbone app, and the `Realm` model from the Backbone app is replace with plain JavaScript objects from the API's JSON response.

`hashChange` simply watches for the URL's hash to change and calls a provided function with its new value whenever it does. The call to the function is wrapped in `$rootScope.$apply`, which ensures that the function runs within the context of Angular's dirty tracking. This is only necessary when dealing with asynchronous code that *isn't* managed by AngularJS by default---for example, when dealing with native browser events or third-party jQuery plugins. This will replace the routing features from the Backbone app (AngularJS has a full-featured router, but we don't use it for this app.)

Once registered, both services are available to other services and controllers in our application by name; we'll see this in a moment when we define our controller.

Controllers
----------------

Controllers are the glue between your views and your models. User events on the DOM will generally trigger functions on a controller, which will then in turn manipulate some model. The change in the model will automatically be propagated back into the view via Angular's two-way data binding.

I only defined one controller for this application; though the terminology is a little different, this will basically replace all three of the views we created in the Backbone application. The controller uses various dependencies, injected in at runtime, to manage the interaction between the user and the models. You can see the list of dependencies in the controller's function definition:

    app.controller 'RealmsController', ($scope, $timeout, $window, Realms, hashChange) ->

We defined `Realms` and `hashChange` ourselves in the previous section; the other three variables, which start with a dollar sign, are provided to us by the framework:

* `$scope` is an object that is shared between the controller and the view; any property attached to the scope is automatically available in the view. `$scope` is where we put all our models, so that they can be shown in the view. Every controller gets its own `$scope` variable.
* `$timeout` is a special version of JavaScript's `setTimeout` that ensures that Angular's dirty-checking is triggered in the asynchronous function, similar to the `$rootScope.$apply` trick we used in the `hashChange` callback.
* `$window` is a wrapper around the JavaScript `window` object, provided mostly for its ability to be easily mocked out in tests.

{% gist 6207991 controllers.coffee %}

The controller itself sets up four values on the `$scope` object:

* `realms` is an array of servers that we'll eventually get from the JSONP API, but for now we initialize it as an empty array.
* `search` is the current search term, initialized to an empty string.
* `lastUpdate` holds the `Date` for the last time we got fresh data from the API; here we initialize it to null.
* `updateHash` is a function that, when called, will take the current value of the `search` scope variable and make sure the current URL shows it in its hash. This is defined on the scope because we will be accessing it from the view later.

We then use our `hashChange` service to make sure that our `search` scope variable changes automatically when the URL's hash changes. Finally, we create a local function called `refresh` that fetches new data from the API and schedules another update in five minutes. The refresh function uses the `Realms` service to fetch the data and set all the relevant data in its callback.

We then kick everything off by calling `refresh` once manually.

Views
-------

In Angular, your views are described declaratively with HTML. This is perhaps the biggest difference between it and a framework like Backbone. The view not only lays out the template, but also declares the bindings between the HTML and the controller. Here's our full application view, defined in one file.

{% gist 6207991 view.html %}

Let's break this down piece by piece.

{% gist 6207991 view-body.html %}

Angular views are described using *directives*, which are usually manifested as special HTML attributes or elements. For example, the `ng-app` attribute on the `body` tag tells Angular to kick off the `wowRealmStatus` module on that section of the DOM; the `ng-controller` directive on the first `div` tag tells Angular to load up the `RealmsController` for that particular part of the page. Angular has [several useful built-in directives](http://docs.angularjs.org/api/); we'll cover only the ones that drive out the functionality of our application here.

{% gist 6207991 view-input.html %}

First, notice that our search `input` has an `ng-model` directive on it. This tells Angular to bind the value of the text input to the `search` property on the view's associated `$scope` (which, you may recall, is shared by the `RealmsController` we defined earlier). This means that every time the user types in the box, the `$scope.search` property in the controller is automatically updated; conversely, when `$scope.search` is updated in the controller, the value shown in the text box will automatically update.

There is also an `ng-change` attribute on the input; this tells Angular to call the given function every time the value in the input changes. In this case, it's calling our `updateHash` function to ensure the URL is correct.

The image shown next to the input has an `ng-show` attribute on it; this ensures that the image is only visible if the expression passed to the attribute is true. In this case, we only show the loading spinner if the `loading` scope value is truthy, which we manage in our `refresh` function.

{% gist 6207991 view-time.html %}

The paragraph containing the last updated time is interesting; it shows one of two spans depending on if the `lastUpdate` scope value is truthy or not; if it is, we use Angular's curly-brace-based string interpolation to show the date. The pipe `|` character invokes a filter, and it works just like pipes do on UNIX-like systems---the value `lastUpdate` is passed to a function called `date`; the string `'MMM d, h:mm a'` is passed as the second parameter to this function. In this case, we're using [the date filter](http://docs.angularjs.org/api/ng.filter:date), and it returns the given date formatted by the specified string. Filters allow you to keep all your formatting-related logic in the view, where it's easy to see what's happening and compose multiple filters together in interesting ways.

{% gist 6207991 view-reset.html %}

We then have a paragraph that is only shown if `search` is truthy (e.g., not an empty string). If it is, we see a link with the text "Show All" that uses the URL's hash fragment to reset the search term to empty (remember our `hashChange` callback).

{% gist 6207991 view-repeat.html %}

Finally, we get to the really interesting part. The final `div` tag has an attribute called `ng-repeat`. This causes the DOM element to be repeated for every element in an array or object. In this case, for every element in the `realms` scope property, we're duplicating the `div` and assigning a new local scope variable called `realm` to the array value at the current iteration. Inside the `div`, we're using curly-braces and filters (described in the next section) to show various pieces of information about each realm.

Additionally, the `ng-repeat` expression itself is being piped into a filter: the `filter` filter. In this case, we're passing as a second argument an object literal, that says to filter out from the `realms` array any value that has a `name` property that doesn't matche the current value of the `search` scope variable. In this way, we get search functionality for free!

Filters
----------

We mentioned filters briefly in the last section, when we said that filters are special functions you can invoke in your views via the pipe `|` operator, and that they look and behave much like you'd expect based on their behavior on UNIX-like systems. Here are the filters I defined for the app.

{% gist 6207991 filters.coffee %}

The comments on each filter describe what it does; notice that they only return new values, not manipulate existing data. Filters allow you to transform data in your view so that you don't have to worry about data formatting in your controllers or services, and make it easy to see how your data is transformed at a glance in your views.

In Conclusion
=============

As you can see, the code for the Angular version of this app is quite short. The functionality is nicely encapsulated, and Angular's data binding saves us a *lot* of boilerplate code that we'd normally have to write for view updates. You can check out [the code for this project on GitHub](https://github.com/BinaryMuse/wow-realm-status-angular), and the working implementation is [up on GitHub pages](http://binarymuse.github.io/wow-realm-status-angular/).

If you're interested in a more advanced example, take a look at [MovieKue](https://github.com/BinaryMuse/MovieKue), which behaves more like a traditional single-page application. It's still under development, but it's feature-complete enough to garner useful information about writing a larger AngularJS app. (It also uses [Firebase](https://www.firebase.com/), a cool real-time database-in-the-cloud, which I recommend checking out.)

Overall, this was a whirlwind tour of the AngularJS framework. Be sure to [check it out](http://angularjs.org/) if you're interested. I hope you found this example and comparison to the [Backbone version of the app](http://brandontilley.com/2011/04/18/give-your-javascript-a-coffee-infused-backbone.html) useful. Please let me know in the comments or [via email](http://brandontilley.com/contact.html) if you have any questions!
