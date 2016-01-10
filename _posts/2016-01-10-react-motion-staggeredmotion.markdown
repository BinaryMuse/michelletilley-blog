---
layout: post
title: Using React Motion's StaggeredMotion for Staggered Animations
date: 2016-01-10 14:39:00
description: Learn how to achieve Nash Vail's excellent staggered animation effect using React Motion's StaggeredMotion component.
---

[Nash Vail](https://twitter.com/nashvail) recently released [an *awesome* tutorial on how to create a really cool menu animation](https://medium.com/@nashvail/a-gentle-introduction-to-react-motion-dc50dd9f2459) using React Motion. His final product is this:

![Nash Vail's Menu](/images/nash-vail-animation.gif)

I found it very useful for learning how to use [React Motion](https://github.com/chenglou/react-motion); you should definitely [check it out if you haven't](https://medium.com/@nashvail/a-gentle-introduction-to-react-motion-dc50dd9f2459).

Toward the end of the article, Nash changes the animation from being uniform to staggering each of the small white buttons so they animate at different times. He accomplishes this by storing individual components on the component's state:

> We’re close, but not there yet. What if we added delay each time before the next child button starts to animate? That’s exactly what we need to do, to achieve the final effect. Doing so wasn’t so straightforward though, I had to store each motion component as an array in a state variable. Then change the state one by one for each of the child button to achieve the desired effect

However, React Motion has a cool component called `StaggeredMotion`, which makes the interpolated value of each of a *list* of styles dependent on any of the other previous values. It was non-obvious to me how I could use this technique to make this demo work, because each button was moving in a different direction — I don't want them to follow each other, I want them to continue to move in their own direction.

Finally, it occurred to me that what I really wanted to control the interpolation for was "how finished" each buttons' animation was; for example, if the first button is about half done moving to its final position, then the second button should be about a quarter of the way, and so on. I made a few changes to the app to make this work.

First, I changed the function that calculates the final position of each button to take a second parameter called `percent` that would multiply the delta X and Y values by a certain amount.

{% gist 9431d5cecc3d57c4c317 index_01.js %}

So, if `percent` is 0, then the button won't move at all, and if `percent` is 1, then the button will fully move to its final destination.

Next, I removed `initialChildButtonStyles` and `finalChildButtonStyles` and replaced them with a method that could be used to calculate the style for a child button at any completion percentage:

{% gist 9431d5cecc3d57c4c317 index_02.js %}

Finally, I updated `render` to wire together this new method into the `StaggeredMotion` component. `StaggeredMotion` takes an *array* of styles, and its child function should take an *array* of current values.

{% gist 9431d5cecc3d57c4c317 index_03.js %}

The magic here happens in `nextStyles`, where the array of final styles is calculated. In English, it would read something like the following:

* The first item in the array is the "leader" element and all the other values are based off it. So, if we're working with the 0-indexed item, just return our final style.
* Each other item in the array is calculated by looking at the previous element (i.e. the button before it).
  * If the previous button has animated more than 30% of the way to completion, start our own animation by returning our goal value.
  * If the previous button has not yet animated more than 30% of the way to completion, just stay where we were last iteration.

Now that we can teach `StaggeredMotion` how to "animate" over our 0-to-100% value, we can use it to calculate the correct styles for each component based on the current completion percentage.

{% gist 9431d5cecc3d57c4c317 index_04.js %}

And that's that! The final effect looks like this (with none of the polish of Nash's version):

![Final Staggered Animation](/images/react-motion-stagger.gif)

And here's the complete code listing:

{% gist 9431d5cecc3d57c4c317 complete.js %}

Thanks so much to Nash Vail for his awesome tutorial that helped lead me to understand how all this works!
