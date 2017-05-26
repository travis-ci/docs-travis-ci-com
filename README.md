# About this repository [![Build Status](https://travis-ci.org/travis-ci/docs-travis-ci-com.svg?branch=gh-pages)](https://travis-ci.org/travis-ci/docs-travis-ci-com)

This is the documentation site for Travis CI! (<http://docs.travis-ci.com/>)

## How to contribute

Fork the repository, read the rest of this README file and make some changes.
Once you're done with your changes send a pull request. Thanks!

## How to edit the site

Make sure you have Ruby and RubyGems installed. Next install
[bundler](http://bundler.io/):

```bash
gem install bundler
```

Then install dependencies:

```bash
bundle install --binstubs
```

In order to run a local Web server that will serve documentation site, first generate files:

```bash
export LANGUAGE_FILE_JSON=https://raw.githubusercontent.com/travis-infrastructure/terraform-config/master/aws-production-2/generated-language-mapping.json
curl -O -sfSL $LANGUAGE_FILE_JSON
erb -r json user/common-build-problems.md.erb | tee user/common-build-problems.md
```

then run Jekyll server:

```bash
./bin/jekyll serve
```

and then open [localhost:4000](http://localhost:4000/) in your browser.

To regenerate the HTML pages automatically when you make changes to Markdown source files, use

```bash
./bin/jekyll serve --watch
```

Note that quoted entities may be escaped or unescaped depending on the Ruby
version (1.8 vs. 1.9) used. It is normal.

## License

Distributed under the [MIT license](https://opensource.org/licenses/MIT); the same as other Travis CI projects.

***
