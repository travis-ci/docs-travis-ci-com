---
title: Configuring Build Notifications
layout: en
permalink: notifications/
---

<div id="toc"></div>

## Notifications

Travis CI can notify you about your build results through email, IRC and/or webhooks.

By default, email notifications will be sent to the committer and the commit
author, if they are members of the repository (that is, they have push or admin
permissions for public repositories, or if they have pull, push or admin
permissions for private repositories).

And it will by default send emails when, on the given branch:

* a build was just broken or still is broken
* a previously broken build was just fixed

You can change this behaviour using the following options:

> Note: Items in brackets are placeholders. Brackets should be omitted.

## Email notifications

You can specify recipients that will be notified about build results like so:

    notifications:
      email:
        - one@example.com
        - other@example.com

And you can entirely turn off email notifications:

    notifications:
      email: false

Also, you can specify when you want to get notified:

    notifications:
      email:
        recipients:
          - one@example.com
          - other@example.com
        on_success: [always|never|change] # default: change
        on_failure: [always|never|change] # default: always

`always` and `never` mean that you want email notifications to be sent always or never. `change` means that you will get them when the build status changes on the given branch.

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
* *branch*: branch build name
* *commit*: shortened commit SHA
* *author*: commit author name
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
      hipchat: [api token]@[room name]


* *api token*: token of the user you want to use to post the notifications. This token can be either an API v1 token your group administrator gives you, or an API v2 token you manage.
* *room name*: name of the room you want to notify.

> Note: We highly recommend you [encrypt](/user/encryption-keys/) this value if your .travis.yml is stored in a public repository:

    travis encrypt api_token@room_name --add notifications.hipchat.rooms

HipChat notifications support templates too, so you can customize the appearance of the notifications, e.g. reduce it to a single line:

    notifications:
      hipchat:
        rooms:
          - [api token]@[room name]
        template:
          - '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message}'

If you want to send HTML notifications you need to add `format: html` like this
(note that this disables some features like @mentions and autolinking):

    notifications:
      hipchat:
        rooms:
          - [api token]@[room name]
        template:
          - '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message} (<a href="%{build_url}">Details</a>/<a href="%{compare_url}">Change view</a>)'
        format: html

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
API](https://www.sqwiggle.com/docs/endpoints/rooms#listallrooms).

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

![](http://s3itch.paperplanes.de/sqwiggle_20140212_101412.jpg_20140213_103612.jpg)

To customize it, add a template definition to your .travis.yml.

    notifications:
      sqwiggle:
        rooms: <api_token>@mainhall
        template: '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message}'

It's recommended to encrypt the credentials.

## Webhook notification

You can define webhooks to be notified about build results the same way:

    notifications:
      webhooks: http://your-domain.com/notifications

Or multiple channels:

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
        on_start: [true|false] # default: false

Here is an example payload of what will be `POST`ed to your webhook URLs:
[gist.github.com/1225015](https://gist.github.com/1225015)

### Webhooks Delivery Format

Webhooks are delivered with a `application/x-www-form-urlencoded` content type using HTTP POST, with the body including a `payload` parameter that contains the JSON webhook payload in a URL-encoded format.

Here's an example of what you'll find in the `payload`:

<script src="https://gist.github.com/roidrage/9272064.js"></script>

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

![](/images/token.jpg)

It's the token for the user who originally set up the repository on Travis CI.
If you're uncertain who that was, you can find the user's name on the service
hooks page of your repository on GitHub.

This process is going to be reworked in the future, as the user token isn't
constantly reliable, but we'll announce any changes well in advance.
