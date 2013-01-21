---
title: "More CLI tricks"
created_at: Mon Jan 21 22:20 CET 2013
layout: post
author: Konstantin Haase
twitter: konstantinhaase
permalink: blog/2013-01-21-more-cli-tricks
---

Just a few days ago, we [announced our new command line client](http://about.travis-ci.org/blog/2013-01-14-new-client/).
We just did a new release, and are proud to announce that it learned a few new tricks.

<figure>
  ![Most of the commands that were part of the new travis gem release.](/images/new-tricks.png)
  <figcaption>Most of the commands that were part of the new `travis` gem release.</figcaption>
</figure>

These are the commands that shipped with today's **1.1.0 release**:

* `console` - opens up a pry console with the travis gem loaded, authentication taken care of, and all constants imported
* `disable` - disables a project, but why would you want that?
* `enable` - enables a project, now we're talking
* `encrypt` - encrypts strings with the project's public key
* `endpoint` - displays the API endpoint
* `help` - gives you more infos
* `history` - displays the project history, filter with `--branch` or `--pull-request`
* `login` - authenticates you
* `logs` - displays logs for a given job number
* `open` - opens the repository, a build or a job on Travis or GitHub
* `raw` - let's you play with the API payloads directly
* `restart` - restarts a build or a job
* `show` - displays a build or a job
* `status` - displays the current project state, use `-pqx` for shell scripting galore
* `sync` - triggers a new sync between Travis CI and GitHub
* `version` - well... you know, the version
* `whatsup` - tells you what's going on on Travis
* `whoami` - in case you forgot who you are (or want to check if you're logged in)

Additionally, the underlying [Ruby library](https://github.com/travis-ci/travis#ruby-library) has seen a lot of improvements, check out the [documentation](https://github.com/travis-ci/travis#readme).

Now get excited and make things.
