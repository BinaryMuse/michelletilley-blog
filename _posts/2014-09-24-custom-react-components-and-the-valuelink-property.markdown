---
layout: post
title: Writing React Components that Support the LinkedStateMixin and the valueLink Property
date: 2014-09-24 09:02:00
description: Learn how to create React components that support LinkedStateMixin's linkState() and the valueLink property.
---

In a React application, it's very common for a component to contain state that should be editable by a child component. The most basic example uses a text input with a `value` and `onChange` handler to display and update the text.

{% gist bd66e40b00598e1288f2 ex_01.js %}

Doing this over and over, especially in a component with a lot of [controlled inputs](http://facebook.github.io/react/docs/forms.html#controlled-components), can get repetitive. The React addons (available when you use the "React with Add-Ons" download, or via `require("react/addons")` when using a CommonJS bundler) provide the `LinkedStateMixin` to simplify situations where an input should remain in lockstep with a given piece of state.

{% gist bd66e40b00598e1288f2 ex_02.js %}

Now the input and the `text` state will remain synchronized; changing the state via `setState` will update the input, and changing the input will automatically call `setState`, updating the `text` key.

this.linkState() and ReactLink Objects
--------------------------------------

But what does `this.linkState(key)`, a function provided to our component by `LinkedStateMixin`, actually return? It's actually a very simple object created by React's `ReactLink` module:

{% gist bd66e40b00598e1288f2 ex_03.js %}

The `value` property contains the current value of `this.state[key]`, and the `requestChange` property is a function we can call with a new value for `this.state[key]` to update it.

That means our above example could more verbosely be written like this:

{% gist bd66e40b00598e1288f2 ex_04.js %}

Written this way, it's easy to see that the `valueLink` property is very straightforward: it simply uses the object's `value` property as the current value of the form and the object's `requestChange` property as the callback to change that value. We now have all the information we need to implement a `valueLink`-style property on any component we write.

Extrapolating to Custom Components
----------------------------------

Let's build a simple React component that wraps a [simple jQuery color picker](https://github.com/laktek/really-simple-color-picker). The component wraps a single div, and we utilize React component lifecycle hooks to call appropriate plugin methods when the incoming properties change.

{% gist bd66e40b00598e1288f2 ex_05.js %}

We can use the color picker by passing it `value` and `onChange` properties, like so:

{% gist bd66e40b00598e1288f2 ex_06.js %}

It would be nice if our component also supported use of the `LinkedStateMixin`. Let's change our application to use `valueLink`:

{% gist bd66e40b00598e1288f2 ex_07.js %}

Since we know that the `valueLink` property contains an object with `value` and `requestChange` properties, we can easily modify the ColorPicker component:

{% gist bd66e40b00598e1288f2 ex_08.js %}

However, we've lost the ability to use `value` and `onChange` with our component, since we've hard-coded it to use `this.props.valueLink` everywhere. We could litter the component with `if` statements checking for the existence of `this.props.valueLink`, but instead let's write a simple abstraction so we don't have to worry about it:

{% gist bd66e40b00598e1288f2 ex_09.js %}

This `getValueLink` function takes a properties object and either returns its `valueLink` property, if it has one, or creates one from the `value` and `onChange` properties. Now, we can write our component as if we always have a `valueLink` property:

{% gist bd66e40b00598e1288f2 ex_10.js %}

And that's it! We now have a React component that works both with and without `valueLink`. [Here's an example](http://jsfiddle.net/BinaryMuse/c3nheycp/):

<iframe width="100%" height="400" src="http://jsfiddle.net/BinaryMuse/c3nheycp/embedded/result,js,html" allowfullscreen="allowfullscreen" frameborder="0"></iframe>
