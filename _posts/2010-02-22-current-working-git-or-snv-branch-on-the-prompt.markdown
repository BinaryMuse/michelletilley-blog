---
layout: post
title: Current Working Git or SVN Branch on the Prompt
date: 2010-02-22 16:36:00
description: Show the Git or Subversion branch you are currently working in on the command line prompt.
---

This is a nifty tip I picked up somewhere on the Internet to show the Git or Subversion branch you are currently working in on the command line prompt, which I modified to include your stash level. I haven't done a ton of serious programming under Subversion, but I know with Git I'm branching all the time ([branches are so cheap in Git](http://whygitisbetterthanx.com/#cheap-local-branching)!). I wasn't sure if I'd like the results before I tried it, but as it turns out, it's even more helpful than I thought it'd be.

Edit your `~/.bash_profile` to mirror the following functions. Of course, you may change the details of PS1 to your liking; it's the `\$(parse_git_branch)\$(parse_svn_branch)` that's important.


{% gist 447949 DND (blog): git on prompt.sh %}

And what you end up with looks like (in this particular case):

`[BinaryMuse ~/repo.git/src (FIX-15013 +2)]:`

Enjoy!