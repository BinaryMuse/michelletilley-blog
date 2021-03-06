require 'cgi'
require 'digest/md5'
require 'net/https'
require 'uri'

module Jekyll
  class GistTag < Liquid::Tag
    def initialize(tag_name, text, token)
      super
      @text           = text
      @cache_disabled = false
      @cache_folder   = File.expand_path "../_gist_cache", File.dirname(__FILE__)
    end

    def render(context)
      if parts = @text.match(/([a-f\d]*) (.*)/)
        gist_id, file = parts[1].strip, parts[2].strip
        code          = get_cached_gist(gist_id, file) || get_gist_from_web(gist_id, file)
        html_output_for gist_id, file, code
      else
        ""
      end
    end

    def html_output_for(gist_id, file, code)
      code = CGI.escapeHTML code
      "<gist data-id='#{gist_id}' data-file='#{file}'></gist>" +
        "<noscript><pre><code>#{code}</code></pre>" +
        "<div><small><em><a href='https://gist.github.com/#{gist_id}'>View Gist " +
        "for <code>#{file}</code> on GitHub</a></em></small></div></noscript>"
    end

    def get_gist_url_for(gist, file)
      "https://gist.githubusercontent.com/BinaryMuse/#{gist}/raw/#{file}"
    end

    def cache(gist, file, data)
      cache_file = get_cache_file_for gist, file
      File.open(cache_file, "w") do |io|
        io.write data
      end
    end

    def get_cached_gist(gist, file)
      return nil if @cache_disabled
      cache_file = get_cache_file_for gist, file
      File.read cache_file if File.exist? cache_file
    end

    def get_cache_file_for(gist, file)
      bad_chars = /[^a-zA-Z0-9\-_.]/
      gist      = gist.gsub bad_chars, ''
      file      = file.gsub bad_chars, ''
      md5       = Digest::MD5.hexdigest "#{gist}-#{file}"
      File.join @cache_folder, "#{gist}-#{file}-#{md5}.cache"
    end

    def get_gist_from_web(gist, file)
      gist_url          = get_gist_url_for gist, file
      raw_uri           = URI.parse URI.encode(gist_url)
      https             = Net::HTTP.new raw_uri.host, raw_uri.port
      https.use_ssl     = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request           = Net::HTTP::Get.new raw_uri.request_uri
      data              = https.request request
      data              = data.body
      cache gist, file, data unless @cache_disabled
      data
    end
  end

  class GistTagNoCache < GistTag
    def initialize(tag_name, text, token)
      super
      @cache_disabled = true
    end
  end
end

Liquid::Template.register_tag('gist', Jekyll::GistTag)
Liquid::Template.register_tag('gistnocache', Jekyll::GistTagNoCache)
