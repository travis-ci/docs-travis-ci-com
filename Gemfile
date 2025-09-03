source 'https://rubygems.org'

ruby '~> 3.2'

gem 'faraday'
gem 'html-proofer', '~> 3.0'
gem 'jekyll', '~> 4.3'
gem 'jekyll-paginate'
gem 'jekyll-redirect-from'
gem 'puma'
gem 'pry', group: :test
gem 'rack', '~> 3.0'
gem 'rack-ssl-enforcer'
gem 'rake'
gem 'rdiscount', '>=2.2.0.1'
gem 'rubocop', group: :test


# All of this is for Slate / middleman

gem "middleman", '~> 4.6'

# For syntax highlighting
gem "middleman-syntax"

# Plugin for middleman to generate GitHub pages
gem 'middleman-gh-pages'

# Live-reloading plugin
gem "middleman-livereload"

# Needed for Slate / middleman
gem 'redcarpet'

gem 'mini_racer', :platforms => :ruby

# Remove warnings according to https://github.com/Compass/compass/pull/2088
git 'https://github.com/ably-forks/compass', branch: 'sass-deprecation-warning-fix', ref: '3861c9d' do
  gem 'compass-core'
end

group :dpl do
  gem 'dpl', git: 'https://github.com/travis-ci/dpl'
  gem 'cl'
end

gem 'netrc'
