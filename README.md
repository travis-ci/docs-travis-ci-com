# About this repository #

This is the documentation site for Travis CI! (http://docs.travis-ci.com/)

## How to contribute

Fork the repository, read the rest of this README file and make some changes.
Once you're done with your changes send a pull request. Thanks!

## How to edit the site

Make sure you have Ruby and RubyGems installed. Next install
[bundler](http://bundler.io/):

    gem install bundler

Then install dependencies:

    bundle install --binstubs

In order to run a local Web server that will serve documentation site, run:

    ./bin/jekyll serve

and then open [localhost:4000](http://localhost:4000/) in your browser. 

To regenerate the HTML pages automatically when you make changes to Markdown source files, use

    ./bin/jekyll serve --watch

Note that quoted entities may be escaped or unescaped depending on the Ruby
version (1.8 vs. 1.9) used. It is normal.

## License

Distributed under the MIT license, the same as other Travis CI projects.
