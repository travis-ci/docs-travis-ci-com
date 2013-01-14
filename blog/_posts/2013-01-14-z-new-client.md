---
title: "New Client"
created_at: Tue Jan 14 17:30 CET 2013
layout: post
author: Konstantin Haase
twitter: konstantinhaase
permalink: blog/2013-01-14-new-client
---

Up until now, using secure environment variables for private projects was not the most pleasant experience. This was due to our command line client not being able to talk to [Travis Pro](http://travis-ci.com).

We are happy to announce that this has been fixed. Not by hacking something into the old client, which was more or less just a collection of [Thor](https://github.com/wycats/thor) scripts, but by completely rewriting it. Right now the [new client](https://github.com/travis-ci/travis) doesn't do that much more besides encrypting things, but we hope that this will change in the future.

### Setting it up

If you still have the old client installed, we recommend you do

    gem uninstall travis-cli

As with any gem, run

    gem install travis

That's it for public repos. If you want to use it for your private projects, you'll need to login:

    travis login --pro

You can verify if you're already logged in by running

    travis whoami --pro

### Encrypting things

If you're in your projects directory (or a sub directory), you can simply run `encrypt` with the string you want encrypted. Some fancy features include piping into encrypt (handy for encrypting deploy keys etc) and using `--add` to automatically add it to your `.travis.yml`.

<figure>
  ![Encrypting Things](/images/encrypt.png)
  <figcaption>Using the new CLI to encrypt a text file</figcaption>
</figure>

### A Ruby library

The new client ships with a Ruby library it uses internally.

For instance, the following [script](https://github.com/travis-ci/travis/blob/master/example/org_overview.rb):

<script src="https://gist.github.com/4531148.js"></script>

Will print something like this:

    travis-ci/travis passed
    travis-ci/travis-boxes passed
    travis-ci/travis-worker failed
    travis-ci/travis-build passed
    travis-ci/travis-api passed
    travis-ci/travis-web passed
    ...

### What's next?

We want the Ruby library to reach 100% coverage of our API. Thus anything the web front end can do - and potentially more - will in the future be possible with this library. We would also love to add more functionality to the command line client, check out our [TODO list](https://github.com/travis-ci/travis#todo) to see what we have planned.

Needless to say, this client is fully Open Source, so any contributions are very much welcome!

PS: It also runs on Windows!
