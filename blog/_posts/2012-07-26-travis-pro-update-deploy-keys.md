---
title: "Travis Pro Update: Deploy Keys"
layout: post
created_at: thu jul 27 15:55:26 cest 2012
permalink: blog/2012-07-26-travis-pro-update-deploy-keys
author: Mathias Meyer
twitter: roidrage
---
As development on Travis Pro, our continuous integration platform for private
repositories, hums along we thought we'd give you an update on how things are
going and what kind of new features make their way into it.

Last week we rolled out a new feature that's pretty much invisible to the user,
but still important to make Travis Pro more user-friendly: automatic generation
of deploy keys for private GitHub repositories.

Why is this important? Private GitHub repositories can only be accessed using an
SSH key (there's a secret other way to access them, but we don't dare talk about
it in public). If we only rely on a user's SSH key, that would compromise
security by allowing access to all his repositories, so we need to add an SSH
key that's solely for Travis to use.

Until last week, our fall-back was to use a little script that generates a
new deploy key for you and generates a .travis.yml file that includes the key
and instructions on how to manually add it to your GitHub repository.

We were not happy with the fact that it's more work for people to start using
Travis Pro and that it could potentially compromise security should a customer
decide to give an external party only access to a snapshot of the source code
but not to the repository. Accidentally handing over the deploy key might grant
unwanted access to the repository.

So we added a neat feature that automatically generates a deploy key for you and
adds it to the repository, and only this particular repository. You'll get an
email from GitHub notifying you of the fact. When we receive a push from a
repository that doesn't have an SSH key in the .travis.yml or in our system yet,
we generate one and update the repository configuration on GitHub with the new
key.

That way we don't break existing projects that still have a .travis.yml
configured and still allow for you to specify a key in the .travis.yml if you
need to.

Curious about Travis Pro? You can still donate to our [Love
campaign](http://love.travis-ci.org) to get on the fast track to using it before
we launch it to the public! If you donated, just hit us up on
<mailto:support@travis-ci.org>, and we'll get you hooked up!
