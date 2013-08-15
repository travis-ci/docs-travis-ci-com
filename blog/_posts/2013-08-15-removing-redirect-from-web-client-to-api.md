---
title: Redirection from web client to API will be removed soon
author: Mathias Meyer
twitter: roidrage
layout: post
created_at: Thu 08 Aug 2013 16:00:00 CEST
permalink: blog/2013-08-08-solving-the-puzzle-of-scalable-log-processing
---

Historically Travis' web interface and Travis API where living on
one host: travis-ci.org. After splitting the API from the frontend
we set up a redirect from travis-ci.org to api.travis-ci.org in
order to make it easier for API users to notice the endpoint change.
A redirect happens when request looks like API request, which is
basically an educated guess. We get it right most of the time, but
browser can send an Accept header, which we will classify as API call
and in the same manner an API client can send a request which looks
like it's a browser.

We think it's time to drop the redirect. If you use Travis API and
you still use travis-ci.org host, thus you rely on redirect, please
update your apps to use api.travis-ci.org
till the next Friday (23<sup>rd</sup> of August).

This change will not affect status images endpoint (`/:owner/:repo.png`)
nor `cc.xml` endpoint  (`/:owner/:repo/cc.xml`), they will continue
to work as currently.
