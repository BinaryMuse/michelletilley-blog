brandontilley.com
=================

This is my blog, driven by [Jekyll](https://github.com/mojombo/jekyll). Nothing particularly special here, unless you count the [Gist tag](https://github.com/BinaryMuse/brandontilley-blog/blob/master/_plugins/gist_tag.rb) (with caching) I added. To include a Gist, use the tag like so:

    {% gist gist-number file-name %}

It will write the Gist embed JavaScript code, and also download the raw code from GitHub and display it inside a `<noscript>` block for RSS readers and browsers with JavaScript disabled. The contents of the Gists are cached in `_gist_cache` for subsequent builds, and can be cleared with `rake cache:clear`.