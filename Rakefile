#!/usr/bin/env rake

require 'html-proofer'

task :default => [:test]

desc 'Runs the tests!'
task :test => :build do
  Rake::Task['run_html_proofer'].invoke
end

desc 'Builds the site'
task :build => [:remove_output_dir, :gen_trusty_image_data, :gen_gce_ip_addr_range] do
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

desc 'Populate GCE IP address range'
task :gen_gce_ip_addr_range do
  require 'ipaddr'

  # Using steps described in https://cloud.google.com/compute/docs/faq#where_can_i_find_short_product_name_ip_ranges
  # we populate the range of IP addresses for GCE instances

  GOOGLE_DNS_SERVER='8.8.8.8'
  DNS_ROOT='_cloud-netblocks.googleusercontent.com'

  root_answer=`nslookup -q=TXT _cloud-netblocks.googleusercontent.com #{GOOGLE_DNS_SERVER}`

  blocks=[]

  root_answer.split.grep(/^include:/).map {|x| x.sub(/^include:/,'')}.each do |netblock_host|
    block_answer = `nslookup -q=TXT #{netblock_host} #{GOOGLE_DNS_SERVER}`
    blocks += block_answer.split.grep(/^ip4:/).map {|x| x.sub(/^ip4:/,'')}
  end

  blocks_sorted = blocks.sort do |a,b|
    IPAddr.new(a) <=> IPAddr.new(b)
  end

  File.write(File.join(File.dirname(__FILE__), '_data', 'gce_ip_range.yml'), blocks_sorted.map {|ip| "`#{ip}`"}.join(", ").to_yaml)
end

desc 'Start Jekyll server'
task :serve => [:gen_trusty_image_data] do
  sh "bundle exec jekyll serve --config=_config.yml"
end

namespace :assets do
  task :precompile => [:build] do
  end
end
