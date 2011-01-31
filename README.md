brandontilley.com
=================

This is my blog, driven by [Jekyll](https://github.com/mojombo/jekyll). Nothing particularly special here, unless you count the [Gist tag](https://github.com/BinaryMuse/brandontilley-blog/blob/master/_plugins/gist_tag.rb) (with caching) I added. To include a Gist, use the tag like so:

    {% gist gist-number file-name %}

The `file-name` does not need to be real if the Gist only has one file (e.g. no `file=` parameter in the JavaScript embed URL), but it must be included (for now).

The contents of the Gists are cached in `_gist_cache`, and can be cleared with `rake cache:clear`.