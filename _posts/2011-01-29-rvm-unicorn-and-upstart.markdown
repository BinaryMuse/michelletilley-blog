---
layout: post
title: RVM, Unicorn and Upstart
date: 2011-01-29 15:01:00
description: "Using Upstart to manage Unicorn under RVM."
---

I had a heck of a time this week trying to figure out how to get Upstart to start an instance of Unicorn due to the fact that Ruby was being managed with RVM. I finally realized I had been going about it the wrong way, and that RVM provided the tool that I needed: wrapper scripts. I opted to use a single wrapper script for the version of Ruby I was running, and to let Unicorn decide what gemset to use based on the .rvmrc file in the project. Here's the whole process:

**Step 1: Make sure Unicorn is installed in the global gemset**

    rvm use ruby-1.9.2-p136@global
    gem install unicorn

**Step 2: Create a wrapper script for Unicorn**

    rvm wrapper ruby-1.9.2-p136 r192 unicorn

**Step 3: Modify your Upstart configuration file's "exec" line**

    exec /usr/local/rvm/bin/r192_unicorn -c /path/to/app/config/unicorn.rb

**Step 4: Modify your config/unicorn.rb file**

Use the following code at the top of your unicorn.rb file to tell Unicorn to set up the environment based on the .rvmrc file in the root of the project:

    if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
      begin
        rvm_path     = File.dirname(File.dirname(ENV['MY_RUBY_HOME']))
        rvm_lib_path = File.join(rvm_path, 'lib')
        $LOAD_PATH.unshift rvm_lib_path
        require 'rvm'
        RVM.use_from_path! File.dirname(File.dirname(__FILE__))
      rescue LoadError
        raise "The RVM Ruby library is not available."
      end
    end

    ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
    require 'bundler/setup'

**Step 5: Start your service**

Now you should be able to start your Unicorn app via `sudo service start` appname.