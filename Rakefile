def source
  Dir.pwd
end

def destination
  File.join(source, '_site')
end

task :default => :test
task :build do
  require 'jekyll'
  Jekyll::Commands::Build.process({
    'source'      => source,
    'destination' => destination
  })
end
task :test => :build do
  require 'html/proofer'
  HTML::Proofer.new(destination, {
    :href_ignore => [/#/, /irc:\/\//],
    :disable_external => true
  }).run
end
