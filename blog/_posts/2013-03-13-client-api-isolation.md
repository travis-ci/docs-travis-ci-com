---
title: Client and API isolation
permalink: blog/2013-03-13-client-and-api-isolation
created_at: Wed 13 Mar 2013 18:00:00 GMT
author: Piotr Sarnacki
twitter: drogus
layout: post
---

[Travis CI web client](https://travis-ci.org) is a javascript application
written in [Ember.js](http://emberjs.com/). What's really interesting here,
is that the [web application](https://github.com/travis-ci/travis-web) and
the [API app](https://github.com/travis-ci/travis-api) live in completely
separate repositories and run on different subdomains. Such kind of isolation
is possible, because of [CORS (Cross Origin Resource Sharing)](http://www.w3.org/TR/cors/),
which, in simple words, allows you to make ajax requests to a different
domain.

### Why?

At a first glance, such setup may seem more as a way to complicate things
rather than help, but let me explain how does it really help us.

For me, one of the biggest advantages of having more than one app are
the independent deployments. We deploy some of our applications a lot
(even several times a day), but we rarely touch the most important
and stable parts of our infrastructure. Similarly, I can deploy a
web client several times and if I break something, the API still
works correctly, which is great because the API may be used by other
clients as well.

But is it just about deployment? Of course not! It may seem that we
need to have 2 apps running during development: the API and the web client
itself. Most of the time this is not the case. As I mentioned above, we
use CORS, which allow us to make requets to other domains. When I
work on the client, I usually connect it to the production API. Have
you ever needed to copy part of the production database, clean sensitive
data and use it in development to catch any issues with the data you
haven't thought about? Not anymore! During development we can be connected
to staging or production API or to the local API server.

Recently we wanted to show the changes in the client in some easy way,
without the need to deploy to the staging server. The idea was simple:

* after finishing the build on travis, upload the assets to the S3 bucket
  using [travis artifacts](http://about.travis-ci.org/blog/2012-12-18-travis-artifacts/)
* when a parameter is passed to the web app (like: `https://travis-ci.org?alt=my-feature-branch),
  start serving assets from S3 for a given branch, also set cookie
  to serve alternative assets on subsequent requests
* when `default` branch name is passed as a param, revert to the
  regular assets, which are currently deployed

Now I can just push my feature branch, wait for a build on travis to finish
and pass the url to someone to whom I would like to show the results. It's
so much better than just using staging! That way it behaves more naturally
as it uses production data and I don't even need to deploy anything.

You may be wondering if this is safe? In fact I'm constantly using the
client in development to use the API, won't I break anything? It is a valid question
and in the case of some applications it could be risky. Imagine that you're
working on an admin application frontend. If you plug it to the production
API you may accidentally fire a request, which will make a mess.

However, in our case it's not a problem. The API does not let you do almost
any destructive things and even if it did, in the worst case we would
mess up our own accounts.

### How?

As I mentioned earlier, we use CORS, to make such isolation possible. CORS is fairly
simple to set up and use. When you fire up an ajax request to the different domain,
the browser should automatically try to use CORS. Before making the actualy request,
the `OPTIONS` request should be sent in order to check if an endpoint accepts CORS.

In order to see how it works in action with Travis API, you may try to use such curl
request:

```
curl --verbose --request OPTIONS \
     --header "Accept: application/json; version=2" \
     https://api.travis-ci.org/jobs
```

The response should look something like:

```
< HTTP/1.1 200 OK
< Access-Control-Allow-Credentials: true
< Access-Control-Allow-Headers: Content-Type, Authorization, Accept, If-None-Match, If-Modified-Since
< Access-Control-Allow-Methods: HEAD, GET, POST, PATCH, PUT, DELETE
< Access-Control-Allow-Origin: *
< Access-Control-Expose-Headers: Content-Type, Cache-Control, Expires, Etag, Last-Modified
< Content-Type: text/html;charset=utf-8
< Content-Length: 69
< Connection: keep-alive
```

It basically specifies how should browser behave when issuing a request to such endpoint,
ie.:

* which HTTP methods can it use? (`Access-Control-Allow-Methods`)
* which headers can a browser sent with the actual request? (`Access-Control-Allow-Headers`)
* which headers can it expose to the javascript client? (`Access-Control-Expose-Headers`)
* what places can a request come from? (`Access-Control-Allow-Origin`)
* can a browser send credentials with `Authorization` header? (`Access-Control-Allow-Credentials`)

For more info on CORS, you should check out the (CORS specification)[http://www.w3.org/TR/cors/].

Our API is written in Sinatra and CORS support is fairly [easy to implement](https://github.com/travis-ci/travis-api/blob/master/lib/travis/api/app/cors.rb).
Of course you may need a bit more code if you want to pass different options for different
endpoints.

On the client side, we don't have to do anything, the browser will just do the proper thing.

### Any caveats?

As you may noticed, there is one small disadvantage of using CORS. A browser
need to fire an additional `OPTIONS` request before making the actual request.
Handling such request is really fast, because most of the time you don't
need to do anything more than setting up a few headers, but you pay the cost
of doing the request anyway.

Depending on your situation it may or may not be a real problem. Thankfully,
the web is moving forward and with growing popularity of [SPDY](http://en.wikipedia.org/wiki/SPDY)
and with the HTTP2.0 spec in the works, the number of requests should have
smaller and smaller significance.

It's also good to know that not all of the browser support CORS. If you
want to use it, you may want to check if you can ignore the browsers
which does not support it.

### Summary

API and client isolation is awesome and you should try it!

I would also like to remind all of you reading this post, that I work
on Travis full time thanks to [Engine Yard](https://www.engineyard.com/),
they're sponsoring TravisCI and a lot of other OSS projects!
