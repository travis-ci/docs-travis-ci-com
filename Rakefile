#!/usr/bin/env rake
# frozen_string_literal: true

abort('Please run this using `bundle exec rake`') unless ENV["BUNDLE_BIN_PATH"]

require 'ipaddr'
require 'json'
require 'yaml'
require 'netrc'
require 'erb'
require 'openssl'

require 'faraday'
require 'html-proofer'

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

task default: :test

desc 'Runs the tests!'
task test: %i[build run_html_proofer]

desc 'Builds the site (Jekyll and Slate)'
task build: %i[regen make_api update_lang_vers] do
  rm_f '.jekyll-metadata'
  sh 'bundle exec jekyll build --config=_config.yml'
end

desc 'Lists files containing beta features'
task :list_beta_files do
  files = FileList.new('**/*.md')
  files.exclude('_site/*', 'STYLE.md')
  files.each do |f|
    print_line_containing(f, '\.beta')
  end
end

desc 'Check links and validate some html'
task :run_html_proofer => [:build] do
  options = {
      internal_domains: ['docs.travis-ci.com'],
      check_external_hash: true,
      check_html: true,
      connecttimeout: 600,
      allow_hash_ref: true,
      #only_4xx: true,
      typhoeus: {
        ssl_verifypeer: false, ssl_verifyhost: 0, followlocation: true
      },
      url_ignore: [
        /itunes\.apple\.com/,
      ],
      file_ignore: %w[
        ./_site/api/index.html
      ],
      :cache => {
        :timeframe => '3w'
      }
  }
  begin
    HTMLProofer.check_directory( './_site', options).run
  rescue => msg
    puts "#{msg}"
  end
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

file '_data/gce_ip_ue1_range.yml' do |t|
  define_ip_range('nat.gce-us-east1.travisci.net', t.name)
end

file '_data/linux_containers_ip_range.yml' do |t|
  define_ip_range('nat.linux-containers.travisci.net', t.name)
end

file '_data/macstadium_ip_range.yml' do |t|
  define_ip_range('nat.macstadium-us-se-1.travisci.net', t.name)
end

file '_data/node_js_versions.yml' do |t|
  sh 'test -f $HOME/.nvm/nvm.sh || (curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash)'
  remote_node_versions = `bash -l -c "source $HOME/.nvm/nvm.sh; nvm ls-remote"`.split("\n").
    map {|l| l.gsub(/.*v(0\.[0-9]*|[0-9]*)\..*$/, '\1')}.uniq.
    sort {|a,b| Gem::Version.new(b) <=> Gem::Version.new(a) }

  bytes = File.write(
    t.name,
    YAML.dump(
      remote_node_versions.flatten.compact.take(5)
    )
  )
  puts "Updated #{t.name} (#{bytes} bytes)"
end

desc 'Refresh generated files'
task regen: (%i[clean] + %w[
  _data/ec2_ip_range.yml
  _data/gce_ip_range.yml
  _data/gce_ip_ue1_range.yml
  _data/ip_range.yml
  _data/linux_containers_ip_range.yml
  _data/macstadium_ip_range.yml
  _data/node_js_versions.yml
  user/notifications.md
] + %i[update_lang_vers])

desc 'Remove generated files'
task :clean do
  rm_f(%w[
         _data/ec2_ip_range.yml
         _data/gce_ip_range.yml
         _data/gce_ip_ue1_range.yml
         _data/ip_range.yml
         _data/linux_containers_ip_range.yml
         _data/macstadium_ip_range.yml
         _data/node_js_versions.yml
         _data/language-details/*-versions.yml
       ])
  rm_rf('assets/javascripts/tablefilter')
  rm_rf('_site')
  rm_rf('api/*')
  rm_rf('user/notifications.md')
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

LANG_ARCHIVE_HOST='language-archives.travis-ci.com'
TABLEFILTER_SOURCE_PATH='assets/javascripts/tablefilter/dist/tablefilter/tablefilter.js'

desc 'update language archive versions'
task :update_lang_vers => [TABLEFILTER_SOURCE_PATH] do
  definitions = YAML.load_file('_data/language-details/archive_definitions.yml')
  definitions.each do |lang, defs|
    sh "curl" \
      " -H \"Accept: application/x-yaml\"" \
      " https://#{LANG_ARCHIVE_HOST}/builds/#{lang}/#{defs.fetch("prefix","ubuntu")}",
      :out => "_data/language-details/#{lang}-versions.yml"
  end
end

desc "Add TableFilter"
file TABLEFILTER_SOURCE_PATH do
  sh "git", "clone", "--depth=1", "https://github.com/koalyptus/TableFilter.git", "assets/javascripts/tablefilter"
end

desc 'Update notifications ciphers'
file 'user/notifications.md' do
  line_length = 80
  ciphers = OpenSSL::Cipher.ciphers.sort.map(&:upcase)
  x = []
  while !ciphers.empty? do
    row = []
    while row.join(" ").length < line_length do
      row << ciphers.shift
    end
    ciphers.unshift row.pop unless ciphers.empty?
    x << row.compact.join(" ")
  end
  @ciphers_list = x.join("\n")
  renderer = ERB.new(File.read('user/notifications.md.erb'))
  f = File.new('user/notifications.md', 'w')
  f.write renderer.result(binding)
end
