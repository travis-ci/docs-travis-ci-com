# About Travis CI Repository [![Build Status](https://travis-ci.com/travis-ci/docs-travis-ci-com.svg?branch=master)](https://travis-ci.com/travis-ci/docs-travis-ci-com)

This is the documentation site for [Travis CI!](https://docs.travis-ci.com/).
Follow this guide to learn how to add new documentation and how to update existing documentation. 

## Add Documentation

The following are the steps to add documentation.

1. Review the [Travis CI documentation guidelines](/STYLE.md).
1. Check existing documentation. Verify that the documentation does not already exist or look for related documentation that can be enhanced. 
1. Determine proper placement. In the [Travis CI repository](https://github.com/travis-ci/docs-travis-ci-com/tree/master), browse to the *user* folder (or any other specific folder) and create a new branch.
1. Create a new file and add the new documentation files. 
1. Ensure to insert the name and extension for the file.
1. Commit your changes and add a short message to describe your changes.
1. Test the changes locally to verify your edits. 
1. Submit a pull request. Include a clear title and description of the proposed changes, and click “**Create pull request**.”  

Thank you for your contribution! The Travis CI team will review the pull request and approve any necessary changes.

## Update Existing Documentation

If you see a page that needs to be updated or that can be improved, follow these steps to update Travis CI's existing documentation. 

1. Review the [Travis CI documentation guidelines](/STYLE.md).
1. Identify the Travis CI docs page that needs to be updated. 
1. Click the “**Improve this page on GitHub**” button in the top right corner.
1. Once on GitHub, edit the relevant file.
1. Commit your changes. Name your branch, and click the “**Propose changes**” button.
1. Build the docs in a local environment to verify your edits. 
1. Submit a pull request. Ensure a clear title and description of the proposed changes are added, and click “**Create pull request**.”

Thank you for your contribution. The Travis CI team will review the pull request and approve any necessary changes.   


## Build Local Environment

You can inspect how the documentation site will reflect your edits. Follow the steps below to learn how to build your local environment and check all your edits before sending the pull request for approval. 

### Install Dependencies

Follow the steps below to install dependencies.

1. Ensure you have *Ruby* and *RubyGems* installed.

1. Clone the [Travis CI docs](https://github.com/travis-ci/docs-travis-ci-com/tree/master) repository.

1. Install [bundler](http://bundler.io/) as follows:

    ```sh-session
    $ gem install bundler
    ```

1. Next, install application dependencies:

    ```sh-session
    $ bundle install --binstubs
    ```

### Generate Documentation

To generate the documentation, run the following command:

```sh-session
$ ./bin/jekyll build
```

### Run the Application Server

You are ready to start your local documentation site using Jekyll or Puma.
For documentation edits, Jekyll is sufficient.

#### Edit with Jekyll

To start and inspect your edits using Jekyll, follow the steps below:

1. Run the *Jekyll* server:

    ```sh-session
    $ ./bin/jekyll serve
    ```

1. Open [localhost:4000](http://localhost:4000/) in your browser.

#### Edit with Puma

For more programmatical pull requests (such as handling webhooks notifications
via POST), Puma is necessary. To start and inspect your edits using Puma, follow the steps below:

1. Run the *Puma* server:

    ```sh-session
    $ ./bin/puma
    ```

1. Open [localhost:9292](http://localhost:9292/) in your browser.

### API  Documentation

All Travis CI API V2 (and 2.1) documentation is maintained in `slate/source` and generated from the source at build time.

## License

Distributed under the [MIT license](https://opensource.org/licenses/MIT), like other Travis CI projects.
