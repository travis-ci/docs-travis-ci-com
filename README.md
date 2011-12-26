# About that repository #

This is the documentation site for Travis! (http://about.travis-ci.org)


## How to contribute

Fork the repository, read the rest of this README file, make some changes to Markdown source files,
regenerate HTML. Once your are done with your changes, please fork and make a pull request. Thanks!


## How to edit the site.

In order to modify contents and launch dev environment, run:

      cd source
      bundle install
      bundle exec nanoc autocompile

and then open [localhost:3000](http://localhost:3000/) in your browser. When you make changes to Markdown source files,
HTML pages will be regenerated on every page reload.
