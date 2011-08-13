---
layout: post
title: Socket.IO and the Latest Chrome
date: 2011-08-13 11:05:00
description: The latest version of Chrome gives Socket.IO some issues; find out why.
---

I spent some time this morning working on an issue, and when I discovered the problem, I thought I'd share my findings.

The issue is Socket.IO not working quite right on the latest Chrome build (definitely the latest dev build, and I've heard people are having issues with the latest stable build as well). Specifically, Socket.IO over WebSockets isn't working. I received the following error:

    warn  - websocket connection invalid

It turns out that this is because recent builds of Chrome [implement a newer version of the WebSocket protocol](http://googlechromereleases.blogspot.com/2011/07/chrome-dev-channel-release.html). Although the folks at Socket.IO are [working on a fix](https://github.com/LearnBoost/socket.io/issues/429), it's still not quite ready.

Interestingly enough, I didn't have this issue at work, where we're running the latest dev build of Chrome; instead, I discovered it while working on the same project at home, where I'm running dev Chrome on Ubuntu, so YMMV.

In the meantime, for development purposes, I've simply set Socket.IO to only use AJAX long polling for my app while the issue is sorted out. You can do this in your server code with:

    socket.set('transports', ['xhr-polling']);

Happy coding!
