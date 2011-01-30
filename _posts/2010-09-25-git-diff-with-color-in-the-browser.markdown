---
layout: post
title: git diff with Color in the Browser
date: 2010-09-25 13:22:00
description: "Pipe your 'git diff' (and other commands) to a browser window."
---

If you're anything like me (I feel sorry for you), then you use git diff pretty heavily. I like making sure I'm definitely committing what I think I'm committing, and I also like to verify my indentation, trailing whitespace, line endings, and so on are correct before I commit. I don't tend to use many GUI tools for Git, so I end up paging through terminal output. While this works fine, I've discovered a solution I like more.

It involves [Ryan Tomayko's bcat](http://rtomayko.github.com/bcat/), which is a pipe-to-browser utility. Since it supports ANSI/VT100 escape sequences, we even get nice color formatting. After [installing](http://github.com/rtomayko/bcat/blob/master/INSTALLING#files) bcat, our options are two-fold for using it with Git:

**1. Pipe output to bcat**

If you only want to use bcat from time to time, you can easily pipe ouptut from a Git command to bcat:

    git diff | bcat

To get color, specify it as an option to git diff:

    git diff --color | bcat 

**2. Set bcat as Git's pager**

If you want to use bcat for every operation Git sends to your pager, try the following:

    export GIT_PAGER=bcat
    git diff
    git log
    git log --oneline --decorate

And there you have it! Easy reviewing if your diffs in your browser. Be sure to check out the other examples on bcat's homepage for some really neat uses!