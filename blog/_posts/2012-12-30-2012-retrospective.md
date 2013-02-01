---
title: "2012 at Travis CI - what a blast!"
created_at: Sun Dec 30 12:00:00 CET 2012
layout: post
author: Sven Fuchs
twitter: svenfuchs
permalink: blog/2012-12-30-2012-at-travis-ci-what-a-blast
---

When I started collecting some facts for this year's retrospective, I couldn't
believe how many fanstastic, game-changing and also humbling things have
happened in just a single year.

If Travis CI has been a toddler when [Josh](http://github.com/joshk) and I
started touring conferences in 2011 to tell everyone about the idea and vision
then in 2012 it was a kid growing up, going through some heavy duty rock'n'roll
and all night party times.

In 2011 the [initial experiments](http://svenfuchs.com/2011/2/5/travis-a-distributed-build-server-tool-for-the-ruby-community)
formed into a vision: We wanted Travis CI to be for tests and builds what
RubyGems is for distribution. But not just for Ruby, for any language. We
wanted to target Open Source code first. And we wanted dead-easy and public
continuous integration to become a standard for Open Source.

Over time we got more and more serious, also because we got such great and
encouraging feedback. Since we were quite limited on resources, we've had to
adhere to a "build the simplest thing possible" rule pretty strictly. The
result was a rather simple app that showed an exciting vision, but also already
proved useful enough for people to rely on on a daily basis.

Then in 2012 Travis CI saw [rapid growth](http://about.travis-ci.org/blog/2012-12-17-numbers/).
It became obvious that we'd need a much better foundation, so we could scale
things out with the exploding demand.  We've collected some money from the
[crowdfunding campaign](https://love.travis-ci.org). This allowed us to grow
our team and implement the things we've promised to build.


### What we've been working on in 2012

Here's what we've been doing in 2012 in terms of code:

[![travis activity 2012](http://s3itch.svenfuchs.com/travis-activity-20121230-011533.jpg)](http://travis-activity.herokuapp.com/stats)

If you're really interested you can [play around](http://travis-activity.herokuapp.com/stats)
and add/remove team members, repositories or change the scale. I've built this little
app to get a good overview for this retrospective.

You can see nicely how the crowdfunding campaign (orange) took quite a few
resources in the first weeks of the year, but then zeroed out. Instead we
started working on Travis CI Pro (blue) which took a huge part, and still does.
In addition, somewhere around June we started working on the new Ember.js web
client as well as the new API (yellow, see below) and split up the app more and
more (red) towards the end of the year.

And if you really want to stalk us more then you can find even more detailed information
[in a feature list](https://gist.github.com/0f0ede41b07653810fd1) and
[a summary of our commit history](https://gist.github.com/f7e81d3b92505ee3c3a7).

Haha, don't worry. I'm going to sum it all up for you. :)


### The Travis Crowdfunding "Love" Campaign

Conceiving, planning, designing, realizing and launching the crowdfunding
campaign including the [Stripe](https://stripe.com) payment integration,
founding a company (so we could legally accept money), production of
ringtones and a few rounds of private feedback from fellow developers took
about two months in total, one developer mostly.

We were already amazed by the fantastic amount of support and great feedback
that we were getting while we were putting the campaign together. But when the
site went live in February and raised a remarkable amount of money in no time,
we were just blown away and plain humbled.

If you have a spare minute then please take the time to review our fantastic
sponsors and the amazing list of private donors.

The overall revenue of the crowdfunding campaign to date amounted to roughly
125,000 USD. Without this money Travis CI would not be what it is today.

There's so much to say about the crowdfunding campaign that doesn't fit into
this post. We'll write it up. Expect a more detailled summary early next year.


### The Travis Team

In the course of 2012 the team behind Travis CI has more than doubled.

If you go to Berlin and ask around who people would really like to work with -
who do you think would be on the list? I'm obviously biased, but I'm sure
Konstantin and Mathias would rank very high within the Ruby community.

To say the very least, we were super happy that with
[Konstantin](https://twitter.com/konstantinhaase) and [Mathias](https://twitter.com/roidrage)
two of the best Ruby developers we know joined the team in January full time.
It took us a while to change the company contract and fully get them on board,
but finally in April we were all set. They've changed the face of Travis CI
entirely. Having these guys join the team was the best thing that could happen
to the project.

![travis team in oniesies](http://s3itch.svenfuchs.com/travis-team-in-onesies-20121230-194350.jpg)

Then in March and April one of our earliest and most supportive sponsors,
[Enterprise Rails](http://www.enterprise-rails.com/), sponsored Lucas to work
on Travis CI on a halftime position, fixing bugs and adding features.
[Lucas](https://twitter.com/medk_) is a Rails developer at Avarteq (and an
active coach in the [Railsgirls Berlin](http://railsgirlsberlin.de) group,
[high five](http://ihighfive.com)!) and helped us a lot, fixing bugs and adding
features.

In October [Engine Yard](http://www.engineyard.com) started sponsoring a
fulltime position for Piotr in the most [broadminded
way](http://about.travis-ci.org/blog/2012-10-22-engine-yard-sponsors-piotr-sarnacki-to-work-on-travis),
as part of their Open Source Grant program. [Piotr](https://github.com/drogus)
is a fantastic Ruby developer. He has been active as a Rails core member and
worked on distributed applications, as well as Ember.js based clients in the
past, so he was the perfect addition to our team. We are super happy to have
him on board, and super thankful for Engine Yard's sponsorship!

[Michael](https://twitter.com/michaelklishin), one of the first members on the
team, luckily was able to continue to maintain our VM cookbooks, one of the
most important and mature components of the system, in the most dilligent and
trusty way.

We'd also like to mention [Henrik](https://twitter.com/henrikhodne), who's done some tremendous work on community
support, tickets and a lot of bug fixing over the last months. He's also built
the Mac OS X toolbar ["watcher" app](https://github.com/travis-ci/travis-watcher-macosx) for Travis CI
as well as [Travis Lite](http://travis-lite.com), an alternative, light-weight
web client for the Travis API.


### More languages, pull request support, secure env vars and build artefacts

One year ago, Travis CI offered native support for [six languages](https://github.com/travis-ci/travis-build/tree/d90c1ebd7f2199451bf941c2a5f4a17fc6386c49/lib/travis/build/job/test):
Clojure, Erlang, Node.js, PHP, Ruby and Scala. Today we are proud to say that
(after adding C/C++, Go, Groovy, Haskell, Java, Perl and Python) there is
native support for [14 different languages](https://github.com/travis-ci/travis-build/tree/90644d14cb14cf886dfb61586bad81c78bb7abd4/lib/travis/build/job/test)
on Travis CI, including support for JVM switching and a generic JVM language
builder. Besides these officialy supported languages, there are also projects
testing EMACS Lisp, Smalltalk, Bash and [many other languages](http://about.travis-ci.org/blog/2012-12-17-numbers/#Programming-Languages)
on Travis CI.

We believe this is huge.

Next to that, the most exciting and popular new feature on Travis CI is
the [pull request support](http://about.travis-ci.org/blog/announcing-pull-request-support)
and later the tight [integration with GitHub's UI](http://about.travis-ci.org/blog/2012-09-04-pull-requests-just-got-even-more-awesome/),
that has been added. Konstantin has done an amazing job at this, also adding a
new [layered GitHub API client](https://github.com/rkh/gh) that now makes our
life much easier at Travis CI.

Then later this year, Piotr added two more features that gave tremendous
value to Travis CI, as they open up an entire new space of usecases and
possibilities: [secure env vars](http://about.travis-ci.org/docs/user/encryption-keys)
(so users are now able to add sensitive data to their public .travis.yml config
files) and (building on that) [build artefacts](http://about.travis-ci.org/blog/2012-12-18-travis-artifacts).


### Pure JS client and a shiny new API v2

If something is broken and then gets fixed we tend to entirely forget about
that unfortunate previous situation because we're so happy with the new one. However,
we still remember how many issues we had with both the old API and the old JS
browser client.

We've started working on a new Travis CI web client in early June and a new [Sinatra](http://www.sinatrarb.com/)
based API app shortly after that. Since we also had to tackle so many other
things in parallel, the whole thing wasn't ready to launch into beta
[until October](http://about.travis-ci.org/blog/2012-10-23-introducing-travis-cis-next-generation-web-client).

But we were super happy with the result, as it's all much faster, much
easier to maintain and add features to it. We've since ported the client to
[Travis CI pro](http://about.travis-ci.org/blog/2012-11-27-shipping-the-new-travis-ci-ui-for-pro)
and fixed a good number of edge cases around the new JS based OAuth sign-in
process.


### Travis Hub and the army of apps

One year ago Travis CI consisted of a web app, a bunch of worker machines and a
central message crunching app called Hub. Today there's an entire small army of
apps that all share their their part in getting your builds run:

- [Listener](http://github.com/travis-ci/travis-listener) picks up requests from 
GitHub (created Dec 2011).
- Gatekeeper configures them and takes care of syncing user data with GitHub (Oct 2012).
- Enqueue queues build jobs based on a rate limiting strategy (Oct 2012).
- [Hub](http://github.com/travis-ci/travis-hub) still is a central node that picks up state 
changes and triggers events.
- [Tasks](http://github.com/travis-ci/travis-tasks) sends out notifications to external targets 
(like Email, IRC, Campfire etc., created Aug 2012).
- [Logs](http://github.com/travis-ci/travis-logs) does nothing else but processing logs that 
are streamed over from the workers (Aug 2012).

There are also other apps for serving the static [web client](http://github.com/travis-ci/travis-web) and
serving the [HTTP API](http://github.com/travis-ci/travis-api).
Moreover, we created other tools for things like
[administration](https://github.com/travis-ci/travis-admin),
[single sign on](https://github.com/travis-ci/travis-sso),
[worker maintenance](https://github.com/travis-ci/travis-boxes) and so on ...

Breaking up Travis CI into lots of tiny apps that communicate via AMQP, [Sidekiq](http://sidekiq.org/)
and HTTP made it much easier to scale things out, spot issues related to a
certain aspect but also work in parallel without accidentally stepping on each
other's work.


### Automation and Visibility

Even with the rather simple setup we had a year ago, when things went wrong it
often turned out to be quite hard to tell what's actually going on in the
system. That situation would not get any better once we'd split things up
into separate components even more.

Being the devops hero he is Mathias immediately jumped at tackling that
situation.  He changed and cleaned up the way our apps write [log output](https://github.com/roidrage/lograge),
centralized them in [Papertrail](http://papertrailapp.com), added metrics
everywhere, piped them through the logs to [Librato](http://librato.com) so
we'd get some pretty graphs and assembled them on a nice dashboard.

![metrics everywhere](http://s3itch.paperplanes.de/graphs-20121024-182007.png)

Over the next months the situation improved step by step and we're now able
to tell [what's happening](http://about.travis-ci.org/blog/2012-10-24-finding-your-soul-metric)
and [isolate issues](http://about.travis-ci.org/blog/2012-09-24-post-mortem-pull-request-unavailability)
rather quickly even though our app now consists of many more components.



### Travis Pro

And finally, we've worked **a lot** on turning this platform into a paid
service so we could eventually allow everyone who had been asking for this to
give us their money ... so we could continue providing this service for Open
Source for free and also make it even better, more useful and exciting.

Obviously we can't talk much about the exactly way this was realized, but we
are able to re-use quite a bit of the code that is also powering the OSS
version of the platform. The two services are entirely separated and share no
resources other than code though.

Figuring out all these bits and pieces took quite a bit of work. Mathias has
been working (next to lots of other things, but still) 2.5 months on
integrating payments, coupons, billing etc. alone. A bunch of things need to
work in a slightly different way for the private service, so lots of
adjustments had to be made.

We're still in a closed, private beta and we have a number of big improvements
in the pipeline before we'll be able to entirely open the service. But we can
say proudly that our users are already pretty happy with it, given the
[feedback](http://about.travis-ci.org/blog/2012-10-25-the-travis-plans/#What-Existing-Customers-Are-Saying)
we have.


### What's up for next year

In 2013 we will mostly continue the path that we've taken in 2012 and improve
the existing service. Reliability, flexibility and robustness are on the top of
our list. Further improvements to usability and performance, adding missing
features and further build the community around Travis CI are other goals on
that list.

But we also want to look into fields that we haven't quite touched much, yet,
like simplifying support for continuous deployment and other automation steps
or adding an API for third party apps. We have some great ideas in this space,
so be excited :)

Obviously our main priority has to be put on shipping Travis CI pro, so
we'll be able to pay our bills and continue to support Travis CI as an open and
free service for the Open Source community. But in order to have some more free
resources for this we will also look into follwing up on the crowdfunding
campaign for the next year. Expect to hear more about this soon.

So, if 2011 was the year of birth of the Travis CI project and 2012 was the
year of its childhood and youth, we hope that we can make 2013 the year of
growing Travis CI up to stabilize as the most useful, efficient and well
supported continuous integration platform out there.

We are super excited and looking forward to working with you and we are
extremely thankful to be able to be part of an amazing project and a fantastic
community like this.


### Thank you all for a fantastic year!

2012 was a blast. Thank you so much.

Love you all :)




