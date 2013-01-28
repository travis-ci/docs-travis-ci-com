---
title: "Token, Token, Token"
created_at: Mon Jan 28 17:00:00 CET 2013
layout: post
author: Konstantin Haase
twitter: konstantinhaase
permalink: blog/2013-01-28-token-token-token
---

At Travis CI, when we say "token", we can mean different things. So I thought I'll just explain real quick what we could refer to and why there's even a difference.

## GitHub Token

This is pretty straight forward and should usually not bother you unless you want to leave Travis CI. When you sign in on Travis, we redirect you to GitHub, where you're asked to grant us [limited access](blog/2013-01-08-new-github-scope) to your account. This will give use a token, which we store internally.

You can also use any other GitHub token to [prove that you are you](https://api.travis-ci.org/docs/#POST%20/auth/github). In that case, Travis will not store the token. Our [command line client](https://github.com/travis-ci/travis) for instance uses this with a temporary token for authentication.

You can revoke this token any time via your [GitHub account settings](https://github.com/settings/applications). You should take into account that Travis might no longer work properly in that case, though.

## Access Token

Access tokens are used to interact with the Travis API. This mechanism is used by both our web and our command line client. These tokens are quite powerful, as you can imagine. Giving someone an access token is like giving them full access to your Travis account. Which is why you wouldn't give away such a token.

With an access token you can, amongst other things:

* See log output for private repositories.
* Restart a build.
* Enable/disable a repository.
* Anything else [our web interface](https://travis-ci.org) can do (except for billing on [Pro](http://travis-ci.com)).

You can add an access token to an API call by appending `?access_token=...` to the URL or via an `Authorization: token ...` header.

## Travis Token

Last but not least, the "Travis Token". There are times where you need a token that some people should be able to see. For instance, the token in the service hook might be visible to your collaborators. Or if you want to display the status image for a private repository. Which is why we have these tokens that you shouldn't necessarily post publicly, but aren't super secret either.

With a travis token you can:

* Manually set up a service hook on GitHub, if you have admin access to the repository.
* Display the status image for a private repository.
* Access the cc.xml of a private repository (for [CCMenu](http://ccmenu.sourceforge.net/)/[CCTray](http://confluence.public.thoughtworks.org/display/CCNET/CCTray)).

You can append a travis token via `?token=...` to a normal request. If your repository is at `travis-ci.com/my/private_repo` you can for instance access the `cc.xml` under `travis-ci.com/my/private_repo/cc.xml?token=...`.

## Where do I get my token?

* GitHub token: You don't.
* Travis token: Go to the *Profile* tab on your [Accounts](https://travis-ci.org/profile) page
* API token: `gem install travis && travis login && travis token` or manually via the [API](https://api.travis-ci.org).

Enjoy!