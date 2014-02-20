---
layout: post
title: Creating Chrome Extensions with React
description: "I recently built a Chrome extension using Facebook's React and a message bus. Let's take a look at the results."
---

If you're into client-side web development to any extent, you've probably heard of Facebook's [React](http://facebook.github.io/react/index.html) library (or maybe you've just been living under a rock). Recently, I was working on a Chrome extension, and decided to see how well React fit in to the development I was doing. (Spoiler alert: it fit in quite well.) This post is not meant to be a general overview of or a basic tutorial for React, but rather a brief description of some architecture decisions that worked well for me while building the app.

The Extension
=============

For reference, the extension I built with React is called [Fast Tab Switcher](https://github.com/BinaryMuse/chrome-fast-tab-switcher), which I made for people who, like myself, don't seem to know how to close browser tabs, and subsequently can't find the one they're looking for. The extension allows users to hit a keystroke and pop open a window that shows all their currently open tabs; users can then filter the tabs with a text box, and press enter to switch to the currently selected entry. All the code is available [on GitHub](https://github.com/BinaryMuse/chrome-fast-tab-switcher), and the extension can also be installed from [the Chrome Web Store](https://chrome.google.com/webstore/detail/fast-tab-switcher/jkhfenkikopkkpboaipgllclaaehgpjf).

<div style='text-align: center;'>
<a href='/images/react_chrome_extension_demo.gif' target='_blank'>
<img src='/images/react_chrome_extension_demo.gif' style='max-width: 100%' alt='Screenshot'>
</a>
</div>

I chose to use [Browserify](http://browserify.org/) (and [Reactify](https://github.com/andreypopp/reactify), for the JSX transformation) to build this application, which allows us to build code using Node.js style `require`s and `module.exports`...s. It's not required for building this kind of app, but having access to Node packages and tooling is a nice win. Check out [the build scripts](https://github.com/BinaryMuse/chrome-fast-tab-switcher/tree/master/scripts) I used to build the Browserified bundles (`build.sh` builds one time then exits, `watch.sh` watches for changes in the sources files and compiles continuously).

React's Big Idea
================

If you're not familiar with React, it's a JavaScript library for creating UIs based on reactive data flow. The basic idea is to create components that contain idempotent rendering functions that always represent the UI for that component at any given time. When there's a state change in your component, React calls your rendering function again and builds an in-memory representation of your UI, and compares this to the last in-memory representation to figure out what pieces of the actual DOM should be updated.

I'm _seriously_ glossing over details here, so be sure to check out the [React web site](http://facebook.github.io/react/index.html) and some of their awesome [videos](http://facebook.github.io/react/docs/videos.html) to learn more. Of particular note is "Rethinking Best Practices" from JSConf.Asia 2013.

<iframe width="853" height="480" src="//www.youtube.com/embed/DgVS-zXgMTk?rel=0" frameborder="0" allowfullscreen></iframe>

If this whole thing sounds like a terrible idea to you, I urge you to give it a shot anyway---the proof of the pudding is, as they say, in the eating. I unfortunately (and [somewhat ironically](/2012/01/08/programmer-criticism.html)) dismissed it pretty quickly when I first heard about it, but now I wish I had given it a closer look sooner.

JSX
---

One of React's more unique features is called JSX---it is, quite simply, an XML-like syntax that React transforms into JavaScript.

{% gist 7dc242ebd829c8ac0020 jsx.jsx %}

The idea is to be able to express your views with something that looks like HTML instead of a bunch of JavaScript function calls. A lot of people seem to dislike JSX; I've grown rather fond of it. That said, it's completely optional; while I use it in the extension, it's one of the least important pieces of React, and you shouldn't let it trip you up.

Learning React
--------------

From this point on, I'll be assuming you know at least a little about how to use React; in particular, it'll be helpful to understand the basics of a component's lifecycle and to understand how state and properties work. If you get totally lost reading this post, or want to brush up on React before we begin, check out the resources above and [the React tutorial](http://facebook.github.io/react/docs/tutorial.html) and then come back. We'll be waiting.

Anatomy of an Extension
=======================

Just kidding, we're not really waiting on them. They'll catch up.

Chrome allows extensions to run code in a couple different contexts; one, called a [background page](http://developer.chrome.com/extensions/background_pages.html) (or an [event page](http://developer.chrome.com/extensions/event_pages.html), depending on how you use it), allows you to run code in the background. Most often, this can simply be a script, instead of a full on HTML document. The source for ours is in `src/js/background.js`.

The event page in our extension is basically responsible for two things: opening the tab switcher when the user presses the extension's keyboard shortcut, and responding to messages sent from the client (one for querying the list of currently open tabs and one for asking the extension to switch to a given tab). Since we're focusing on React in this post, we'll gloss over the details; check out [the source](https://github.com/BinaryMuse/chrome-fast-tab-switcher/blob/master/src/js/background.js) if you're curious!

The Client
==========

`build/html/switcher.html` is the HTML document that serves as the front-end for our extension. It contains nothing but some styles, a few `script` tags to load some vendored libraries and our app, and a single empty `div` element with an ID.

{% gist 7dc242ebd829c8ac0020 switcher.html %}

When the page loads, it runs our Browserified client bundle, the entry point of which is `src/js/client.jsx`. It's quite simple:

{% gist 7dc242ebd829c8ac0020 client.jsx %}

All of our React components are exported via `module.exports` so we can require them for use in any parent components. Here, we're simply asking React to render a top-level `TabSwitcher` component, attaching it to our `div`.

The TabSwitcher
---------------

This is where it really gets interesting. Here's what the `TabSwitcher` component looks like. I've left out a lot of the internals so we can focus on a high-level overview; [see the full source on GitHub](https://github.com/BinaryMuse/chrome-fast-tab-switcher/blob/master/src/js/client/tab_switcher.jsx).

{% gist 7dc242ebd829c8ac0020 tab_switcher_highlevel.jsx %}

When the component boots, it runs `getInitialState` to---you guessed it!---get its initial state. We can then refer to this state throughout the component via `this.state` and modify it via `this.setState`. `componentDidMount` runs after the component is mounted to the DOM; the last line of this method, `refreshTabs()`, fills in pieces of the state with data from the server---er, from the extension's event page---by making an asynchronous request and then calling `setState` with the results. This method is called any time we get an event that indicates that we should update the list of tabs---more on that soon.

{% gist 7dc242ebd829c8ac0020 tab_switcher_setstate.jsx %}

> Note: For all practical purposes, the phrases "data from the server" and "data from the extension's even page" are interchangeable. We're communicating with an extension via a special Chrome API, but the design would be sound if we were communicating over HTTP, websockets, etc.

An important consideration in this design is that `TabSwitcher` is the **only** component in the hierarchy that contains any mutable state or any `this.setState` calls. Similarly, it contains no logic on how to render the UI; it delegates to a few sub-components for that.

The data each sub-component needs to display itself is passed through their properties---specifically, the `filter`, `tabs`, `selectedTab`, and `searchAllWindows` properties.

{% gist 7dc242ebd829c8ac0020 tab_switcher_render.jsx %}

These properties are immutable; if a child component needs to change the application's state due to the user's interaction, it uses the `bus` (which is simply a Node.js [EventEmitter](http://nodejs.org/api/events.html#events_class_events_eventemitter), made available to us on the client side by Browserify) to notify the `TabSwitcher` that something happened. The `TabSwitcher` modifies the appropriate state and then React *re-renders the entire component tree in memory*, using intelligent diffing to only modify the browser's DOM in places that actually need changing.

<a href='/images/react_chrome_extension_diagram.png' target='_blank'>
<img src='/images/react_chrome_extension_diagram.png' style='max-width: 100%' alt='Data Flow'>
</a>

<small>*Data only flows from top to bottom; only `TabSwitcher` contains any mutable state*</small>

> One thing that I've left out here: if there was any chance that our components would be mounted and unmounted during the application's lifecycle, we would need to [deregister any event bus listeners](http://nodejs.org/api/events.html#events_emitter_removelistener_event_listener) for that component during its `componentWillUnmount` lifecycle hook. I've not done that here, as the same components are always mounted, but it's something to be aware of if you use this pattern in your own apps.

### Let's Take a Closer Look

Let's look at the data flow a bit more closely. As an example, let's look at what happens when the user types something in the input box, indicating their desire to filter the list of tabs to ones that match their query.

First, in [the `TabSearchBox` component](https://github.com/BinaryMuse/chrome-fast-tab-switcher/blob/master/src/js/client/tab_search_box.jsx), we have an `onChange` event listener that fires when the user changes the text.

{% gist 7dc242ebd829c8ac0020 tab_search_box_eventflow.jsx %}

The change handler calls `bus.emit('change:filter')`, passing in the new string value. It very specifically *doesn't* directly modify any state, neither in its own component nor in some centralized model.

Next, the `change:filter` event handler for the bus in `TabSwitcher` fires, calling the component's `changeFilter` method.

{% gist 7dc242ebd829c8ac0020 tab_switcher_eventflow.jsx %}

*This* is where the state change happens; we set the filter to the string that was sent to us via the event, and once that's set we get the newly filtered tabs and set the currently selected tab to the first one in that list.

Changes made to the state via `setState` trigger an in-memory "render" of the component tree by React, and the new values in the state automatically flow into the child components via their properties. If React detects the actual browser DOM is out of sync with this in-memory model, it then and *only* then performs the relatively slow DOM manipulation operations necessary to bring it up to date.

If you're used to a framework with built-in two-way data binding, it can take a while to migrate your mindset to this style of decoupled components. The effort can be worth it, though; these two ideas---allowing the UI state of your application to be defined as a tree of idempotent functions that rely on variables they own, and centralizing state changes to once place, communicating with messages---makes it *extremely* easy to reason about your components. In fact, if you look at the other components in the extension, you'll notice they're very short, and do very little; the most complex logic you'll see is determining how to format a particular string, or which event to fire based on which key the user pressed.

Conclusion
==========

Of course, this isn't the only way to build a React app. The React team recommends passing callbacks to child components via properties. I've always been partial to evented systems, and this strategy seemed to work well in this case. Each component is quite cohesive, yet highly decoupled---with access to the event bus and their properties, they'll still work even if their position in the component tree changes.

Have you built anything using React? What patterns did you use? Share it with us in the comments!
