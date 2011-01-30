require 'digest/md5'
require 'net/https'
require 'uri'

module Jekyll
  class GistTag < Liquid::Tag
    def initialize(tag_name, text, token)
      super
      @text         = text
      @cache_folder = File.expand_path "../_gist_cache", File.dirname(__FILE__)
    end

    def render(context)
      return "" unless @text =~ /([\d]*) (.*)/

      script_url = "https://gist.github.com/#{$1}.js?file=#{$2}"
      link_url   = "https://gist.github.com/#{$1}#file_#{$2}"
      raw_url    = "https://gist.github.com/raw/#{$1}/#{$2}"

      code = get_cached_gist(raw_url) || get_gist_from_web(raw_url)
      string  = "<script src='#{script_url}'></script>"
      string += "<noscript><pre><code>#{code}</code></pre></noscript>"
      return string
    end

    def cache_gist(gist_url, data)
      file = get_cache_file_for gist_url
      File.open(file, "w+") do |f|
        f.write(data)
      end
    end

    def get_cached_gist(gist_url)
      file = get_cache_file_for gist_url
      return nil unless File.exist?(file)
      return File.new(file).readlines.join
    end

    def get_cache_file_for(gist_url)
      File.join @cache_folder, "#{Digest::MD5.hexdigest(gist_url)}.cache"
    end

    def get_gist_from_web(gist_url)
      raw_uri           = URI.parse(gist_url)
      https             = Net::HTTP.new(raw_uri.host, raw_uri.port)
      https.use_ssl     = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request           = Net::HTTP::Get.new(raw_uri.request_uri)
      data              = https.request(request)
      data              = data.body
      cache_gist(gist_url, data)
      data
    end
  end
end

Liquid::Template.register_tag('gist', Jekyll::GistTag)