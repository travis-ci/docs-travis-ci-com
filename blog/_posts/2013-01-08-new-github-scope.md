---
title: "New GitHub scope"
created_at: Tue Jan 09 22:00:00 CET 2013
layout: post
author: Konstantin Haase
twitter: konstantinhaase
permalink: blog/2013-01-08-new-github-scope
---

We've just started requesting the new [user:email](http://developer.github.com/changes/2013-01-08-new-user-scopes/) scope from GitHub. We added this to improve our email handling in the future. Currently we send out emails based on Git commits, which is suboptimal, we don't have a real user to email mapping.

Besides this new scope, we continue to ask GitHub for the `public_repo` scope (`repo` scope on [travis-ci.com](https://travis-ci.com)), which allows us to check and modify the Travis hook, read the `.travis.yml` from your repositories, etc. Travis never generates any commits or reads any unrelated infos.

Unfortunately, this does mean that you might get logged out of the web interface and that GitHub will asked you once more to grant Travis CI access. You can revoke access at any point in time via the GitHub account settings.
