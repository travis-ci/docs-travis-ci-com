---
title: "Travis Now Syncs Your Repositories Automagically"
layout: post
created_at: thu aug 02 15:30:26 cest 2012
permalink: blog/2012-08-01-travis-now-syncs-your-repositories-automagically
author: Mathias Meyer
twitter: roidrage
---
Until recently, we only synchronized your GitHub repositories once, when you
first created your account on Travis. That had the downside that when you
created new repositories they wouldn't automatically show up, and you had to set
up the build hook manually.

We also didn't show you the organization repositories you have access to. So
again, there had to be a manual set up process to get the project running on
Travis.

Also, in the rare case that you renamed your GitHub account (just as I did
recently) we wouldn't pick up that change.

### Keeping Your Repositories in Sync

Thankfully, all this is now in the past, and as of recently, we introduced a
synchronizing step in Travis that allows you to keep your profile and list of
repositories up to date.

When you log in for the first time we trigger a background task that checks with
GitHub and fetches all the repositories you have administrative access to. Why
only administrative? Only administrators of a repository are allow to configure
the service hook required for Travis.

So when you log in and go to your profile page for the first time, you'll be
greeted with this screen. To show you how serious this synchronizing process is,
notice the progress indicator.

![Travis
Sync](http://s3itch.paperplanes.de/Travis_CI_-_Distributed_build_platform_for_the_open_source_community-4-20120801-083921.png)

You can leave the page open until the process is finish, your repositories will
automatically show up once it's done.

![Travis
Sync](http://s3itch.paperplanes.de/Travis_CI_-_Distributed_build_platform_for_the_open_source_community-2-1-20120801-084052.png)

You can trigger a sync when you added a new repository. We also trigger one
every time you log in, to make sure we're already up-to-date should you want to
set up a new repository right away.

### My Repositories

One more thing...

Until now, the "My Repositories" tab used to be a pretty lonely place. It only
showed your personal repositories Travis knows about and not ones of an
organization that is already setup in Travis.

To make it a merrier place for everyone it now shows all the repositories that
we synced for you, so all repositories you have access to now show up in that
tab, nicely sorted by the most recent build, including all the repositories of
organizations you're a member of. That way, when a new user signs up and his or
her organization is already using Travis, he or she will have immediate access
to the respective repositories.

![My
Repositories](http://s3itch.paperplanes.de/Travis_CI_-_Distributed_build_platform_for_the_open_source_community-20120802-153002.png)

This is much less confusing for everyone using Travis. There is still a tiny bug
in our synchronization which we're currently working on. Currently you'll only
see repositories you have administrative rights too, basically the same as in
your profile page. We're improving the synchronization to respect push access
too, so that you'll see all repositories you have push access too as well.

### On Travis Pro...

All this is relevant to [Travis Pro](http://beta.travis-ci.com) as well, to go
full circle on this. A user that has administrator access to repos of several
organizations on GitHub should be able to have access to all of them on Travis
as well. This change benefits both platforms as it's now much much easier to set
up Travis CI for public and private repositories as needed.
