---
title: Redirection from web client to API will be removed soon
author: Piotr Sarnacki
twitter: drogus
layout: post
created_at: Fri 16 Aug 2013 16:00:00 CEST
permalink: blog/2013-08-16-removing-redirect-from-web-client-to-api
---

Historically Travis' web interface and Travis API lived on
one host: travis-ci.org. After splitting the API from the frontend
we set up a redirect from travis-ci.org to api.travis-ci.org in
order to make it easier for API users to notice the endpoint change.
A redirect happens when the request looks like an API request, which is
basically an educated guess. We get it right most of the time, but
browser can send an Accept header, which we will classify as API call
and in the same manner an API client can send a request which looks
like it's a browser.

We think it's time to drop the redirect. If you use Travis API and
you still use travis-ci.org host, thus you rely on redirect, please
update your apps to use api.travis-ci.org
before Friday, 23<sup>rd</sup> of August.

This change will not affect status images endpoint (`/:owner/:repo.png`)
nor `cc.xml` endpoint  (`/:owner/:repo/cc.xml`), they will continue
to work as currently.
