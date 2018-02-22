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

def dns_txt(hostname, record: 0)
  JSON.parse(
    Faraday.get("https://dnsjson.com/#{hostname}/TXT.json").body
  ).fetch('results').fetch('records').fetch(record).split.map(&:strip)
end

task default: :test

desc 'Runs the tests!'
task test: %i[build run_html_proofer]

desc 'Builds the site'
task build: %i[remove_output_dir regen] do
  rm_f '.jekyll-metadata'
  sh 'bundle exec jekyll build --config=_config.yml'
end

desc 'Remove the output dir'
task :remove_output_dir do
  rm_rf('_site')
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

  File.write(t.name, Faraday.get(source).body)
end

file '_data/trusty_language_mapping.yml' => [
  '_data/trusty-language-mapping.json'
] do |t|
  File.write(
    t.name,
    YAML.dump(JSON.parse(File.read('_data/trusty-language-mapping.json')))
  )

  puts "Updated #{t.name}"
end

file '_data/ec2-public-ips.json' do |t|
  source = File.join(
    'https://raw.githubusercontent.com',
    'travis-infrastructure/terraform-config/master/aws-shared-2',
    'generated-public-ip-addresses.json'
  )

  File.write(t.name, Faraday.get(source).body)
end

file '_data/ec2_public_ips.yml' => '_data/ec2-public-ips.json' do |t|
  data = JSON.parse(File.read('_data/ec2-public-ips.json'))
  by_site = %w[com org].map do |site|
    [
      site,
      data['ips_by_host'].find { |d| d['host'] =~ /-#{site}-/ }
    ]
  end

  File.write(t.name, YAML.dump(by_site.to_h))

  puts "Updated #{t.name}"
end

file '_data/gce_ip_range.yml' do |t|
  # Using steps described in:
  # https://cloud.google.com/compute/docs/faq#where_can_i_find_short_product_name_ip_ranges
  # we populate the range of IP addresses for GCE instances
  dns_root = ENV.fetch(
    'GOOGLE_DNS_ROOT', '_cloud-netblocks.googleusercontent.com'
  )

  blocks = dns_txt(dns_root).grep(/^include:/).map do |bl|
    dns_txt(bl.sub(/^include:/, '')).grep(/^ip4:/)
                                    .map { |l| l.sub(/^ip4:/, '') }
  end

  File.write(
    t.name,
    YAML.dump(
      'ip_ranges' => blocks.flatten
                           .compact
                           .sort { |a, b| IPAddr.new(a) <=> IPAddr.new(b) }
    )
  )

  puts "Updated #{t.name}"
end

file '_data/python_versions.yml' do |t|
  os_releases = {
    'ubuntu' => {
      'precise' => '12.04',
      'trusty'  => '14.04'
    }
  }
  results = {}

  os_releases.each do |os, os_versions|
    results = {}
    results['ubuntu'] = {}
    os_versions.each do |code_name, os_version|
      results['ubuntu'][code_name] = {}
      python_releases = []
      versions = `aws s3 ls travis-python-archives/binaries/#{os}/#{os_version}/x86_64/`.split("\n").map do |f|
        /python-(?<version>.*)\.tar\.bz2$/ =~ f
        if version
          python_releases << version
        end
      end
      results['ubuntu'][code_name]['size'] = python_releases.size
      results['ubuntu'][code_name]['release'] = os_version
      results['ubuntu'][code_name]['versions'] = python_releases
    end
    puts results
  end
  results['ubuntu']['size'] = os_releases['ubuntu'].keys.inject(0) do |sum, code_name|
    puts code_name
    sum += results['ubuntu'][code_name]['size']
  end

  File.write(t.name, YAML.dump(results))

  puts "Updated #{t.name}"
end

desc 'Refresh generated files'
task regen: [
  :clean,
  '_data/ec2_public_ips.yml',
  '_data/gce_ip_range.yml',
  '_data/trusty_language_mapping.yml',
  '_data/python_versions.yml'
]

desc 'Remove generated files'
task :clean do
  rm_f(%w[
         _data/ec2_public_ips.yml
         _data/ec2-public-ips.json
         _data/gce_ip_range.yml
         _data/trusty-language-mapping.json
         _data/trusty_language_mapping.yml
         _data/python_versions.yml
       ])
end

desc 'Start Jekyll server'
task serve: :regen do
  sh 'bundle exec jekyll serve --config=_config.yml'
end

namespace :assets do
  task precompile: :build
end
