---
title: "Pull Request Testing For Everyone"
layout: post
created_at: wed aug 08 19:00:00 cest 2012
permalink: blog/pull-request-testing-for-every
author: Konstantin Haase
twitter: konstantinhaase
---

Two months ago we [announced support for Pull Request testing](/blog/announcing-pull-request-support). Since then, you've managed to keep [The Travis Bot](https://github.com/travisbot) quite busy.

We just started unrolling an updated version and are under way of enabling it for everybody.

<figure class="small right">
  [ ![Sven working hard on Travis CI](http://farm8.staticflickr.com/7225/7334422306_98400fd1a6_z.jpg) ](http://www.flickr.com/photos/khaase/7334422306/in/photostream)
  <figcaption>[Sven](https://twitter.com/svenfuchs) working hard on Travis CI</figcaption>
</figure>

### Private Projects

Up until now, Pull Request testing was only available for Open Source projects. We had to make some adjustments to Travis CI and are proud to announce the availability for [private projects](http://travis-ci.com/).

We enabled the feature for all repositories already set up on "Travis Pro". Please swing by our [support channel](https://travisci.campfirenow.com/10e50) if you are having issues.

If you want to see our bot leave comments on your Pull Requests, you will have to give [travisbot](https://github.com/travisbot) read access to the repository. Otherwise you will have to check the Pull Request tab in the Travis CI interface.

A new way of communicating the outcome is in the makings, stay tuned.

### Pull Requests for Branches

We found that especially for private or large projects, Pull Requests often come from a different branch within the same repository. You might be wondering what advantage Pull Request testing actually gives you in this scenario. Branches are already being tested for you, so what's the difference?

Keep in mind that a Pull Request test will actually reflect the status of the *merged* Pull Request. Imagine working on a feature branch for a while and in the meantime, `master` gets updated. A Pull Request test will now reflect the state after you've pressed the Merge Button. This is also why only mergeable Pull Requests will be tested.

### Open Source Projects

After getting participants of our [Love Campaign](https://love.travis-ci.org/) on board, we will now start enabling it for the rest of the nearly [18k Open Source projects](http://travis-ci.org/stats) using Travis CI. Current plans are to enable it in batches, probably on the scale of 500 to 1000 repositories per batch, so we can see how much more load this will cause. The first batch will be enabled tomorrow and we plan to enable one more batch every morning.

### No More Race Condition

Our initial release had a high level race condition. Basically, if your project was too busy, you could see a failing test with an error message like this:

    $ git checkout -qf 8ad4fb8f248e00c8e86c
    fatal: reference is not a tree: 8ad4fb8f248e00c8e86c

That happened mostly if a merge commit changed due to the base branch being updated while some but not all of your build's jobs already ran. We started deploying the fix to our worker machines and within 24 hours the fix should be available on all machines. If you want to know more, we invite you to read [the full story](https://github.com/travis-ci/travis-build/pull/26).