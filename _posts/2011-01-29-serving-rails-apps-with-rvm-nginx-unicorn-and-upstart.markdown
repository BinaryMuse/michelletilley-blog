---
layout: post
title: Serving Rails Apps with RVM, Nginx, Unicorn and Upstart
date: 2011-01-29 21:49:00
description: "Ever since reading GitHub's blog post on Unicorn, I've been interested in trying it out. This post will document the process I used to get Unicorn serving a Rails application behind Nginx, with RVM managing Ruby."
---

Ever since reading <a href="https://github.com/blog/517-unicorn">GitHub's blog post on Unicorn</a>, I've been interested in trying it out. This post will document the process I used to get Unicorn serving a Rails application behind Nginx, with RVM&nbsp;managing Ruby. If you've read GitHub's post, some of the config will look very familiar. Ideally, though, you should be able to follow this post from start to finish and have a working setup going.

Introduction
============

I installed this setup on Ubuntu 10.04 LTS Server Edition, 64-bit. You should be able to follow along pretty well on any sane system; that being said, I do use Upstart to manage the services toward the end of the guide. If you don't use Upstart, you will need to substitute in your own SysVinit scripts (or scripts for whatever you use instead).

In a few listings, I use curl with Gist URLs to fetch the contents of files; the contents of these files are shown below the shell commands, for reference.

Installing RVM
==============

Since we'll use RVM to manage our Rubies and gemsets on the server, we'll start with a server-wide install of RVM. We'll start out by installing curl and git, if necessary, then RVM, and finally the other packages RVM asks us to install. (Be sure to pay attention to these; you can view them again via `rvm notes`. You may need to install additional packages for your distro of Linux or for the Rubies you wish to use). I'm using Ruby 1.9.2-p136 here.

We'll also take care to add the current user to the 'rvm' group. Finally, we'll create a user called 'unicorn' to own our test application, later.

{% gist 802568 00_rvm.sh %}

Installing and Configuring Nginx
================================

For simplicity's sake, we'll be using Nginx from APT. To make sure we're up to date, we'll use Nginx's PPA.

You can see in the configuration file that I've jumped the gun and included the location of the shared socket we'll use with our Unicorn application.

{% gist 802568 01_nginx.sh %}

`/etc/nginx/nginx.conf`:

{% gist 802568 etc_nginx.conf %}


Configuring Upstart for Nginx
=============================

If you don't use Upstart, or you don't want to use Upstart, feel free to skip this section. By default, you can start Nginx with `sudo /etc/init.d/nginx start`.

{% gist 802568 02_nginx_upstart.sh %}

`/etc/init/nginx.conf`:

{% gist 802568 init_nginx.conf %}

Creating a Sample Rails Application
===================================

Now we'll create a test Rails application in /var/www/test_app. We'll use a gemset called rails_app to demonstrate Unicorn's ability to figure out which gemset it should use for our application (for more details on this, check out step four in [my earlier post on Unicorn and Upstart](/2011/01/29/rvm-unicorn-and-upstart.html)). For this to work, we'll also create an RVM wrapper for Unicorn. And, of course, don't forget your config/unicorn.rb file.

Again, we'll use Upstart to start and manage our Unicorn process, but you can use whatever you'd like. If you just want to test it out, try running `unicorn -c /var/www/test_app/config/unicorn.rb` from the 'global' gemset.

{% gist 802568 03_sample_app.sh %}

`/etc/init/test_app.conf`:

{% gist 802568 test_app.conf %}

`/var/www/test_app/config/unicorn.rb`:

{% gist 802568 unicorn.rb %}

Profit!
=======

And that's that! Upstart will manage both Nginx and Unicorn (although either could benefit from something like Monit or God, but I'll leave that as an exercise for the reader and/or a future blog post).