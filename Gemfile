source 'https://rubygems.org'

ruby '2.6.3'

gem 'faraday'
gem 'html-proofer', '~> 3.0'
gem 'jekyll', '>=3.1.6'
gem 'jekyll-paginate'
gem 'jekyll-redirect-from'
gem 'puma'
gem 'pry', group: :test
gem 'rack-jekyll'
gem 'rack-ssl-enforcer'
gem 'rake'
gem 'rdiscount', '>=2.2.0.1'
gem 'rubocop', group: :test


# All of this is for Slate / middleman

gem "middleman"

# For syntax highlighting
gem "middleman-syntax"

# Plugin for middleman to generate GitHub pages
gem 'middleman-gh-pages'

# Live-reloading plugin
gem "middleman-livereload"

# Needed for Slate / middleman
gem 'redcarpet'

# Cross-templating language block fix for Ruby 1.8
platforms :mri_18 do
  gem "ruby18_source_location"
end

gem 'therubyracer', :platforms => :ruby

# Remove warnings according to https://github.com/Compass/compass/pull/2088
git 'https://github.com/ably-forks/compass', branch: 'sass-deprecation-warning-fix', ref: '3861c9d' do
  gem 'compass-core'
end

group :dpl do
  gem 'dpl', git: 'https://github.com/travis-ci/dpl'
  gem 'cl'
end

gem 'netrc'
