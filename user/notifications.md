---
title: Configuring Build Notifications
layout: en

---

<div id="toc"></div>

Travis CI can notify you about your build results through email, IRC, chat or custom webhooks.

## Default notification settings

By default, email notifications are sent to the committer and the commit
author when they are members of the repository, that is they have

- push or admin permissions for public repositories.
- pull, push or admin permissions for private repositories.

Emails are sent when, on the given branch:

- a build was just broken or still is broken.
- a previously broken build was just fixed.

For more information, please read [default email
addresses](#How-is-the-build-email-receiver-determined%3F), [changing the email
address](#Changing-the-email-address-for-build-notifications) or
[troubleshooting email
notification](#Missing-build-notifications).

If you add another notification channel, ie hipchat, slack or any other, the
default is to send a notification on every build.

## Changing notification frequency

You can change the conditions for any notification channels by setting the
`on_success` or `on_failure` flag to one of:

- `always`: always send a notification.
- `never`: never send a notification.
- `change`: send a notification when the build status changes.

For example, to always send slack notifications on successful builds:

```yaml
notifications:
  slack:
    on_success: always
```

### Note on SSL/TLS Ciphers

When posting notifications over SSL/TLS, be mindful of what ciphers are accepted
by the receiving server. Notifications will fail if none of the server's ciphers work.

Currently, the following ciphers (as defined by the [openssl gem](http://ruby-doc.org/stdlib-2.1.6/libdoc/openssl/rdoc/OpenSSL.html))
are known to work:

```
AES-128-CBC AES-128-CBC-HMAC-SHA1 AES-128-CFB AES-128-CFB1 AES-128-CFB8 AES-128-CTR AES-128-ECB AES-128-OFB AES-128-XTS AES-192-CBC AES-192-CFB AES-192-CFB1 AES-192-CFB8 AES-192-CTR AES-192-ECB AES-192-OFB AES-256-CBC AES-256-CBC-HMAC-SHA1 AES-256-CFB AES-256-CFB1 AES-256-CFB8 AES-256-CTR AES-256-ECB AES-256-OFB AES-256-XTS AES128 AES192 AES256 BF BF-CBC BF-CFB BF-ECB BF-OFB CAMELLIA-128-CBC CAMELLIA-128-CFB CAMELLIA-128-CFB1 CAMELLIA-128-CFB8 CAMELLIA-128-ECB CAMELLIA-128-OFB CAMELLIA-192-CBC CAMELLIA-192-CFB CAMELLIA-192-CFB1 CAMELLIA-192-CFB8 CAMELLIA-192-ECB CAMELLIA-192-OFB CAMELLIA-256-CBC CAMELLIA-256-CFB CAMELLIA-256-CFB1 CAMELLIA-256-CFB8 CAMELLIA-256-ECB CAMELLIA-256-OFB CAMELLIA128 CAMELLIA192 CAMELLIA256 CAST CAST-cbc CAST5-CBC CAST5-CFB CAST5-ECB CAST5-OFB DES DES-CBC DES-CFB DES-CFB1 DES-CFB8 DES-ECB DES-EDE DES-EDE-CBC DES-EDE-CFB DES-EDE-OFB DES-EDE3 DES-EDE3-CBC DES-EDE3-CFB DES-EDE3-CFB1 DES-EDE3-CFB8 DES-EDE3-OFB DES-OFB DES3 DESX DESX-CBC RC2 RC2-40-CBC RC2-64-CBC RC2-CBC RC2-CFB RC2-ECB RC2-OFB RC4 RC4-40 RC4-HMAC-MD5 SEED SEED-CBC SEED-CFB SEED-ECB SEED-OFB
```

Also, consult [cipher suite names mapping](https://www.openssl.org/docs/manmaster/man1/ciphers.html).

If none of the ciphers listed above works, please open a [GitHub issue](https://github.com/travis-ci/travis-ci/issues).

### Note on IP addresses

All notifications that use HTTP are sent through a proxy with static IP
addresess to ensure safelist and firewall rule stability.  The current IP
addresses are:

```
54.173.229.200
54.175.230.252
```

## Configuring email notifications

Specify recipients that will be notified about build results:

```yaml
notifications:
  email:
    - one@example.com
    - other@example.com
```

Turn off email notifications entirely:

```yaml
notifications:
  email: false
```

Specify when you want to [get notified](#Changing-notification-frequency):

```yaml
notifications:
  email:
    recipients:
      - one@example.com
      - other@example.com
    on_success: never # default: change
    on_failure: always # default: always
```

Pull Request builds do not trigger email notifications.

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

### Changing the email address for build notifications

Travis CI only sends build notifications to email addresses registered on GitHub.
If you have multiple addresses registered you can set the email address for a specific
 repository using `git`:

> Note that this also changes the commit email address, not just the Travis CI notification settings.

```bash
git config user.email "mynewemail@example.com"
```

Or set the email for all of your git repositories:

```bash
git config --global user.email "mynewemail@example.com"
```

Note that we currently don't respect the [detailed notifications
settings](https://github.com/settings/notifications) on
GitHub, as they're not exposed via an API at this point.

### Missing build notifications

The most common cause for not receiving build notifications, beyond not having a
user account on Travis CI, is the use of an email address that's not registered
and verified on GitHub. See above on how to change the email address to one
that's registered or make sure to add the email address used in this repository
to [your verified email addresses](https://github.com/settings/emails) on GitHub.

## Configuring IRC notifications

You can also specify notifications sent to an IRC channel:

```yaml
notifications:
  irc: "chat.freenode.net#my-channel"
```

Or multiple channels:

```yaml
notifications:
  irc:
    - "chat.freenode.net#my-channel"
    - "chat.freenode.net#some-other-channel"
    - "irc://chat.freenode.net:8000/#plaintext_channel"
    - "ircs://chat.freenode.net:7070/#ssl_tls_channel"
```

As with other notification types you can specify when IRC notifications will be sent:

```yaml
notifications:
  irc:
    channels:
      - "chat.freenode.net#my-channel"
      - "chat.freenode.net#some-other-channel"
    on_success: change # default: always
    on_failure: always # default: always
```

Customize the message that will be sent to the channel(s) with a template:

```yaml
notifications:
  irc:
    channels:
      - "chat.freenode.net#my-channel"
      - "chat.freenode.net#some-other-channel"
    template:
      - "%{repository} (%{commit}) : %{message} %{foo} "
      - "Build details: %{build_url}"
```

You can interpolate the following variables:

- *repository_slug*: your GitHub repo identifier (like `svenfuchs/minimal`)
- *repository_name*: the slug without the username
- *repository*: same as repository_slug [Deprecated]
- *build_number*: build number
- *build_id*: build id
- *branch*: branch build name
- *commit*: shortened commit SHA
- *author*: commit author name
- *commit_message*: commit message of build
- *commit_subject*: first line of the commit message
- *result*: result of build
- *message*: travis message to the build
- *duration*: total duration of all builds in the matrix
- *elapsed_time*: time between build start and finish
- *compare_url*: commit change view URL
- *build_url*: URL of the build detail

The default template is:

```yaml
notifications:
  irc:
    template:
      - "%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message}"
      - "Change view : %{compare_url}"
      - "Build details : %{build_url}"
```

If you want the bot to use notices instead of regular messages the `use_notice` flag can be used:

```yaml
notifications:
  irc:
    channels:
      - "chat.freenode.net#my-channel"
      - "chat.freenode.net#some-other-channel"
    on_success: change # default: always
    on_failure: always # default: always
    use_notice: true
```

and if you want the bot not to join before sending the messages, use the `skip_join` flag:

```yaml
notifications:
  irc:
    channels:
      - "chat.freenode.net#my-channel"
      - "chat.freenode.net#some-other-channel"
    on_success: change # default: always
    on_failure: always # default: always
    use_notice: true
    skip_join: true
```

If you enable `skip_join`, remember to remove the `NO_EXTERNAL_MSGS` flag (n) on the IRC channel(s) the bot notifies.

Pull Request builds do not trigger IRC notifications.

### Channel key

If you want the bot to send messages to channels protected with a channel key (ie, set with `/mode #channel +k password`), use the `channel_key` variable:

> Note: We highly recommend you [encrypt](/user/encryption-keys/) this value if
> your .travis.yml is stored in a public repository.
>
> ```bash
> travis encrypt password --add notifications.irc.channel_key
> ```

```yaml
notifications:
  irc:
    channels:
      - "chat.freenode.net#my-channel"
    channel_key: 'password'
```

### Password protected servers

You may also authenticate to an IRC server with user:

> Note: We highly recommend you [encrypt](/user/encryption-keys/) this value if
> your .travis.yml is stored in a public repository.
>
> ```bash
> travis encrypt password --add notifications.irc.channel_key
> travis encrypt password --add notifications.irc.password
> ```

```yaml
notifications:
  irc:
    channels:
      - "chat.freenode.net#my-channel"
    channel_key: 'password'
    nick: travisci
    password: super_secret
```

## Configuring campfire notifications

Notifications can also be sent to Campfire chat rooms, using the following format:

```yaml
notifications:
  campfire: [subdomain]:[api token]@[room id]
```

- *subdomain*: is your campfire subdomain (i.e. 'your-subdomain' if you visit '<https://your-subdomain.campfirenow.com'>)
- *api token*: is the token of the user you want to use to post the notifications.
- *room id*: this is the room id, not the name.

> Note: We highly recommend you [encrypt](/user/encryption-keys/) this value if
> your .travis.yml is stored in a public repository:
>
> ```bash
> travis encrypt subdomain:api_token@room_id --add notifications.campfire.rooms
> ```

You can also customise the notifications, like with [IRC notifications](#Configuring-IRC-notifications):

```yaml
notifications:
  campfire:
    rooms:
      - [subdomain]:[api token]@[room id]
    template:
      - "%{repository} (%{commit}) : %{message} %{foo} "
      - "Build details: %{build_url}"
```

Other flags, such as `on_success` and `on_failure` also work like they do in IRC notification configuration.

Pull Request builds do not trigger Campfire notifications.

## Configuring flowdock notifications

Notifications can be sent to your Flowdock Team Inbox using the following format:

```yaml
notifications:
  flowdock: [api token]
```

- *api token*: is your API Token for the Team Inbox you wish to notify. You may pass multiple tokens as a comma separated string or an array.

> Note: We highly recommend you [encrypt](/user/encryption-keys/) this value if your .travis.yml is stored in a public repository:
>
> ```bash
> travis encrypt api_token --add notifications.flowdock
> ```

Pull Request builds do not trigger Flowdock notifications.

## Configuring HipChat notifications

Send notifications to your HipChat rooms using the following key in your
`.travis.yml`:

```yaml
notifications:
  hipchat: [api token]@[room id or name]
```

- `api token`: token of the user you want to post the notifications as. One of
    * API v1 token your group administrator gives you.
    * API v2 token you manage.
- `hostname`: optional, defaults to api.hipchat.com, but can be specified for HipChat Server instances.
- `room id` or `name`: id or name (case-sensitive) of the room you want to notify. If your room name contains spaces then use room id.

> Always [encrypt](/user/encryption-keys/) this value if
> your `.travis.yml` is stored in a public repository:
>
> ```bash
> travis encrypt api_token@room_id_or_name --add notifications.hipchat.rooms
> ```

If you are running HipChat Server, specify the hostname like this instead:

```yaml
notifications:
  hipchat: [api token]@[hostname]/[room id or name]
```

HipChat notifications support templates too, so you can customize the appearance of the notifications, e.g. reduce it to a single line:

```yaml
notifications:
  hipchat:
    rooms:
      - [api token]@[room id or name]
    template:
      - '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message}'
```

If you want to send HTML notifications you need to add `format: html` like this
(note that this is not compatible with some features like @mentions and autolinking):

```yaml
notifications:
  hipchat:
    rooms:
      - [api token]@[room id or name]
    template:
      - '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message} (<a href="%{build_url}">Details</a>/<a href="%{compare_url}">Change view</a>)'
    format: html
```

With the V2 API, you can trigger a user notification by setting `notify: true`:

```yaml
notifications:
  hipchat:
    rooms:
      - [api token]@[room id or name]
    template:
      - '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message}'
    notify: true
```

### Setting the From value in notifications

When a V1 token is used, the notification is posted by "Travis CI".

With a V2 token, this value is set by the token's Label.
Create a special-purpose room notification token ("Tokens" under the room's "Administration" section)
with a desired label, and use this token.

<figure>
  <img src="/images/hipchat_token_screen.png" alt="HipChat Room Notification Tokens screenshot" width="550px" />
</figure>

### Notifications of PR builds

By default, Hipchat will be notified both for push builds and pull request
builds.

Turn pull request notifications off by adding `on_pull_requests: false` to the
`hipchat` section of your `.travis.yml`:


```yaml
notifications:
  hipchat:
    on_pull_requests: false
```

## Configuring Pushover notifications

Notifications can also be sent via [Pushover](https://pushover.net/) via the following format:

```yaml
notifications:
  pushover:
    api_key: [api token]
    users:
      - [user key]
```

- *api token*: API Token/Key for a Pushover Application (create this under "Your Applications" after logging in to Pushover; it's recommended to create one specific to Travis CI).
- *user key*: The User Key for a user to be notified (this can be seen after logging in to Pushover). A list of multiple users is supported.

> Note: We highly recommend you [encrypt](/user/encryption-keys/) these values
> if your .travis.yml is stored in a public repository; this will add (or
> overwrite) your api_token,
> and append the specified user_key to the list of users.
>
> ```bash
> travis encrypt [api_token] --add notifications.pushover.api_key
> travis encrypt [user_key] --add notifications.pushover.users --append
> ```

You can also customise the notifications, like with IRC notifications:

```yaml
notifications:
pushover:
  api_key: [api token]
  users:
    - [user key]
    - [user key]
  template: "%{repository} (%{commit}) : %{message} %{foo} - Build details: %{build_url}"
```

Other flags, such as `on_success` and `on_failure` also work like the IRC notification config.

Pull Request builds do not trigger Pushover notifications.

## Configuring slack notifications

Travis CI can send notifications to your [Slack](http://slack.com) channels
about build results.

On Slack, set up a [new Travis CI
integration](https://my.slack.com/services/new/travis).

<figure>
  <img alt="Screenshot of adding Slack integration" src="http://s3itch.paperplanes.de/slackintegration_20140313_075147.jpg"/>
</figure>

Copy and paste the settings, which already include the proper token, into
your `.travis.yml`, and you're good to go.

> Note: We highly recommend you [encrypt](/user/encryption-keys/) this value if
> your .travis.yml is stored in a public repository:
>
> ```bash
> travis encrypt "<account>:<token>" --add notifications.slack.rooms
> ```

The simplest configuration requires your account name and the token you just
generated.

```yaml
notifications:
  slack: '<account>:<token>'
```

To specify a different channel, add it to the configuration with a
`#` separating the channel from the account and token:

```yaml
notifications:
  slack: '<account>:<token>#development'
```

To specify a different channel when using with encrypted credentials use:

```bash
travis encrypt "<account>:<token>#channel" --add notifications.slack.rooms
```

You can specify multiple channels as well.

```yaml
notifications:
  slack:
    rooms:
      - <account>:<token>#development
      - <account>:<token>#general
    on_success: change # default: always
    on_failure: always # default: always
```

Similarly, you can use the channel override syntax with encrypted credentials as well.

```bash
travis encrypt "<account>:<token>#channel" --add notifications.slack.rooms
```

This is how a setup with encrypted credentials could look like:

```yaml
notifications:
  slack:
    rooms:
      - secure: "sdfusdhfsdofguhdfgubdsifgudfbgs3453durghssecurestringidsuag34522irueg="
    on_success: always
```

Once everything's setup, push a new commit and you should see something like the
screenshot below:


<figure>
  <img alt="Screenshot of sample Slack integration" src="http://s3itch.paperplanes.de/slackmessage_20140313_180150.jpg">
</figure>

### Notifications of PR builds

Turn pull request notifcations off by adding `on_pull_requests: false` to the `slack` section of your `.travis.yml`:

```yaml
notifications:
  slack:
    on_pull_requests: false
```

### Customizing slack notifications

Customize the notification message by editing the template, as in this example:

```yaml
notifications:
  slack:
    template:
      - "%{repository} (%{commit}) : %{message} %{foo} "
      - "Build details: %{build_url}"
```

The following variables are available:

- *repository_slug*: your GitHub repo identifier (like `svenfuchs/minimal`)
- *repository_name*: the slug without the username
- *build_number*: build number
- *build_id*: build id
- *branch*: branch build name
- *commit*: shortened commit SHA
- *author*: commit author name
- *commit_message*: commit message of build
- *commit_subject*: first line of the commit message
- *result*: result of build
- *message*: Travis CI message to the build
- *duration*: total duration of all builds in the matrix
- *elapsed_time*: time between build start and finish
- *compare_url*: commit change view URL
- *build_url*: URL of the build detail

The default template for push builds is:

```yaml
notifications:
  slack:
    template:
      - "Build <%{build_url}|#%{build_number}> (<%{compare_url}|%{commit}>) of %{repository}@%{branch} by %{author} %{result} in %{duration}"
```

while the default template for pull request builds is:

```yaml
notifications:
  slack:
    template:
    - "Build <%{build_url}|#%{build_number}> (<%{compare_url}|%{commit}>) of %{repository}@%{branch} in PR <%{pull_request_url}|#%{pull_request_number}> by %{author} %{result} in %{duration}"
```


See [Slack documentation](https://api.slack.com/docs/message-formatting)
for more information on message formatting.

## Configuring webhook notifications

You can define webhooks to be notified about build results:

```yaml
notifications:
  webhooks: http://your-domain.com/notifications
```

Or multiple URLs:

```yaml
notifications:
  webhooks:
    - http://your-domain.com/notifications
    - http://another-domain.com/notifications
```

As with other notifications types you can specify when webhook payloads will be sent:

```yaml
notifications:
  webhooks:
    urls:
      - http://hooks.mydomain.com/travisci
      - http://hooks.mydomain.com/events
    on_success: change # default: always
    on_failure: always # default: always
    on_start: change   # default: never
    on_cancel: always # default: always
    on_error: always # default: always
```

### Webhooks Delivery Format

Webhooks are delivered with a `application/x-www-form-urlencoded` content type using HTTP POST, with the body including a `payload` parameter that contains the JSON webhook payload in a URL-encoded format.

Here is the payload sent to [the Travis CI documentation application](https://github.com/travis-ci/docs-travis-ci-com):

<script src="https://gist.github.com/{{ site.env.WEBHOOK_PAYLOAD_GIST_ID }}.js" data-proofer-ignore></script>

You will see one of the following values in the `status`/`result` fields that represent the state of the build.

- *0*: Represents a build that has completed successfully
- *1*: Represents a build that has not yet completed or has completed and failed

Additionally a message will be present in the `status_message`/`result_message` fields that further describe the status of the build.

- *Pending*: A build has been requested
- *Passed*: The build completed successfully
- *Fixed*: The build completed successfully after a previously failed build
- *Broken*: The build completed in failure after a previously successful build
- *Failed*: The build is the first build for a new branch and has failed
- *Still Failing*: The build completed in failure after a previously failed build
- *Canceled*: The build was canceled
- *Errored*: The build has errored

The `type` field can be used to find the event type that caused this build to
run. Its value is one of `push`, `pull_request`, `cron`, or `api`.  For pull requests,
the `type` field will have the value `pull_request`, and a `pull_request_number` field
is included too, pointing to the pull request's issue number on GitHub.

To quickly identify the repository involved, we include a `Travis-Repo-Slug` header, with a format of `account/repository`, so for instance `travis-ci/travis-ci`.

### Verifying Webhook requests

To ensure the integrity of your workflow, we strongly encourage you to
verify the POST request before acting on it.

The POST request comes with the custom HTTP header `Signature`.
Using the published SSL public key, you can verify the signature of the
payload.

1. Pick up the `payload` data from the HTTP request's body.
2. Obtain the `Signature` header value, and base64-decode it.
3. Obtain the public key corresponding to the private key that signed
   the payload. This is available at the `/config` endpoint's
   `config.notifications.webhook.public_key` on the relevant API server.
   (e.g., <https://api.travis-ci.org/config>)
4. Verify the signature using the public key and SHA1 digest.

#### Examples

1. [WebhookSignatureVerifier](https://github.com/travis-ci/webhook-signature-verifier)
is a small Sinatra app which shows you how this works.

1. This documentation site receives a webhook notification, verifies the request
and updates the Gist showing the payload example above.
See [the code](https://github.com/travis-ci/docs-travis-ci-com/tree/master/_plugins/webhoook_payload_doc_handler.rb).

1. [Travis Webhook Checker](https://gist.github.com/andrewgross/8ba32af80ecccb894b82774782e7dcd4)
is an example Django view which implements this in Python.

1. [Travis Golang Hooks Verification](https://gist.github.com/theshapguy/7d10ea4fa39fab7db393021af959048e)
is a small webapp in Go which verifies the the hook.
