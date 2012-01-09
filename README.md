# About that repository #

This is the documentation site for Travis! (http://about.travis-ci.org)


## How to contribute

Fork the repository, read the rest of this README file, make some changes to Markdown source files,
regenerate HTML. Once your are done with your changes, please fork and make a pull request. Thanks!


## How to edit the site

Make sure you have Ruby and RubyGems installed. Next install [bundler](http://gembundler.com/):

    gem install bundler --pre

Then install dependencies from within the `source` directory:

    cd source
    bundle install

In order to a local Web server that will serve documentation site, run:

    bundle exec nanoc autocompile

and then open [localhost:3000](http://localhost:3000/) in your browser. When you make changes to Markdown source files,
HTML pages will be regenerated on every page reload.

To regenerate the entire site, use

    bundle exec nanoc compile

Note that quoted entities may be escaped or unescaped depending on the Ruby version (1.8 vs. 1.9) used. It is normal.


## License

Distributed under the MIT license, the same as other Travis CI projects.
