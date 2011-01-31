---
layout: post
title: Gist Tag for Jekyll
date: 2011-02-01 11:38:00
description: Easily include Gists in your Jekyll posts, including noscript support.
---

One of the many reasons I [moved away from WordPress](/2011/01/30/so-long-wordpress.html) was to make it easier to support code-laden posts. [Gists](https://gist.github.com/) have been a favored way of incorporating code into posts (and automatically keeping them up to date!), but WordPress didn't show the `<script>` tag in its editor, making it difficult edit the document around them, especially in posts with several code sections.

While Jekyll makes it crazy-easy to insert the necessary tags into your documents, there's still one small problem: people who read the posts in an RSS reader miss out on the code-goodness! Sure, you can toss a quick `<noscript>` in there with a link to the post or to the Gist, but that feels like cheating. So, I wrote a Fluid tag for Jekyll to take care of the problem:

{% gist 803483 gist_tag.rb %}

(The above Gist is being shown with the Gist tag; how very meta.)

The code takes a Fluid tag in the form of `{{ "{% gist gist-number file-name "}}%}` and inserts the necessary `<script>` tags into the document to display the given file from the given Gist. However, it also downloads the raw form of the Gist and inserts it into a `<noscript><pre><code>` block. It also caches the contents of the Gist into the `_gist_cache` folder of your Jekyll site (which should be added to your `.gitignore` file, etc) to make future compiles faster.

If you are rapidly iterating over multiple commits in your gist, you can use the `gistnocache` tag; taking the form `{{ "{% gistnocache gist-number file-name "}}%}`, this tag does the exact same thing but skips reading from or writing to the Gist cache. Once you're happy with your Gist, you can change the `gistnocache` tag to a regular `gist` tag. Of course, there's always the chance that you need to remove a specific cached Gist from the cache; in that case, the files in `_gist_cache` are named intelligently to help you locate the file you need to delete.

Overall, it seems to be working fairly well. I hope this is of some use to others! Please let me know in the comments to this post or the comments to the Gist if you have any problems or suggestions.