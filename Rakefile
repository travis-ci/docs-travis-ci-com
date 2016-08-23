#!/usr/bin/env rake

require 'html/proofer'

task :default => [:test]

desc 'Runs the tests!'
task :test => :build do
  Rake::Task['run_html_proofer'].invoke
end

desc 'Builds the site'
task :build => :remove_output_dir do
  FileUtils.rm '.jekyll-metadata' if File.exist?('.jekyll-metadata')
  sh 'bundle exec jekyll build --config=_config.yml'
end

desc 'Remove the output dir'
task :remove_output_dir do
  FileUtils.rm_r('_site') if File.exist?('_site')
end

desc 'Runs the html-proofer test'
task :run_html_proofer do
  # seems like the build does not render `%3*`,
  # so let's remove them for the check
  href_swap = {
    /%3A\z/ => '',
    /%3F\z/ => '',
    /-\.travis\.yml/ => '-travisyml'
  }

  tester = HTML::Proofer.new('./_site', {
                              :href_swap => href_swap,
                              :connecttimeout => 600,
                              :only_4xx => true,
                              :typhoeus => { :ssl_verifypeer => false, :ssl_verifyhost => 0, :followlocation => true },
                              :url_ignore => ["https://www.appfog.com/", /itunes\.apple\.com/, /coverity.com/],
                              :file_ignore => ["./_site/api/index.html", "./_site/user/languages/erlang/index.html"]
                            })
  tester.run
end

namespace :assets do
  task :precompile do
    puts `bundle exec jekyll build`
  end
end
