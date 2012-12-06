---
title: Ssl keys security issue
permalink: blog/2012-12-05-ssl-keys-security-issue
layout: post
---

A week ago we deployed a change to the new Travis API that exposed the public key related to a repository. This key can be used to encrypt data, like environment variables or notification details, that should stay secret and can only be decrypted with the private key which we keep secret.

As you can expect, the private key is not supposed to be visible in the new endpoint, but due to a mistake on our end with how we deal with versioning, we unfortunately included all attributes in the JSON output, including the private key.

As soon as we were notified about the issue we deployed a fix for the misbehaving endpoint. We then preceeded to audit how many repos had been affected. Thankfully there was only a handful of requests, all which indicated regular usage, nevertheless we notified owners of those repositories and regenerated their keys automatically.

Although most of the repositories were not affected, we rolled out a new feature that allows you to regenerate keys for a repository. If you're worried about security of your data, feel free to reset your keys. In order to do that, you can log in on https://travis-ci.org, go to you repo, click on the cog icon on the right and choose "Regenerate Key" option from the menu.

[![](http://drogus-s3itch.s3.amazonaws.com/Travis_CI_-_Free_Hosted_Continuous_Integration_Platform_for_the_Open_Source_Community-20121203-222851.jpg)

Special thanks needs to be given to Forbes Lindesay (http://www.forbeslindesay.co.uk) who notified us of the issue. Thank you Forbes!

I would also like to thank Konstantin Haase (https://twitter.com/konstantinhaase) for fixing the issue within minutes, as well as Piotr Sarnacki (https://twitter.com/drogus) for adding the new feature allowing users to regenerate the SSL key.

If you have any questions or feedback regarding SSL keys, please email us at support@travis-ci.com
