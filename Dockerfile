FROM ruby:2.6.3-slim
LABEL maintainer Travis CI GmbH <support+docs-docker-images@travis-ci.com>

# packages required for bundle install
RUN ( \
   apt-get update ; \
   apt-get install -y --no-install-recommends git make gcc g++ libpq-dev libcurl4-openssl-dev curl \
   && rm -rf /var/lib/apt/lists/* \
)

# ------
# https://github.com/jekyll/jekyll/issues/4268#issuecomment-167406574
# Set the encoding to UTF-8
# -----
# Install program to configure locales
RUN apt-get install -y locales
RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8

# Install needed default locale for Makefly
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
# -----

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN mkdir -p /app

WORKDIR /app
COPY Gemfile      /app
COPY Gemfile.lock /app

RUN gem install bundler
RUN bundler install --verbose --retry=3
RUN gem install --user-install executable-hooks

COPY . /app
RUN bundle exec rake build
COPY . /app

CMD bundle exec puma -p 4000
