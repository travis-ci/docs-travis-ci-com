---
title: "Advisory: Secure Environment Keys Security Issue"
permalink: blog/2012-12-05-ssl-keys-security-issue
created_at: Thu 6 Dec 2012 15:00:00 CET
layout: post
---

### What happened?

On November 27 we deployed a change to travis-ci.org that exposed private
repository keys (used for encrypting sensitive data in `.travis.yml` files) via
an undocumented and unannounced API endpoint. Travis CI for private repositories
was not affected by this issue.

This endpoint has been requested for 18 repositories before we were notified
about the issue on December 2nd. From examining the access logs these requests
looked like legit requests, but we still decided to come forward with this issue
as anyone could've accessed those endpoints.

### How did we fix this?

We have immediately disabled the endpoint and inspected the relevant access logs in
order to estimate possible damage.

We have taken the following steps

1. Regenerated keys for affected repos and notified maintainers
2. Add a 'regenerate key' button into the web interface
3. Announce the issue by way of this blog post

We have since regenerated the keys on the affected repositories, contacted repository
owners and added a way for people to reset their keys manually.

### How could this happen?

Our API code generates JSON payloads using service classes that in turn use
plain Ruby JSON generator classes, i.e. we do not rely on ActiveRecord's `to_json`
method normally. Now this particular endpoint was missing a single method
call that made it so that ActiveRecord's `to_json` magic kicked in and
the default logic generated the JSON payload including all attributes on
this model. Thus, the private key was included in the payload.

### How will we prevent such incidents in the future?

We have a number of changes lined up that will make sure we can not run into
something like this this easily again and we will implement them as soon as
possible. Some but not all of them include: encryption of this data in the database,
removing the ActiveRecord related logic that magically converts models into
JSON, adding extra safety nets on the API in order to make sure that generated
JSON payloads never contain keys named `private_key`, `password` or similar.

### How to re-generate your repository key?

Although the vast majority of repositories were not affected, we rolled out a new
feature that allows you to regenerate the keys for a repository. If you're worried
about security of your data you can reset your keys. In order to do that,
log in to <https://travis-ci.org>, go to your repository, click on the cog icon
on the right and choose "Regenerate Key" option from the menu.

<img src="http://s3itch.svenfuchs.com/regenerate-keys-20121206-035554.jpg" width="600" />

We're very sorry about this issue. We're very concerned with the security
of our users' sensitive data. Even though we have talked to the maintainers of
all affected projects and though to the best of our knowledge, no harm was
caused, this should never happen again.

If you have any questions or feedback regarding SSL keys or security in general,
please email us at <support@travis-ci.com>.
