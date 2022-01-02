# About this repository [![Build Status](https://travis-ci.com/travis-ci/docs-travis-ci-com.svg?branch=master)](https://travis-ci.com/travis-ci/docs-travis-ci-com)

This is the documentation site for Travis CI! (<https://docs.travis-ci.com/>)

## How to contribute

Fork the repository, read the rest of this README file and make some changes.
Once you're done with your changes send a pull request. Thanks!

## How to check your edit before sending PR

You can inspect how your edits will be reflected by the documentation site. Either by clicking on the Netlify preview link in your Pull Request or building the docs locally.

### Install dependencies

1. Make sure you have Ruby and RubyGems installed.

1. Install [bundler](http://bundler.io/):

    ```sh-session
    $ gem install bundler
    ```

1. Install application dependencies:

    ```sh-session
    $ bundle install --binstubs
    ```

### Generate documentation

Run

```sh-session
$ ./bin/jekyll build
```


### Run application server

You are now ready to start your documentation site, using Jekyll or Puma.
For documentation edits, Jekyll is sufficient.

#### Starting and inspecting edits with Jekyll

1. Run Jekyll server:

    ```sh-session
    $ ./bin/jekyll serve
    ```

1. Open [localhost:4000](http://localhost:4000/) in your browser.

#### Starting and inspecting edits with Puma

For more programmatical PRs (such as handling webhooks notification
via POST), Puma is necessary.

1. Run Puma server:

    ```sh-session
    $ ./bin/puma
    ```

1. Open [localhost:9292](http://localhost:9292/) in your browser.

### API V2 documentation

API V2 (and 2.1) documentation is maintained in `slate/source` and is generated at build time from source.

## License

Distributed under the [MIT license](https://opensource.org/licenses/MIT); the same as other Travis CI projects.
