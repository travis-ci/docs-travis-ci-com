require "html/proofer"
task :default => :test

task :test do
  sh "bundle exec jekyll build"
  HTML::Proofer.new("./_site/").run
end
