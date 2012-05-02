---
title: Announcing Pull Requests Support
layout: post
created_at: Tue May 02 18:30:00 CEST 2012
permalink: blog/announcing-pull-request-support
author: Konstantin Haase
twitter: konstantinhaase
---

<figure class="small right">
  [ ![Josh and José at Railsberry](http://farm8.staticflickr.com/7091/7096070433_afc7cb5f43_m.jpg) ](http://www.flickr.com/photos/39342275@N02/7096070433/in/photostream)
  <figcaption>[Josh](https://twitter.com/#!/joshkalderimis) and [José](https://twitter.com/#!/josevalim) at Railsberry</figcaption>
</figure>

Some of our team just got back from two pretty intense weeks of conferencing. We had an amazing time speaking at the [JAX](http://jax.de/2012/), [Railsberry](http://railsberry.com/) and [RailsConf](http://railsconf2012.com/) and getting our hands on two of the [Ruby Hero Awards](http://www.confreaks.com/videos/881-railsconf2012-ruby-hero-awards). A couple of announcements were made live on stage and you might have heard a few rumors coming out of the conferences. So let me wrap up one of them for you.

I'm pretty excited about this one, as I've been working on it over the last weeks. This is the first feature to be sponsored by our impressing [Love Campaign](https://love.travis-ci.org/). While the [promise](https://love.travis-ci.org/#languages) of adding [more](http://about.travis-ci.org/blog/first_class_nodejs_support_on_travis_ci/) [languages](http://about.travis-ci.org/blog/first_class_php_support_on_travis_ci/) [actually](http://about.travis-ci.org/blog/announcing_support_for_java_scala_and_groovy_on_travis_ci/) [came](http://about.travis-ci.org/blog/announcing_python_and_perl_support_on_travis_ci/) [true](http://about.travis-ci.org/blog/announcing_support_for_haskell_on_travis_ci/), this was mainly done by excellent community contributions and the hard working [Michael Klishin](http://twitter.com/michaelklishin).

## How We Use Pull Requests

<figure>
  [ ![A typical Pull Request](http://travis-pr.herokuapp.com/image/slides/pull-request.png) ](http://travis-pr.herokuapp.com/image/slides/pull-request.png)
  <figcaption>A typical Pull Request</figcaption>
</figure>

When Github first announced [Pull Requests 2.0](https://github.com/blog/712-pull-requests-2-0), it wasn't obvious right away how truly amazing this feature is for us developers.

<figure class="small right">
  [ ![Pull Request 2.0 Workflow](http://travis-pr.herokuapp.com/image/slides/pre-merge-button.png) ](http://travis-pr.herokuapp.com/image/slides/pre-merge-button.png)
  <figcaption>Pull Request 2.0 Workflow</figcaption>
</figure>

It revolutionized the workflow by making the patches part of the discussion. This actually led to code reviews from other contributors while working on a feature, rather than once you think you're done working on it.

Think of it as bringing [agile development](http://agilemanifesto.org/) to Open Source contributions. Wikipedia even calls this new and social approach [The GitHub revolution](http://en.wikipedia.org/wiki/History_of_free_and_open-source_software#The_GitHub_revolution).

It really only had one downside: Merging still was as complicated as before. You have all the fancy review tools and still have to go into the terminal and type a couple of commands. This quickly became rather tedious.

## The Merge Button

<figure>
  [ ![GitHub's Merge Button allows merging Pull Request form the Web Interface](http://travis-pr.herokuapp.com/image/slides/merge_button.png) ](http://travis-pr.herokuapp.com/image/slides/merge_button.png)
  <figcaption>GitHub's Merge Button allows merging Pull Request form the Web Interface</figcaption>
</figure>

GitHub, once more, came to our rescue by adding the [Merge Button](https://github.com/blog/843-the-merge-button).

<figure class="small right">
  [ ![The Merge Button Workflow](http://travis-pr.herokuapp.com/image/slides/pre-travis.png) ](http://travis-pr.herokuapp.com/image/slides/pre-travis.png)
  <figcaption>The Merge Button Workflow</figcaption>
</figure>

By pressing a button on the website, one could easily merge Pull Requests without having to drop to the console.

This feature, combined with the [Fork and Edit](https://github.com/blog/844-forking-with-the-edit-button) button, made contributing a no brainer.

Especially the roundtrip time for documentation fixes, like typos, broken examples, etc. went down to sometimes just a few seconds.

Contributing a fix became as simple as two clicks on GitHub. Making contributions that easy lowers the barrier and thereby strengthens the Open Source ecosystem.

You probably can tell by now how much we love this feature.

<figure class="small left">
  [ ![The Merge Button is a dangerous tool, trust Boromir.](http://travis-pr.herokuapp.com/image/slides/one-does-not-pull-request.jpg) ](http://travis-pr.herokuapp.com/image/slides/one-does-not-pull-request.jpg)
  <figcaption>The Merge Button is a dangerous tool, trust Boromir.</figcaption>
</figure>

There is a downside, though. The Merge Button is not really usable for anything but documentation.

If you click the Merge Button for anything touching code, you risk breaking upstream. Maybe this seem acceptable at first, after all your CI will tell you if you broke anything. You are using CI, right?

However, it not only renders your mainline pretty unstable, it also changes responsibility. All of a sudden you as a maintainer are responsible for fixing the issue, if only by reverting the commits.

So you're back at merging locally and checking out if everything works. Maybe you even push on a feature branch first, just to trigger a CI run before merging.

## Enter Travisbot

<figure class="small right">
  [ ![The Perfect&trade; Workflow](http://travis-pr.herokuapp.com/image/slides/with-travis.png) ](http://travis-pr.herokuapp.com/image/slides/with-travis.png)
  <figcaption>The Perfect&trade; Workflow</figcaption>
</figure>

It would be really cool to just know if the Pull Request breaks anything, without all the hassle.

This is basically what we've implemented. We test every mergeable Pull Request and have our friendly [Travisbot](https://github.com/travisbot) leave a comment in the Pull Request discussion.

That way you can now safely press the Merge Button. That is, if it doesn't break anything, of course. And if it breaks, it's not necessarily the maintainers (or worse, the users) responsibility to deal with the issue.

Or imagine having a broken upstream and someone submits a Pull Request fixing it.

<figure>
  [ ![Post-Merge Button Workflow](http://travis-pr.herokuapp.com/image/slides/travisbot.png) ](http://travis-pr.herokuapp.com/image/slides/travisbot.png)
  <figcaption>Pre-Merge Button Workflow</figcaption>
</figure>

In contrast to most [self-made solutions](https://github.com/cramerdev/jenkins-comments) out there, we actually test the *merged* version, rather than just the fork or feature branch. Thus, we also take into account changes made upstream *after* the repository has been forked.

We will also re-run the tests whenever new commits are added to a Pull Requests (yes, this works fine with force pushes and rebases). Also, it pretty much works with anything that is mergeable, might it be a branch, tag, fork, etc. As long as you see the green Merge Button, we can test it.

## Are we there yet?

This feature is still under development. The described functionality works just fine, but we have plans for future extensions.

For instance, we would like to leave a comment whenever master is updated and give you the option to automatically rerun the tests with the new merge commit.

## I WANT THIS NOW!!

If you made it this far in the blog post, you probably want it for your repository, and you want it *now*. Good news! We started unrolling this feature.

<figure class="small right">
  [ ![Let us know if you want this feature](https://img.skitch.com/20120502-xmjnfsk2bfjkwabk5y2ra6dtfi.jpg) ](https://img.skitch.com/20120502-xmjnfsk2bfjkwabk5y2ra6dtfi.jpg)
  <figcaption>Let us know if you want this feature</figcaption>
</figure>

As we are still improving it, and are not sure if we can stand the load of activating it for everyone right away, we are turning it on on a repo per repo basis.

Please note that we start unrolling for those people, that donated, so I was actually able to work on this. So, if you donated and want this, just [let us know](mailto:contact+pr@travis-ci.org?subject=Pull Request Support&body=Could you please activate PR testing for USER/REPO? I donated - Order #XYZ - and would love to use this feature. XOXO - NAME).

If you didn't donate, but still want to use this feature, our [Love Campaign](https://love.travis-ci.org/) is still running.