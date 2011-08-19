desc "Clean _site"
task :clean do
  system "rm -r _site/*"
  puts "_site cleaned"
end

desc "Preview _site in a browser"
task :preview do
  system "bundle exec launchy 'http://localhost:4000'"
  system "bundle exec jekyll --server --auto"
end

desc "Build stylesheets via Sass"
task :sass do
  system "sass --update sass:styles"
end

desc "Build _site"
task :build => :sass do
  system "bundle exec jekyll"
end

desc "Sync _site"
task :sync do
  system "rsync -vzr --delete _site/ muse:/var/www/vhosts/brandontilley.com/httpdocs/"
  puts "_site synced"
end

desc "Build and sync _site"
task :publish => [:build, :sync]

namespace :cache do
  desc "Clear the Gist cache"
  task :clear do
    system "rm -r _gist_cache/*"
    puts "_gist_cache cleaned"
  end
end
