#!/usr/bin/env rake
# frozen_string_literal: true

require 'ipaddr'
require 'json'
require 'yaml'

require 'faraday'
require 'html-proofer'
require 'aws-sdk'

require 'pry'

def language_data
  {
    php: {
      bucket: 'travis-php-archives',
      releases: %w( precise trusty ),
      basename_regexp: /^php-(\d+(\.\d+)*)/,
    },
    python: {
      bucket: 'travis-python-archives',
      releases: %w( precise trusty ),
      basename_regexp: /^python-(\d+(\.\d+)*)/,
    },
    pypy: {
      bucket: 'travis-python-archives',
      releases: %w( precise trusty ),
      basename_regexp: /^pypy(\d+(\.\d+)*)?(-\d+(\.\d+)*)?(-(alpha|beta)\d*)?/,
    },
  }
end

def s3_prefix
  {
    precise: 'binaries/ubuntu/12.04/x86_64',
    trusty:  'binaries/ubuntu/14.04/x86_64'
  }
end

def print_line_containing(file, str)
  File.open(file).grep(/#{str}/).each { |line| puts "#{file}: #{line}" }
end

def dns_resolve(hostname, rectype: 'A')
  JSON.parse(
    Faraday.get("https://dnsjson.com/#{hostname}/#{rectype}.json").body
  ).fetch('results').fetch('records')
end

def define_ip_range(nat_hostname, dest)
  data = dns_resolve(nat_hostname)

  bytes = File.write(
    dest,
    YAML.dump(
      'host' => nat_hostname,
      'ip_range' => data.sort { |a, b| IPAddr.new(a) <=> IPAddr.new(b) }
    )
  )

  puts "Updated #{dest} (#{bytes} bytes)"
end

def s3
  @s3 ||= Aws::S3::Client.new # credentials are set by env var
end

def archive_list(lang:, bucket:, prefix:, basename_regexp:, ext: ".tar.bz2")
  objs = s3.list_objects(bucket: bucket, prefix: prefix).contents.select do |obj|
    File.basename(obj.key) =~ basename_regexp
  end

  objs.select do |obj|
    File.basename(obj.key).end_with? ext
  end
end

def language_versions
  language_file = File.join(File.dirname(__FILE__), '_data', 'language_versions.yml')
  File.file?(language_file) ? YAML.load_file(language_file) : {}
end

def node_js_versions
  remote_node_versions = `bash -l -c "source $HOME/.nvm/nvm.sh; nvm ls-remote"`.split("\n").
    map {|l| l.gsub(/.*v(0\.[1-9][0-9]*|[1-9]*)\..*$/, '\1')}.uniq.
    sort {|a,b| Gem::Version.new(b) <=> Gem::Version.new(a) }
  remote_node_versions.flatten.compact.take(5)
end

def larnguage_archive_versions(lang: :'')
  unless language_data[lang]
    puts "Unknown language #{lang}"
    fail
  end

  data = language_data[lang]
  output = {}
  data[:releases].each do |rel|
    archives = archive_list(
      lang: lang,
      bucket: data[:bucket],
      prefix: s3_prefix[rel.to_sym],
      basename_regexp: data[:basename_regexp]
    )
    output[rel] = archives.map do |archive|
      File.basename(archive.key, ".tar.bz2")
    end
  end

  output
end

def php_versions
  larnguage_archive_versions(lang: :php)
end

def python_versions
  larnguage_archive_versions(lang: :python)
end

def pypy_versions
  larnguage_archive_versions(lang: :pypy)
end

task default: :test

desc 'Runs the tests!'
task test: %i[build run_html_proofer]

desc 'Builds the site (Jekyll and Slate)'
task build: %i[remove_output_dir regen make_api] do
  rm_f '.jekyll-metadata'
  sh 'bundle exec jekyll build --config=_config.yml'
end

desc 'Remove the output dirs'
task :remove_output_dir do
  rm_rf('_site')
  rm_rf('api/*')
end

desc 'Lists files containing beta features'
task :list_beta_files do
  files = FileList.new('**/*.md')
  files.exclude('_site/*', 'STYLE.md')
  files.each do |f|
    print_line_containing(f, '\.beta')
  end
end

desc 'Runs the html-proofer test'
task :run_html_proofer => [:build] do
  # seems like the build does not render `%3*`,
  # so let's remove them for the check
  url_swap = {
    /%3A\z/ => '',
    /%3F\z/ => '',
    /-\.travis\.yml/ => '-travisyml'
  }

  HTMLProofer.check_directory(
    './_site',
    url_swap: url_swap,
    internal_domains: ['docs.travis-ci.com'],
    connecttimeout: 600,
    only_4xx: true,
    typhoeus: {
      ssl_verifypeer: false, ssl_verifyhost: 0, followlocation: true
    },
    url_ignore: [
      'https://www.appfog.com/',
      /itunes\.apple\.com/,
      /coverity.com/,
      /articles201769485/
    ],
    file_ignore: %w[
      ./_site/api/index.html
      ./_site/user/languages/erlang/index.html
      ./_site/user/languages/objective-c/index.html
      ./_site/user/reference/osx/index.html
    ]
  ).run
end

namespace :languages do
  task :update, [:lang] do |_t, args|
    lang = args[:lang]
    langs = lang ? lang.split(/\s+/ ) : %w(node_js php python pypy)

    yml = '_data/language_versions.yml'

    langs.each do |lang|
      lang_data = language_versions || {}
      lang_data[lang] = send("#{lang}_versions".to_sym)

      io = File.open(yml, "w")

      bytes = io.write( YAML.dump(lang_data) )
      io.fsync

      puts "Updated #{yml} with #{lang} data (#{bytes} bytes)"
    end
  end
end

desc 'Runs the html-proofer test for internal links only'
task :run_html_proofer_internal => [:build] do
  # seems like the build does not render `%3*`,
  # so let's remove them for the check
  url_swap = {
    /%3A\z/ => '',
    /%3F\z/ => '',
    /-\.travis\.yml/ => '-travisyml'
  }

  HTMLProofer.check_directory(
    './_site',
    url_swap: url_swap,
    disable_external: true,
    internal_domains: ['docs.travis-ci.com'],
    connecttimeout: 600,
    only_4xx: true,
    typhoeus: {
      ssl_verifypeer: false, ssl_verifyhost: 0, followlocation: true
    },
    file_ignore: %w[
      ./_site/api/index.html
      ./_site/user/languages/erlang/index.html
      ./_site/user/languages/objective-c/index.html
      ./_site/user/reference/osx/index.html
    ]
  ).run
end

file '_data/trusty-language-mapping.json' do |t|
  source = File.join(
    'https://raw.githubusercontent.com',
    'travis-infrastructure/terraform-config/master/aws-production-2',
    'generated-language-mapping.json'
  )

  bytes = File.write(t.name, Faraday.get(source).body)

  puts "Updated #{t.name} (#{bytes} bytes)"
end

file '_data/trusty_language_mapping.yml' => [
  '_data/trusty-language-mapping.json'
] do |t|
  bytes = File.write(
    t.name,
    YAML.dump(JSON.parse(File.read('_data/trusty-language-mapping.json')))
  )

  puts "Updated #{t.name} (#{bytes} bytes)"
end

file '_data/ip_range.yml' do |t|
  define_ip_range('nat.travisci.net', t.name)
end

file '_data/ec2_ip_range.yml' do |t|
  define_ip_range('nat.aws-us-east-1.travisci.net', t.name)
end

file '_data/gce_ip_range.yml' do |t|
  define_ip_range('nat.gce-us-central1.travisci.net', t.name)
end

file '_data/macstadium_ip_range.yml' do |t|
  define_ip_range('nat.macstadium-us-se-1.travisci.net', t.name)
end

desc 'Refresh generated files'
task regen: (%i[clean] + %w[
  _data/ec2_ip_range.yml
  _data/gce_ip_range.yml
  _data/ip_range.yml
  _data/macstadium_ip_range.yml
  _data/trusty_language_mapping.yml
] + ['languages:update'])

desc 'Remove generated files'
task :clean do
  rm_f(%w[
         _data/ec2_ip_range.yml
         _data/gce_ip_range.yml
         _data/ip_range.yml
         _data/macstadium_ip_range.yml
         _data/trusty-language-mapping.json
         _data/trusty_language_mapping.yml
         _data/language_versions.yml
       ])
end

desc 'Start Jekyll server'
task serve: [:make_api, :regen] do
  sh 'bundle exec jekyll serve --config=_config.yml'
end

namespace :assets do
  task precompile: [:make_api, :build]
end

desc 'make API docs'
task :make_api do
  sh 'bundle exec middleman build --clean'
end
