FROM ruby:3.2-slim
LABEL maintainer="Travis CI GmbH <support+docs-docker-images@travis-ci.com>"

# packages required for bundle install
RUN ( \
   apt-get update ; \
   apt-get install -y --no-install-recommends git make gcc g++ libpq-dev libcurl4-openssl-dev curl \
   && rm -rf /var/lib/apt/lists/* \
)

# ------
# Set the encoding to UTF-8
ENV LC_ALL=C.UTF-8 \
   LANG=en_US.UTF-8 \
   LANGUAGE=en_US.UTF-8
# -----
ENV WEBHOOK_PAYLOAD_GIST_ID=4e317d6e71be6d0278be46bb751b2f78

# Configure bundler and avoid slate group in this image
ENV BUNDLE_WITHOUT=slate
RUN bundle config set without "$BUNDLE_WITHOUT"
RUN mkdir -p /app

WORKDIR /app
COPY Gemfile.site /app/Gemfile.site

ENV BUNDLE_WITHOUT=slate \
   BUNDLE_GEMFILE=/app/Gemfile.site
RUN gem install bundler:2.4.22 \
   && bundle install --verbose --retry=3
RUN gem install --user-install executable-hooks

COPY . /app
RUN bundle exec jekyll build --config=_config.yml

EXPOSE 4000
CMD ["bundle", "exec", "puma", "-p", "4000"]
