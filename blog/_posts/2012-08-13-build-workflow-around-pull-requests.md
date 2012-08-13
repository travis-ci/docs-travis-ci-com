---
title: "A Build Workflow Around Pull Requests"
author: Mathias Meyer
twitter: roidrage
permalink: blog/2012-08-13-build-workflow-around-pull-requests
---
Git makes it very easy to create and merge branches around new features and bug
fixes. Entire
[workflows](http://nvie.com/posts/a-successful-git-branching-model/) sparked
around the ease of branching off with Git.  Whichever approach you use, Travis
loves all your branches equally and builds them happily as you push them.

[Pull requests](https://help.github.com/articles/using-pull-requests) have
changed that workflow for a lot of users though. While new features still evolve
around separate branches created off a master, production or development branch,
or even your own fork, they start out early as a pull requests.

Opening a pull request early allows discussions around what the end result looks
like. They also make community or internal code review a breeze. GitHub
themselves have [popularized this
workflow](http://scottchacon.com/2011/08/31/github-flow.html) and it has been
adapted by numerous other companies and teams, the Travis team included. Heck,
even this blog post was written on a branch and submitted for review via pull
request. This little button on GitHub makes it so easy:

![Just open a pull
request](http://s3itch.paperplanes.de/travis-ci_travis-ci.github.com_at_mm-pull-requests-workflow-20120813-103348.png)

We love pull requests a lot. So does [Travisbot](https://github.com/travisbot),
who leaves a totally un-opinionated comment on pull requests to let the owner
know if they passed or failed.

With the [availability of pull requests for
everyone](http://about.travis-ci.org/blog/pull-request-testing-for-everyone/),
including private repositories on [Travis Pro](http://travis-ci.com), you can
now easily choose your workflow and bend Travis to your own needs. You can
either choose to keep building all branches (which is the default).

![Pull requests were created by
aliens](http://s3itch.paperplanes.de/skitched-20120813-094732.png)

Or, as some of our early Travis Pro customers have started doing, you can choose
to only have Travis build pull requests and a number of important branches that
are relevant to shipping code (master, production, development, staging, etc.)
For one thing, because it fits their workflow better. The other upshot is that
Travis doesn't build the same commits twice.

We get notified when you push to a feature branch and when the corresponding
pull request is updated with these commits. Restricting the number of branches
on Travis makes sure you don't build the same commits more than once as you keep
working on a feature. They'll only be build again when merged into your shipping
branch.

To restrict Travis to only build a small set of branches, you can add a section
to you `.travis.yml` file:

```yaml
branches:
  only:
    - master
    - production
    - staging
```

The added benefit of using this approach is that the build status becomes a part
of the code history as it evolves, making it visual (by way of comments on the pull
requests), which commits caused problems and which ones kept the code in a
shippable state.
