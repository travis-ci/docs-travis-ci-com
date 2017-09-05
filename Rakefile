#!/usr/bin/env rake

require 'aws-sdk'
require 'yaml'
require 'html-proofer'

class Data
  PRECISE = "binaries/ubuntu/12.04/x86_64"
  TRUSTY  = "binaries/ubuntu/14.04/x86_64"
end

language_data = {
  "php" => {
    bucket: "travis-php-archives",
    platforms: [ 'precise', 'trusty' ],
    basename_regexp: /^php-(\d+(\.\d)+)/,
  },
  "python" => {
    bucket: "travis-python-archives",
    platforms: [ 'precise', 'trusty' ],
    basename_regexp: /^python-(\d+(\.\d+)*)/,
  },
  "pypy" => {
    bucket: "travis-python-archives",
    platforms: [ 'precise', 'trusty' ],
    basename_regexp: /^pypy(\d+(\.\d+)*)?(-\d+(\.\d+)*)?(-(alpha|beta)\d*)?/,
  },
}

def s3
  @s3 ||= Aws::S3::Client.new # credentials and region are set by env var
end

def archive_list(lang:, bucket:, prefix:, basename_regexp:, ext: ".tar.bz2")
  objs = s3.list_objects(bucket: bucket, prefix: prefix).contents.select do |obj|
    File.basename(obj.key) =~ basename_regexp
  end

  objs.select do |obj|
    File.basename(obj.key).end_with? ext
  end
end

task :default => [:test]

desc 'Runs the tests!'
task :test => :build do
  Rake::Task['run_html_proofer'].invoke
end

desc 'Builds the site'
task :build => [:remove_output_dir, :gen_trusty_image_data, :populate_lang_archive_list] do
  FileUtils.rm '.jekyll-metadata' if File.exist?('.jekyll-metadata')
  sh 'bundle exec jekyll build --config=_config.yml'
end

desc 'Remove the output dir'
task :remove_output_dir do
  FileUtils.rm_r('_site') if File.exist?('_site')
end

def print_line_containing(file, str)
  File.open(file).grep(/#{str}/).each do |line| puts "#{file}: #{line}" end
end

desc 'Lists files containing beta features'
task :list_beta_files do
  files = FileList.new('**/*.md')
  files.exclude("_site/*", "STYLE.md")
  for f in files do
    print_line_containing(f, '\.beta')
  end
end

desc 'Runs the html-proofer test'
task :run_html_proofer do
  # seems like the build does not render `%3*`,
  # so let's remove them for the check
  url_swap = {
    /%3A\z/ => '',
    /%3F\z/ => '',
    /-\.travis\.yml/ => '-travisyml'
  }

  tester = HTMLProofer.check_directory('./_site', {
                              :url_swap => url_swap,
                              :internal_domains => ["docs.travis-ci.com"],
                              :connecttimeout => 600,
                              :only_4xx => true,
                              :typhoeus => { :ssl_verifypeer => false, :ssl_verifyhost => 0, :followlocation => true },
                              :url_ignore => ["https://www.appfog.com/", /itunes\.apple\.com/, /coverity.com/, /articles201769485/],
                              :file_ignore => ["./_site/api/index.html", "./_site/user/languages/erlang/index.html"]
                            })
  tester.run
end

desc 'Runs the html-proofer test for internal links only'
task :run_html_proofer_internal do
  # seems like the build does not render `%3*`,
  # so let's remove them for the check
  url_swap = {
    /%3A\z/ => '',
    /%3F\z/ => '',
    /-\.travis\.yml/ => '-travisyml'
  }

  tester = HTMLProofer.check_directory('./_site', {
                              :url_swap => url_swap,
                              :disable_external => true,
                              :internal_domains => ["docs.travis-ci.com"],
                              :connecttimeout => 600,
                              :only_4xx => true,
                              :typhoeus => { :ssl_verifypeer => false, :ssl_verifyhost => 0, :followlocation => true },
                              :file_ignore => ["./_site/api/index.html", "./_site/user/languages/erlang/index.html"]
                            })
  tester.run
end




desc 'Populate Trusty image table data'
task :gen_trusty_image_data do
  GENERATED_LANGUAGE_MAP_JSON_FILE = 'https://raw.githubusercontent.com/travis-infrastructure/terraform-config/master/aws-production-2/generated-language-mapping.json'

  fail unless sh "curl -OsSfL '#{GENERATED_LANGUAGE_MAP_JSON_FILE}'"

  json_data = JSON.load(File.read(File.basename(GENERATED_LANGUAGE_MAP_JSON_FILE)))
  yaml_data = json_data.to_yaml

  File.write(File.join(File.dirname(__FILE__), '_data', 'trusty_mapping_data.yml'), yaml_data)
end

desc "Populate language archive data"
task :populate_lang_archive_list do
  output = {}
  language_data.each do |runtime, data|
    output[runtime] = {}
    data[:platforms].each do |dist|
      archives = archive_list(lang: runtime, bucket: data[:bucket], prefix: Data.const_get(dist.upcase), basename_regexp: data[:basename_regexp])
      output[runtime][dist] = archives.map {|archive| File.basename(archive.key, ".tar.bz2")}
    end
  end

  File.write("_data/language_archives.yml", output.to_yaml)
end

desc 'Start Jekyll server'
task :serve => [:gen_trusty_image_data, :populate_lang_archive_list] do
  sh "bundle exec jekyll serve --config=_config.yml"
end

namespace :assets do
  task :precompile => [:build] do
  end
end
