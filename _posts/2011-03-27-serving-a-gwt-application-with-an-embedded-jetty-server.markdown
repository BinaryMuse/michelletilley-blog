---
layout: post
title: Serving a GWT Application with an Embedded Jetty Server
date: 2010-03-27 11:12:00
description: "How to serve a GWT application with an embedded Jetty server."
---

For a new project I am interested in starting, I want to serve a GWT application with an embedded Jetty server. I wasn't sure how to go about doing so, but it turns out it's easier than I could ever have expected! Check it out below.

{% gist 346622 EmbeddedGwt.java %}

You do, of course, need the [Jetty jars](http://download.eclipse.org/jetty/) (I used the ones from the 'lib' folder in the Jetty distribution) in your classpath.
