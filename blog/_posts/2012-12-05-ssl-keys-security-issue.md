---
title: Ssl keys security issue
permalink: blog/2012-12-05-ssl-keys-security-issue
layout: post
---

### What has happened?

On Nov 27 we have deployed a change to travis-ci.org that exposed private
repository keys (used for encrypting sensitive data in `.travis.yml` files) via
an undocumented and unannounced API endpoint. Travis CI pro was not affected.

This endpoint has been requested for 18 repositories before we were notified
about the issue on Dec 2nd. From examining the access logs these requests
looked like legit requests, but we obviously needed to respond to this with
assumption that someone could have fetched key for non their repository.

### How did we fix this?

We have immediately disabled the endpoint, inspected relevant access logs in
order to estimate possible damage and we have asked people who are experienced
in such issues in order to find an appropriate way to handle this.

We decided to take the following steps

1. Regenerate keys for affected repos and notify maintainers
2. Add a 'regenerate key' button into the web interface
3. Blog about this

We have since regenerated the keys on the affected repositories, contacted repository
owners and added a way for people to reset their keys manually.

### How could this happen?

Our API code generates JSON payloads using service classes that in turn use
plain Ruby JSON generator classes, i.e. we do not rely on ActiveRecord's `to_json`
method normally. Now this particular endpoint was missing a single method
call that made it so that ActiveRecord's `to_json` magic kicked in and
the default logic generated the JSON payload including all attributes on
this model. Thus, the private key was included to the payload.

### How will we protect from such incidents in future?

We have a number of changes lined up that will make sure we can not run into
something like this this easily again and we will implement them as soon as
possible. Some but not all of them include: encryption of this data in the database,
removing the ActiveRecord related logic that magically converts models into
JSON, adding extra safety nets on the API in order to make sure that generated
JSON payloads never contain keys named `private_key`, `password` or similar.

### How to re-generate your repository key?

Although most of the repositories were not affected we rolled out a new
feature that allows you to regenerate keys for a repository. If you're worried
about security of your data you can reset your keys. In order to do that,
log in on https://travis-ci.org, go to you repo, click on the cog icon
on the right and choose "Regenerate Key" option from the menu.

<img src="http://s3itch.svenfuchs.com/regenerate-keys-20121206-035554.jpg" width="600" />

We are very sorry about this to happen. We are very concerned with the security
of our users' sensitive data. Even though we have talked to the maintainers of
all affected projects and to our knowledge no harm was caused this never should
happen again.

If you have any questions or feedback regarding SSL keys, please email us at
support@travis-ci.com
