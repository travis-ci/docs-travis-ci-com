---
title: Pull Requests Just Got Even More Awesome
author: Mathias Meyer
twitter: roidrage
permalink: blog/2012-08-27-pull-requests-just-got-even-more-awesome
layout: post
---
Just short of four months ago, we [announced the availability of pull request
testing](http://about.travis-ci.org/blog/announcing-pull-request-support/) on
Travis CI. Just recently we [announced the availability of pull requests for
everyone](http://about.travis-ci.org/blog/pull-request-testing-for-everyone/)
and all of their projects by default.

Since then, [travisbot](https://github.com/travisbot) has been busy, very busy,
leaving comments on your pull requests, helping you in making a fair judgement
of whether a pull request is good to merge or not.

Today, and largely thanks to the fine folks over at GitHub, pull requests are
getting even more awesome. Instead of relying on travisbot to comment on pull
requests to notify you of the build status, pull requests now have first class
build status support.

What does that mean? A picture says more than thousand words. Here's how every
pull request looks like when it's successfully built on Travis CI. All green,
good to merge!

![Successfully built pull request](http://s3itch.paperplanes.de/Fullscreen-13-2-20120827-214248.png)

It is just as awesome as it looks. But you should try for yourself immediately!
When a new pull request comes in, we start testing it right away, marking the
build as pending. You don't even have to reload the pull request page, you'll
see the changes happen as if done by the magic robot hands of travisbot himself!

![Pending pull request](http://s3itch.paperplanes.de/Fullscreen-14-3-20120827-214334.png)

Should a pull request fail the build, as unlikely as it may seem, you'll see a
warning that warns you about merging this pull request. This is true for a
pending build as well. They're both marked as unstable. You can merge it, but
you do so at your own risk. After all, isn't it nicer to just wait patiently for
that beautiful green to come up? We thought so!

![Failed, oh noes!](http://s3itch.paperplanes.de/Fullscreen-12-1-20120827-214117.png)

In all three scenarios, there's a handy link included for you, allowing
you to go to the build's page on Travis to follow the test log in awe while you
wait for the build to finish. Just click on "Details" and you're golden!

There is a neat feature attached to this. The build status is sneakily not
attached to the pull request itself, but to the commits included in it. As a
pull request gets more updates over time, we keep updating the corresponding
commits, building up a history of failed and successful commits over time. This
is particularly handy for teams who iterate around pull requests before they
ship features.

Let's have a look at what Josh has been up to in this pull request. Notice the
little bubbles next to each commit reference.

![Josh](http://s3itch.paperplanes.de/joshk-20120827-215347.png)

The great news is that this awesome feature has been active on Travis CI for a
while now, meaning hundreds of existing pull requests will immediately have a
build status attached and displayed in the user interface. This is true for open
source projects on [Travis CI](http://travis-ci.org) and for private projects on
[Travis Pro](http://travis-ci.com).

Now, the bad news is that this will mean that travisbot is going to retire from
commenting on your pull requests soon. You all learned to love him just as much
as we do, and he might just have a comeback at some point in the future. Until
then, he'll be hanging out in our Campfire room, enjoying a little less chatter
around him.

Thank you, GitHub!
