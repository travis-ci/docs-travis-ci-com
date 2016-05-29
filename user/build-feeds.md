---
title: Atom Build Feeds
layout: en
permalink: /user/build-feeds/
---
One of the means to get updates on builds are Atom feeds.

You can read them in your favorite RSS reader, or programmatically consume them
with scripts.

### Atom Feeds

Every repository on Travis CI has its own Atom feed, including all builds that
were run on it, with both pull requests and normal commits.

The feeds are fetched directly from our [API](https://api.travis-ci.org). The
canonical URL to fetch a repository's builds is
`https://api.travis-ci.org/repos/travis-ci/travis-ci/builds`.  This returns a
JSON representation by default, but you can get the Atom feed by adding the
`.atom` suffix.

For the repository above, the URL would then be
`https://api.travis-ci.org/repos/travis-ci/travis-ci/builds.atom`

On Travis CI Pro, for private repositories, you'll need a token to subscribe to
the feed. The [API endpoint](https://api.travis-ci.com) is different too.

The token must be appended to the URL as the `token` parameter. You can find the
token in [your profile](https://travis-ci.com/profile/) under the
"Profile" tab.

![Travis CI user token](/images/token.jpg)

An example URL would be
`https://api.travis-ci.com/repos/travis-ci/billing/builds.atom?token=<token>`
