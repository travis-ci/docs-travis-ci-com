---
title: "Post-Mortem: Build Outage and Security Advisory"
author: Mathias Meyer
twitter: roidrage
created_at: Thu Jan 31 2013 13:00:00 CET
permalink: blog/2013-01-31-post-mortem-build-outage
layout: post
---
Yesterday a security vulnerability was detected on RubyGems.org, hosting
provider for Ruby packages. An attacker exploited a vulnerability in the YAML
parsing process for gem definitions to access sensitive information on the
RubyGems.org servers.

The issue was reported to the [Psych YAML
library](https://github.com/tenderlove/psych/issues/119) earlier this month.
**Please be aware that if you use Psych, which is part of the Ruby standard
library, anywhere in your applications to parse YAML files from external
sources, your application is vulnerable to this issue as well.**

This attack had wider consequences for us than we initially thought, and we soon
discovered that Travis CI is vulnerable to attacks parsing YAML files as well.
Independent from our investigation, we were notified by Michael Fairley and
Jonathan Rudenberg. Thank you guys for the responsible disclosure!

Build processing on both platforms was stopped and was down a long time, our
longest build outage so far. We're incredibly sorry for the inconvenience.

We had to take this drastic measure as Heroku *rightfully* disabled new deployments 
accessing external resources for any new RubyGems that might be required for the
deployment. Heroku did this in order to protect their users and we are grateful for it
since we potentially might have underestimated the extend of this part of the issue at that point.
Also, we decided to not deploy anything before there's a positive sign from Rubygems ...
in order to protect our own users.

### The vulnerability

The majority of projects on Travis CI include a .travis.yml file which contains
instructions on the build, like the language environment, commands to run during
the test run, and environment variables.

This file could be used to insert code into the application that handles parsing
the YAML files. We were able to reproduce an attack that was able to access this
application's environment.

We had a suspicion this issue might affect us, this was around 16:20 UTC. Ten
minutes later Konstantin verified that there is a possible attack vector to
exploit the issue. We had a running exploit at 18:30 UTC.

After discovering and verifying this we stopped processing new builds on both
the open source and the private platform and started investigating further, this
happened around 19:00 UTC.

The other reason we took processing down is to avoid any potentially compromised
gems to be able to enter our build environments, potentially being able to
access private data or source code associated with a build.

We were contacted independently by Jonathan Rudenberg at 20:00 UTC and by
Michael Fairley, who also had a working exploit based on our code, at 0:00 UTC.

### The investigation

When we process a build we store the configuration in our database, so we could
check all existing builds for any occurrences of a string starting with "!ruby",
which would denote an attempt to inject code.

We also investigated all commits that had parsing errors (a sign that something is
wrong with the .travis.yml), looking at the files of the respective commits on
GitHub to see if there was any suspicious contents in those YAML files.

The data we looked at didn't show any signs of .travis.yml that include that
attack vector. However, there were a lot of commits that have been removed from
GitHub, so we unfortunately can't give a 100% guarantee that there hasn't been
any compromise. The further back in time we go, the less likely a guarantee like
this can be.

**As we can't give a 100% guarantee that we haven't been compromised, and should
you fear that account credentials might have been leaked, which is only
understandable in the current situation and therefore potentially allowing
access to your GitHub repositories, please revoke the Travis token for your user
account immediately!**

**The same is true for SSL keys for your projects. You can remove the SSH key on
GitHub (only required for private projects, you'll find one that has
travis-ci.com in its name), and then you can generate a new one in the Travis
UI.**

The functionality to regenerate the SSL keys has been introduced during a
previous [security
advisory](http://about.travis-ci.org/blog/2012-12-05-ssl-keys-security-issue/)
and has been extended to automatically store the new key on GitHub for private
repositories. We're working on removing the manual step of having to delete the
key on GitHub.

[Contact support](mailto:support@travis-ci.com) if you're running into any
issues after this step.

We've changed all our own access credentials in the meantime to any internal
and external services and our OAuth credentials for GitHub too.

For all the details on the vulnerability and the attack vector, we have a
separate blog post in the works.

Since all of our apps, including the one responsible for parsing YAML files run
on Heroku, they are protected by a sandboxed runtime. If there was a compromise
of that process would've only allowed access to that sandbox.

### The fix

While the fix was ready quickly, we couldn't deploy it right away, and therefore
had to leave build processing down until Heroku would enable deploys again.

We switched YAML processing to use the
[safe\_yaml](https://github.com/dtao/safe_yaml) gem, which doesn't parse any Ruby
object constructs and only allows the standard primitives.

The problem was that we couldn't deploy this fix right way, as Heroku had
disabled deployments as of 18:50 UTC last night. Deployments that didn't require
any new external RubyGems were enabled again later, but unfortunately this meant
that we couldn't deploy our fix.

This turned out to be just as well, as the investigation on a potential
compromise was still well underway by then, and only this morning, as of 08:33
UTC did deployments fully work again.

### The aftermath

This is a serious issue, and in light of the Rails vulnerability published
earlier this month, we should have reviewed all use of YAML files and how
they're parsed.

In hindsight it's such an obvious issue, and we should've added one and one
right away and looked at this part of Travis CI too.

As we turned up build processing today at around 14:00 UTC for private
repositories and 15:30 UTC for open source projects, we had to discard
queued builds. This is very unfortunate, but we had 3300 requests waiting to be
handled for private projects and around 5800 for open source projects. With our
current build capacity it would've taken us days to plow through these.

We processed all of them, but moved them into an erroneous state. Should you
rely on a specific commit to be built, you can trigger a rebuild through the UI.

Processing on <http://travis-ci.org> was unfortunately rather slow after we
brought everything back up, we're investigating the cause.

### How are we improving the situation

We have been working on encryption in the database already, we're making sure
this gets rolled out soon.

YAML parsing is a non-trust issue from now on, strictly primitive types only.
We'll also move it to a separate process that's completely isolated from the
rest of our apps, with as little configuration and access as possible.

Another issue that got in the way of fixing this quickly was not having a
central configuration storage. We're looking into options of doing that so we
have easier ways to notify running applications of any changes, e.g. regarding
access credentials for internal and external services.

We're also considering isolating our different apps from each other in much
stricter ways so that a compromise like this has only a minimized and localized
effect on the entire infrastructure.

Regarding the issue with queued up builds, we're in the process of moving
Travis' build infrastructure over to a new setup (more on this soon), which will
allow us to better handle on-demand capacity when required.

### Security on Travis CI

If you have any suspicions that something poses a security issue on Travis CI,
please contact us immediately. We've set up <mailto:security@travis-ci.com> for
this very purpose. We'll add a security page with more details to the website
soon.
