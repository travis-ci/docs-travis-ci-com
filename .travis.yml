#language: ruby
dist: xenial
language: python
python:
  - "3.5.2"
branches:
  only:
  - master
env:
  global:
    - PATH=$HOME/.local/user/bin:$PATH
    - NOKOGIRI_USE_SYSTEM_LIBRARIES=true # speeds up installation of html-proofer
cache:
  pip: true
  directories:
    - vendor/bundle
    - node_modules
    - $TRAVIS_BUILD_DIR/tmp/.htmlproofer #https://github.com/gjtorikian/html-proofer/issues/381
addons:
  apt:
    packages:
      - libxml2-utils
deploy:
  provider: heroku
  api_key:
    secure: "hylw2GIHMvZKOKX3uPSaLEzVrUGEA9mzGEA0s4zK37W9HJCTnvAcmgRCwOkRuC4L7R4Zshdh/CGORNnBBgh1xx5JGYwkdnqtjHuUQmWEXCusrIURu/iEBNSsZZEPK7zBuwqMHj2yRm64JfbTDJsku3xdoA5Z8XJG5AMJGKLFgUQ="
  app: docs-travis-ci-com
  on:
    branch:
    - master
  edge: true
notifications:
  slack:
    rooms:
      secure: LPNgf0Ra6Vu6I7XuK7tcnyFWJg+becx1RfAR35feWK81sru8TyuldQIt7uAKMA8tqFTP8j1Af7iz7UDokbCCfDNCX1GxdAWgXs+UKpwhO89nsidHAsCkW2lWSEM0E3xtOJDyNFoauiHxBKGKUsApJTnf39H+EW9tWrqN5W2sZg8=
    on_success: never
  webhooks:
    https://docs.travis-ci.com/update_webhook_payload_doc
install:
  - rvm use 2.6.3 --install
  - bundle install --deployment
  - sudo apt-get install libcurl4-openssl-dev # required to avoid SSL errors
script:
  - bundle exec rake test
  - xmllint --noout _site/feed.build-env-updates.xml
