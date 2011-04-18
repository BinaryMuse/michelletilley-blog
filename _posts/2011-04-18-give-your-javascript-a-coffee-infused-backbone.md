---
layout: post
title: Give Your JavaScript a Coffee-Infused Backbone
date: 2011-04-18 07:55:00
description: Learn how to utilize CoffeeScript and Backbone.js to clean up your JavaScript spaghetti.
---

Recently I was working on a little [demo web app](https://github.com/BinaryMuse/wow-realm-status-js) that involved completely client-side code. My JavaScript-fu isn't the greatest; in fact, you might say that I know jQuery, not JavaScript (and even that's pushing it). I've done a bit of Node.js recently, but other than that, I'm pretty wet behind the JavaScript ears.

Anyway, the first time through the code, I ended up with what was essentially [a bunch of jQuery statements](https://github.com/BinaryMuse/wow-realm-status-js/blob/f34e70dbace182df4b3cc83fd2f9d663e3031123/js/app.js#files) strewn about. It worked, but it wasn't really very pretty. I decided that it was time that I learn how to do something about it. I ended up with two neat tools: **CoffeeScript** and **Backbone**.

CoffeeScript
============

[CoffeeScript](http://jashkenas.github.com/coffee-script/) is "a little language that compiles into JavaScript." It offers a syntax reminiscent of Ruby and a few other niceties that make writing JavaScript a lot easier and more fun (in my opinion).

I bring it up in this post because code samples later will utilize it. For the basics, check out [the overview](http://jashkenas.github.com/coffee-script/#overview)--it should be plenty to allow you to grok the code in this post.

Backbone
========

[Backbone.js](http://documentcloud.github.com/backbone/) is the library that really helped bring shape to my code. It provides models, collections, views, routing and more. Your views respond to events in your models or collections to get stuff done. It even has "magic support" for jQuery, so you don't have to write UI code without it.

While Backbone is a JavaScript application framework, it doesn't include a widget library and other frills like several others. If you want to roll your own JavaScript but struggle to keep it in check, it might be what you need.

My App
------

My application was a [World of Warcraft server status page](http://binarymuse.net/misc/wow-realm-status-js/) designed to demonstrate some new API's that Blizzard is providing. I wanted it to be able to show the current status of every server (fetched via JSONP and refreshed every five minutes) and I wanted the list to be searchable with an input box on the page. Let's take a look at the various pieces of the app.

Realm Model
-----------

First, I created a model for a single server (aka "realm"). This model holds the name of the realm, its type, current population, whether or not the server is running, and whether or not there is a queue to play on the server. (Although it's not necessary to set defaults, as all poperties are set automatically from JSON later, I did so here.)

{% gist 924755 realm_model.coffee %}

RealmList Collection
--------------------

Next up, I created a collection to hold a list of models. It's through this object that I fetch new data from the JSONP endpoint and update the models accordingly.

{% gist 924755 realmlist_model.coffee %}

I struggled with this for a little while, as Backbone is really designed to help where CRUD and REST are in heavy use. For example, a call to `RealmList.fetch()` replaces all the models it holds with new models rather than updating the old models. This wasn't exactly what I wanted, and since I had to update the entire list of realms via JSONP every time, I did a bit of hackery to overide the collection's `refresh` function *after* the initial download.

The other thing to note here is the `_.bindAll` method. This is an [Underscore.js](http://documentcloud.github.com/underscore/) method (Backbone depends on Underscore) that ensures that anytime any of the named methods are invoked, they are called in the context of the current object (so `this` always refers to the object where the method lives).

Realm View
----------

Next up is the view for a single realm; that is, one instance of a server in the list.

{% gist 924755 realm_view.coffee %}

Notice the call to `_.template` when defining the view's template. This is another Underscore method; it compiles JavaScript templates into functions that can be used later for rendering by passing in a context object to fill in values. Here, I created a hidden `div` on the page, and read that HTML in to the template. In a larger app, I would probably use [Milk](https://github.com/pvande/Milk) for rendering templates.

Also, it's easy to miss the magic here; it's really only one line:

    this.model.bind 'change', this.render

This line of code binds its model's `change` event to the view's `render` element; the end result is that the view will automatically re-render itself any time its model's data changes.

Application View
----------------

Finally we get to the view for the application; while it's a bit longer than the other objects, it's actually relatively simple, mostly taking responsibility for binding various UI changes to events from the realm list.

{% gist 924755 app_view.coffee %}

It's also primary responsible for handling the search functionality for the app, iterating over the list of realms and checking to see if the name starts with the serch string, and hiding or showing the views accordingly. It does this when it receives the `filter:change` event fired from `RealmList.filter`. But how does that method know when to fire that event? The answer comes from our last object, the controller.

Controller
----------

The controller is analagous to the router in a traditional Rails app; it handles changes in the hash string. Here's our controller:

{% gist 924755 controller.coffee %}

The controller simply takes any hash string and passes it on to the realm list, which then fires the necessary event so that the view does the filtering.

In Conclusion
=============

I hope this post has given you a glimpse into the power of Backbone (and the syntax of CoffeeScript). There's a bit more code I didn't go over (and parts of the code that I did show that I glossed over). Please feel free to take a look at the [complete CoffeeScript source](https://github.com/BinaryMuse/wow-realm-status-js/blob/gh-pages/js/app.coffee#files) for the app; you can also find a [snapshot of the code](https://github.com/BinaryMuse/wow-realm-status-js/blob/d05a70e3222700d28d8a5ff597b56859cc08428c/js/app.coffee) from the time I wrote this post, and you can check out the [entire project's source](https://github.com/BinaryMuse/wow-realm-status-js) if you're interested). Don't hesitate to comment here or shoot me an email if you have any questions.

It's becoming incresingly apparent that JavaScript and other client-side technologies are where the real power is in modern web apps; be sure you leverage the tools necessary to keep your JavaScript just as clean and decoupled as your server-side code!
