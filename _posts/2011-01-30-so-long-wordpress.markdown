---
layout: post
title: So Long, Wordpress
date: 2011-01-30 11:44:00
description: 'Waving "goodbye" to WordPress as I move to Jekyll.'
---

WordPress has served me well for a long time. I've used it on multiple sites over the years. But I've found, lately, that it just feels big and bloated. I want something small, lean, and customizable. I want something that'll let me focus on creating content and stay out of the way. That something is [Jekyll](https://github.com/mojombo/jekyll).

Jekyll brings, to my mind, several advantages:

Static Content
--------------

Jekyll is described by its creator as "[blogging like a hacker](http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html)." At it's most basic level, Jekyll is a static site generator. It takes HTML, Markdown, Textile and others and compiles it into static HTML. That static HTML is then fit to be served and cached like any other HTML. No server-side processing required!

Simplicity
----------

Jekyll is beautiful and elegant in its simplicity. Write posts in your favorite text editor in your favorite format. Store them in your Git repository for built-in backup. Create branches as you work on future posts. And publishing is as easy as an rsync to your server of choice.

Flexibility
-----------

Jekyll imposes very few rules on you. Any file with a [YAML front matter block](https://github.com/mojombo/jekyll/wiki/yaml-front-matter) is processed by Jekyll, making it easy to provide RSS feeds and other "special" files. Jekyll's [Liquid](http://www.liquidmarkup.org/) layout provides plenty of flexibility without the gross (IMO) "[WordPress Loop](http://codex.wordpress.org/The_Loop)".

So, over the next few days or weeks, I'll be moving some of the posts from my [old blog](http://binarymuse.net/) over to this one. Be sure to [resubscribe to the feed](/atom.xml), as the URL has changed!