---
title: Configuring Build Notifications
layout: en
permalink: notifications/
---

<div id="toc"></div>

## Notifications

Travis CI can notify you about your build results through email, IRC and/or webhooks.

By default it will send emails to

* the commit author and committer
* the owner of the repository (for normal repositories)

And it will by default send emails when, on the given branch:

* a build was just broken or still is broken
* a previously broken build was just fixed

You can change this behaviour using the following options:

> Note: Items in brackets are just placeholders. Brackets should be omitted.

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

`always` and `never` obviously mean that you want email notifications to be sent always or never. `change` means that you will get them when the build status changes on the given branch.

## IRC notification

You can also specify notifications sent to an IRC channel:

    notifications:
      irc: "chat.freenode.net#travis"

Or multiple channels:

    notifications:
      irc:
        - "chat.freenode.net#travis"
        - "chat.freenode.net#some-other-channel"

Just as with other notification types you can specify when IRC notifications will be sent:

    notifications:
      irc:
        channels:
          - "chat.freenode.net#travis"
          - "chat.freenode.net#some-other-channel"
        on_success: [always|never|change] # default: always
        on_failure: [always|never|change] # default: always

You also have the possibility to customize the message that will be sent to the channel(s) with a template:

    notifications:
      irc:
        channels:
          - "chat.freenode.net#travis"
          - "chat.freenode.net#some-other-channel"
        template:
          - "%{repository} (%{commit}) : %{message} %{foo} "
          - "Build details: %{build_url}"

You can interpolate the following variables:

* *repository*: your GitHub repo URL
* *build_number*: build number
* *branch*: branch build name
* *commit*: shortened commit SHA
* *author*: commit author name
* *message*: travis message to the build
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
          - "chat.freenode.net#travis"
          - "chat.freenode.net#some-other-channel"
        on_success: [always|never|change] # default: always
        on_failure: [always|never|change] # default: always
        use_notice: true

and if you want the bot to not join before the messages are sent, and part afterwards, use the `skip_join` flag:

    notifications:
      irc:
        channels:
          - "chat.freenode.net#travis"
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
          - "irc.freenode.org#travis"
        channel_key: 'password'

## Campfire notification

Notifications can also be sent to Campfire chat rooms, using the following format:

    notifications:
      campfire: [subdomain]:[api token]@[room id]


* *subdomain*: is your campfire subdomain (i.e. 'your-subdomain' if you visit 'https://your-subdomain.campfirenow.com')
* *api token*: is the token of the user you want to use to post the notifications.
* *room id*: this is the room id, not the name.

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

## HipChat notification

Notifications can be sent to your HipChat chat rooms using the following format:

    notifications:
      hipchat: [api token]@[room name]


* *api token*: token of the user you want to use to post the notifications.
* *room name*: name of the room you want to notify.

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

## Webhook notification

You can define webhooks to be notified about build results the same way:

    notifications:
      webhooks: http://your-domain.com/notifications

Or multiple channels:

    notifications:
      webhooks:
        - http://your-domain.com/notifications
        - http://another-domain.com/notifications

Just as with other notification types you can specify when webhook payloads will be sent:

    notifications:
      webhooks:
        urls:
          - http://hooks.mydomain.com/travisci
          - http://hooks.mydomain.com/events
        on_success: [always|never|change] # default: always
        on_failure: [always|never|change] # default: always
        on_start: [true|false] # default: false

Here is an example payload of what will be `POST`ed to your webhook URLs: [gist.github.com/1225015](https://gist.github.com/1225015)

### Authorization
When Travis makes the POST request, a header named 'Authorization' is included.  Its value is the SHA2 hash of your
GitHub username, the name of the repository, and your Travis token.  In Python,

    from hashlib import sha256
    sha256('username/repository' + TRAVIS_TOKEN).hexdigest()

Use this to ensure Travis is the one making requests to your webhook.
