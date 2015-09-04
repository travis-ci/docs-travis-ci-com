---
title: Configuring Build Notifications
layout: en
permalink: /user/notifications/
---

<div id="toc"></div>

## Notifications

Travis CI can notify you about your build results through email, IRC and/or webhooks.

By default, email notifications are sent to the committer and the commit
author, if they are members of the repository (that is, they have push or admin
permissions for public repositories, or if they have pull, push or admin
permissions for private repositories).

Emails are sent when, on the given branch:

* a build was just broken or still is broken
* a previously broken build was just fixed

If you add another notification channel, ie hipchat, slack or any other, the
default is to send a notification on every build.

You can change the conditions for each of the channels by setting the
`on_success` on `on_failure` flag on that medium to one of:

* `always`: always send a notification.
* `never`: never send a notification.
* `change`: send a notification when the build status changes.

For example, to always send slack notifications on sucessful builds:

	notifications:
	  slack:
	    on_success: always

Read the relevant section below for information on configuring each
notification channel.

### Note on SSL/TLS Ciphers

When posting notifications over SSL/TLS, be mindful of what ciphers are accepted
by the receiving server.
Notifications will fail if none of the server's ciphers work.

Currently, the following ciphers (as defined by the [jruby-openssl gem](https://rubygems.org/gems/jruby-openssl))
are known to work:

AES-128 AES-128-CBC AES-128-CFB AES-128-CFB1 AES-128-CFB8 AES-128-ECB AES-128-OFB AES-192 AES-192-CBC AES-192-CFB AES-192-CFB1 AES-192-CFB8 AES-192-ECB AES-192-OFB AES-256 AES-256-CBC AES-256-CFB AES-256-CFB1 AES-256-CFB8 AES-256-ECB AES-256-OFB BF BF-CBC BF-CFB BF-CFB1 BF-CFB8 BF-ECB BF-OFB BLOWFISH CAST CAST-CBC CAST5 CAST5-CBC CAST5-CFB CAST5-CFB1 CAST5-CFB8 CAST5-ECB CAST5-OFB DES DES-CBC DES-CFB DES-CFB1 DES-CFB8 DES-ECB DES-EDE DES-EDE-CBC DES-EDE-CFB DES-EDE-CFB1 DES-EDE-CFB8 DES-EDE-ECB DES-EDE-OFB DES-EDE3 DES-EDE3-CBC DES-EDE3-CFB DES-EDE3-CFB1 DES-EDE3-CFB8 DES-EDE3-ECB DES-EDE3-OFB DES-OFB RC2 RC2-40-CBC RC2-64-CBC RC2-CBC RC2-CFB RC2-CFB1 RC2-CFB8 RC2-ECB RC2-OFB RC4 RC4-40

Also, consult [cipher suite names mapping](https://www.openssl.org/docs/apps/ciphers.html).

If none of the ciphers listed above works, please open a [GitHub issue](https://github.com/travis-ci/travis-ci/issues).

## Email notifications

Specify recipients that will be notified about build results:

    notifications:
      email:
        - one@example.com
        - other@example.com

Turn off email notifications entirely:

    notifications:
      email: false

Specify when you want to get notified:

    notifications:
      email:
        recipients:
          - one@example.com
          - other@example.com
        on_success: [always|never|change] # default: change
        on_failure: [always|never|change] # default: always

> Note: Items in brackets are placeholders. Brackets should be omitted.

`always` and `never` mean that you want email notifications to be sent always or never. `change` means that you will get them when the build status changes on the given branch.

### How is the build email receiver determined?

By default, a build email is sent to the committer and the author, but only if
they have access to the repository the commit was pushed to. This prevents forks
active on Travis CI from notifying the upstream repository's owners when they're
pushing any upstream changes to their fork. It also prevents build notifications
from going to folks not registered on Travis CI.

The email address is then determined based on the email address in the commit,
but only if it matches one of the email addresses in our database. We
synchronize all your email addresses from GitHub, solely for the purpose of
build notifications.

The default can be overridden in the `.travis.yml` as shown above. If there's a
setting specified, Travis CI only sends an emails to the addresses specified
there, rather than to the committer and author.

### How can I change the email address for build notifications?

The email addresses are pulled from GitHub. All emails registered there for your
user account are available in Travis CI as well.

You can change the build email address by setting a different email address for
a specific repository. Running `git config user.email my@email.com` sets a
different email address than the default for your repository.

Note that we currently don't respect the [detailed notifications
settings](https://github.com/settings/notifications) on
GitHub, as they're not exposed via an API at this point.

### I'm not receiving any build notifications

The most common cause for not receiving build notifications, beyond not having a
user account on Travis CI, is the use of an email address that's not registered
and verified on GitHub. See above on how to change the email address to one
that's registered or make sure to add the email address used in this repository
to [your verified email addresses](https://github.com/settings/emails) on GitHub.

## IRC notification

You can also specify notifications sent to an IRC channel:

    notifications:
      irc: "chat.freenode.net#my-channel"

Or multiple channels:

    notifications:
      irc:
        - "chat.freenode.net#my-channel"
        - "chat.freenode.net#some-other-channel"

As with other notification types you can specify when IRC notifications will be sent:

    notifications:
      irc:
        channels:
          - "chat.freenode.net#my-channel"
          - "chat.freenode.net#some-other-channel"
        on_success: [always|never|change] # default: always
        on_failure: [always|never|change] # default: always

You also have the possibility to customize the message that will be sent to the channel(s) with a template:

    notifications:
      irc:
        channels:
          - "chat.freenode.net#my-channel"
          - "chat.freenode.net#some-other-channel"
        template:
          - "%{repository} (%{commit}) : %{message} %{foo} "
          - "Build details: %{build_url}"

You can interpolate the following variables:

* *repository_slug*: your GitHub repo identifier (like ```svenfuchs/minimal```)
* *repository_name*: the slug without the username
* *repository*: same as repository_slug [Deprecated]
* *build_number*: build number
* *build_id*: build id
* *branch*: branch build name
* *commit*: shortened commit SHA
* *author*: commit author name
* *commit_message*: commit message of build
* *commit_subject*: first line of the commit message
* *result*: result of build
* *message*: travis message to the build
* *duration*: duration of the build
* *compare_url*: commit change view URL
* *build_url*: URL of the build detail

The default template is:

    notifications:
      irc:
        template:
          - "%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message}"
          - "Change view : %{compare_url}"
          - "Build details : %{build_url}"

If you want the bot to use notices instead of regular messages the `use_notice` flag can be used:

    notifications:
      irc:
        channels:
          - "chat.freenode.net#my-channel"
          - "chat.freenode.net#some-other-channel"
        on_success: [always|never|change] # default: always
        on_failure: [always|never|change] # default: always
        use_notice: true

and if you want the bot to not join before the messages are sent, and part afterwards, use the `skip_join` flag:

    notifications:
      irc:
        channels:
          - "chat.freenode.net#my-channel"
          - "chat.freenode.net#some-other-channel"
        on_success: [always|never|change] # default: always
        on_failure: [always|never|change] # default: always
        use_notice: true
        skip_join: true

If you enable `skip_join`, remember to remove the `NO_EXTERNAL_MSGS` flag (n) on the IRC channel(s) the bot notifies.

If you want the bot to send messages to channels protected with a channel key (ie, set with `/mode #channel +k password`), you can use the `channel_key` variable:

    notifications:
      irc:
        channels:
          - "irc.freenode.org#my-channel"
        channel_key: 'password'

## Campfire notification

Notifications can also be sent to Campfire chat rooms, using the following format:

    notifications:
      campfire: [subdomain]:[api token]@[room id]


* *subdomain*: is your campfire subdomain (i.e. 'your-subdomain' if you visit 'https://your-subdomain.campfirenow.com')
* *api token*: is the token of the user you want to use to post the notifications.
* *room id*: this is the room id, not the name.

> Note: We highly recommend you [encrypt](/user/encryption-keys/) this value if your .travis.yml is stored in a public repository:

    travis encrypt subdomain:api_token@room_id --add notifications.campfire.rooms

You can also customise the notifications, like with IRC notifications:

    notifications:
      campfire:
        rooms:
          - [subdomain]:[api token]@[room id]
        template:
          - "%{repository} (%{commit}) : %{message} %{foo} "
          - "Build details: %{build_url}"

Other flags, like `on_success` and `on_failure` also work like the IRC notification config.

## Flowdock notification

Notifications can be sent to your Flowdock Team Inbox using the following format:

    notifications:
      flowdock: [api token]


* *api token*: is your API Token for the Team Inbox you wish to notify. You may pass multiple tokens as a comma separated string or an array.

> Note: We highly recommend you [encrypt](/user/encryption-keys/) this value if your .travis.yml is stored in a public repository:

    travis encrypt api_token --add notifications.flowdock

## HipChat notification

Notifications can be sent to your HipChat chat rooms using the following format:

    notifications:
      hipchat: [api token]@[room id or name]

If you are running HipChat Server, then you can specify the hostname like this:

    notifications:
      hipchat: [api token]@[hostname]/[room id or name]

* *api token*: token of the user you want to use to post the notifications. This token can be either an API v1 token your group administrator gives you, or an API v2 token you manage.
* *hostname*: optional, defaults to api.hipchat.com, but can be specified for HipChat Server instances
* *room id or name*: id or name of the room you want to notify.

If your room name contains spaces then use the room id.

> Note: We highly recommend you [encrypt](/user/encryption-keys/) this value if your .travis.yml is stored in a public repository:

    travis encrypt api_token@room_id_or_name --add notifications.hipchat.rooms

HipChat notifications support templates too, so you can customize the appearance of the notifications, e.g. reduce it to a single line:

    notifications:
      hipchat:
        rooms:
          - [api token]@[room id or name]
        template:
          - '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message}'

If you want to send HTML notifications you need to add `format: html` like this
(note that this disables some features like @mentions and autolinking):

    notifications:
      hipchat:
        rooms:
          - [api token]@[room id or name]
        template:
          - '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message} (<a href="%{build_url}">Details</a>/<a href="%{compare_url}">Change view</a>)'
        format: html

With the V2 API, you can trigger a user notification by setting `notify: true`:

    notifications:
      hipchat:
        rooms:
          - [api token]@[room id or name]
        template:
          - '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message}'
        notify: true

### `From` value in notifications

When a V1 token is used, the notification is posted by "Travis CI".

With a V2 token, this value is set by the token's Label.
Create a special-purpose room notification token ("Tokens" under the room's "Administration" section)
with a desired label, and use this token.

<figure>
  <img src="/images/hipchat_token_screen.png" alt="HipChat Room Notification Tokens screenshot" width="550px" />
</figure>

## Pushover notification

Notifications can also be sent via [Pushover](https://pushover.net/) via the following format:

    notifications:
      pushover:
        api_key: [api token]
        users:
          - [user key]


* *api token*: API Token/Key for a Pushover Application (create this under "Your Applications" after logging in to Pushover; it's recommended to create one specific to Travis CI).
* *user key*: The User Key for a user to be notified (this can be seen after logging in to Pushover). A list of multiple users is supported.

> Note: We highly recommend you [encrypt](/user/encryption-keys/) these values if your .travis.yml is stored in a public repository; this will add (or overwrite) your api_token,
> and append the specified user_key to the list of users.

    travis encrypt [api_token] --add notifications.pushover.api_key
    travis encrypt [user_key] --add notifications.pushover.users --append

You can also customise the notifications, like with IRC notifications:

    notifications:
    pushover:
      api_key: [api token]
      users:
        - [user key]
        - [user key]
      template: "%{repository} (%{commit}) : %{message} %{foo} - Build details: %{build_url}"

Other flags, like `on_success` and `on_failure` also work like the IRC notification config.

## Sqwiggle notifications

With [Sqwiggle](https://www.sqwiggle.com), you can combine Travis CI build
notifications with the joys of seeing your team mates faces when they break or
fix the build.

To get started, you need to create an [API token for the Sqwiggle
API](https://www.sqwiggle.com/company/clients). It's sufficient to create a
stream client only, as that will have the least permissions.

Next you need to figure out with rooms to send the notifications to.

You can use the room's name in the URL or you can use the room's identifier,
which can currently be [fetched from the
API](https://www.sqwiggle.com/docs/endpoints/streams#listallstreams)

Now you can add the details to your .travis.yml:

    notifications:
      sqwiggle: <api_token>@room

If you'd like to notify multiple rooms, you can specify a list of token/room
combinations.

    notifications:
      sqwiggle:
        rooms:
          - <api_token>@mainhall
          - <api_token>@developers

Sqwiggle notifications support templating, so you can customize how the message
pops up in your streams.

The default looks like this:

![Screenshot of default Sqwiggle notifications](http://s3itch.paperplanes.de/sqwiggle_20140212_101412.jpg_20140213_103612.jpg)

To customize it, add a template definition to your .travis.yml.

    notifications:
      sqwiggle:
        rooms: <api_token>@mainhall
        template: '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message}'

It's recommended to encrypt the credentials.

## Slack notifications

Travis CI supports notifying arbitrary [Slack](http://slack.com) channels about
build results.

On Slack, set up a [new Travis CI
integration](https://my.slack.com/services/new/travis). Select a channel,
and you'll find the details to paste into your .travis.yml.

<figure>
  <img alt="Screenshot of adding Slack integration" src="http://s3itch.paperplanes.de/slackintegration_20140313_075147.jpg"/>
</figure>

The channel name in the Slack settings can be overridden in Travis CI's
notification settings, so you can set up one integration and use it for multiple
channels regardless of the initial setup.

Just copy and paste the settings, which already include the proper token, into
your `.travis.yml`, and you're good to go.

Easy as pie, but if you want more customization, read on.

The simplest configuration requires your account name and the token you just
generated.

    notifications:
      slack: '<account>:<token>'

Overriding the channel is also possible, just add it to the configuration with a
`#` separating them from account and token.

    notifications:
      slack: '<account>:<token>#development'

You can specify multiple channels as well.

    notifications:
      slack:
        rooms:
          - <account>:<token>#development
          - <account>:<token>#general
        on_success: [always|never|change] # default: always
        on_failure: [always|never|change] # default: always
        on_start: [always|never|change]   # default: always

As always, it's recommended to encrypt the credentials with our
[travis](https://github.com/travis-ci/travis#readme) command line client.

    travis encrypt "<account>:<token>" --add notifications.slack.rooms

Once everything's setup, push a new commit and you should see something like the
screenshot below:

<figure>
  <img alt="Screenshot of sample Slack integration" src="http://s3itch.paperplanes.de/slackmessage_20140313_180150.jpg">
</figure>

Slack will be notified both for normal branch builds and for pull requests as
well.


## Webhook notification

You can define webhooks to be notified about build results the same way:

    notifications:
      webhooks: http://your-domain.com/notifications

Or multiple URLs:

    notifications:
      webhooks:
        - http://your-domain.com/notifications
        - http://another-domain.com/notifications

As with other notification types you can specify when webhook payloads will be sent:

    notifications:
      webhooks:
        urls:
          - http://hooks.mydomain.com/travisci
          - http://hooks.mydomain.com/events
        on_success: [always|never|change] # default: always
        on_failure: [always|never|change] # default: always
        on_start: [always|never|change] # default: always

### Webhooks Delivery Format

Webhooks are delivered with a `application/x-www-form-urlencoded` content type using HTTP POST, with the body including a `payload` parameter that contains the JSON webhook payload in a URL-encoded format.

Here's an example of what you'll find in the `payload`:

<script src="https://gist.github.com/roidrage/9272064.js"></script>

You will see one of the following values in the `status`/`result` fields that represent the state of the build.

* *0*: Represents a build that has completed successfully
* *1*: Represents a build that has not yet completed or has completed and failed

Additionally a message will be present in the `status_message`/`result_message` fields that further describe the status of the build.

* *Pending*: A build has been requested
* *Passed*: The build completed successfully
* *Fixed*: The build completed successfully after a previously failed build
* *Broken*: The build completed in failure after a previously successful build
* *Failed*: The build is the first build for a new branch and has failed
* *Still Failing*: The build completed in failure after a previously failed build

For pull requests, the `type` field will have the value `pull_request`, and a `pull_request_number` field is included too, pointing to the pull request's issue number on GitHub.

Here's a simple example of a [Sinatra](http://sinatrarb.com) app to decode the request and the payload:

	require 'sinatra'
	require 'json'
	require 'digest/sha2'

	class TravisWebhook < Sinatra::Base
	  set :token, ENV['TRAVIS_USER_TOKEN']

	  post '/' do
	    if not valid_request?
	      puts "Invalid payload request for repository #{repo_slug}"
	    else
	      payload = JSON.parse(params[:payload])
	      puts "Received valid payload for repository #{repo_slug}"
	    end
	  end

	  def valid_request?
	    digest = Digest::SHA2.new.update("#{repo_slug}#{settings.token}")
	    digest.to_s == authorization
	  end

	  def authorization
	    env['HTTP_AUTHORIZATION']
	  end

	  def repo_slug
	    env['HTTP_TRAVIS_REPO_SLUG']
	  end
	end

To quickly identify the repository involved, we include a `Travis-Repo-Slug` header, with a format of `account/repository`, so for instance `travis-ci/travis-ci`.

### Authorization for Webhooks

When Travis CI makes the POST request, a header named `Authorization` is included.
Its value is the SHA2 hash of the GitHub username (see below), the name of the repository,
and your Travis CI token.

For instance, in Python, use this snippet:

    from hashlib import sha256
    sha256('username/repository' + TRAVIS_TOKEN).hexdigest()

Use this to ensure Travis CI is the one making requests to your webhook.

The Travis CI token used to authenticate the webhooks is the user token, which you can find on your profile page.

![Travis CI user token](/images/token.jpg)

It's the token for the user who originally set up the repository on Travis CI.
If you're uncertain who that was, you can find the user's name on the service
hooks page of your repository on GitHub.

This process is going to be reworked in the future, as the user token isn't
constantly reliable, but we'll announce any changes well in advance.
