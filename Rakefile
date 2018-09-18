#!/usr/bin/env rake
# frozen_string_literal: true

require 'ipaddr'
require 'json'
require 'yaml'

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
  HTMLProofer.check_directory(
    './_site',
    internal_domains: ['docs.travis-ci.com'],
    connecttimeout: 600,
    allow_hash_ref: true,
    #disable_external: true,
    only_4xx: true,
    typhoeus: {
      ssl_verifypeer: false, ssl_verifyhost: 0, followlocation: true
    },
    url_ignore: [
      /itunes\.apple\.com/,
    ],
    file_ignore: %w[
      ./_site/api/index.html
    ]
  ).run
end

desc 'Runs the html-proofer test for internal links only'
task :run_html_proofer_internal => [:build] do
  HTMLProofer.check_directory(
    './_site',
    disable_external: true,
    internal_domains: ['docs.travis-ci.com'],
    connecttimeout: 600,
    only_4xx: true,
    typhoeus: {
      ssl_verifypeer: false, ssl_verifyhost: 0, followlocation: true
    },
    file_ignore: %w[
      ./_site/api/index.html
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

file '_data/linux_containers_ip_range.yml' do |t|
  define_ip_range('nat.linux-containers.travisci.net', t.name)
end

file '_data/macstadium_ip_range.yml' do |t|
  define_ip_range('nat.macstadium-us-se-1.travisci.net', t.name)
end

file '_data/packet_ip_range.yml' do |t|
  define_ip_range('nat.packet-ewr1.travisci.net', t.name)
end

file '_data/node_js_versions.yml' do |t|
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
  _data/ip_range.yml
  _data/linux_containers_ip_range.yml
  _data/macstadium_ip_range.yml
  _data/trusty_language_mapping.yml
  _data/node_js_versions.yml
])

desc 'Remove generated files'
task :clean do
  rm_f(%w[
         _data/ec2_ip_range.yml
         _data/gce_ip_range.yml
         _data/ip_range.yml
         _data/linux_containers_ip_range.yml
         _data/macstadium_ip_range.yml
         _data/trusty-language-mapping.json
         _data/trusty_language_mapping.yml
         _data/node_js_versions.yml
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
