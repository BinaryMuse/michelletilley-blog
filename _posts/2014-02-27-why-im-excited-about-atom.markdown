---
layout: post
title: Why I'm Excited about Atom
description: I'm excited about GitHub's new text editor. Maybe you will be too.
---

If you haven't heard, the fine folks at GitHub released [a text editor called Atom](http://atom.io/) into beta yesterday. As with any new tool or technology, reactions were mixed. I've been using Atom for about two months now, since the private alpha, and I'd like to tell you why I'm excited about this little editor.

![Atom Screenshot](/images/atom_screenshot.png)

Atom is [built on Chromium](http://blog.atom.io/2014/02/26/the-nucleus-of-atom.html); it is, essentially, a web application, running inside a dedicated browser. You might not even notice this fact at first glance---it runs like any other native app, has access to the file system, and does all the things you'd expect any other native app to do. But, under the hood, Atom leverages HTML, CSS, and JavaScript for its UI and leans on [Node.js](http://nodejs.org/) for system-level APIs.

This fact opens up lots of possibilities. Users can make simple customizations to their UI [with a few lines of CSS](http://discuss.atom.io/t/atom-is-so-powerful-that-it-blows-my-mind/294). If you're not sure what classes to override, just pop open the inspector and take a look.

![Atom Inspector](/images/atom_inspector_ss.png)

Since packages are also [written using HTML, CSS and JavaScript](https://github.com/atom/fuzzy-finder/), the barrier to creating packages is quite low compared with many other editors. Furthermore, the Node.js backing gives you the ability to use any of the [more than 60,000 Node packages on npm](https://www.npmjs.org/), as well as any of Node's built-in APIs. Want to start a web server from your package? [No problem](http://nodejs.org/api/http.html). Launch some external processes? [Can do](http://nodejs.org/api/child_process.html).

Really, since it's all Chromium under the hood, the sky is the limit. Imagine the cool code visualization tools you could build using Canvas or WebGL. [D3](http://d3js.org/) and [Three.js](http://threejs.org/) in my editor? Yes, please!

Plus, what editor lets you do this with two lines of code? :)

![Oops!](/images/atom_flipped.png)

In short, I feel Atom takes the Emacs mode of thinking---that your editor should be just as malleable as the code you write with it---and presents it in a fresh, modern way, ready to take on the web-based world. Give it a shot if you haven't already; sign up for a beta invite [over at atom.io](http://atom.io/).
