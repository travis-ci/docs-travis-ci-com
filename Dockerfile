FROM ruby:2.6.3-slim
LABEL maintainer Travis CI GmbH <support+docs-docker-images@travis-ci.com>

# packages required for bundle install
RUN ( \
   apt-get update ; \
   apt-get install -y --no-install-recommends git make gcc g++ libpq-dev libcurl4-openssl-dev \
   && rm -rf /var/lib/apt/lists/* \
)

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN mkdir -p /app

WORKDIR /app
COPY Gemfile      /app
COPY Gemfile.lock /app
COPY Rakefile     /app

RUN gem install bundler
RUN bundler install --verbose --retry=3
RUN gem install --user-install executable-hooks
RUN bundle exec rake build

COPY . /app

CMD bundle exec puma -p 4000
