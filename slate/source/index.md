---
title: Travis CI - API Reference

language_tabs:
- http
- shell
- ruby

toc_footers:
- <a href='https://travis-ci.org'>Travis CI for Open Source</a>
- <a href='https://travis-ci.com'>Travis CI for Private Projects</a>
---

# Overview

```http
GET / HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.travis-ci.org
```

```http
GET / HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token "YOUR TRAVIS ACCESS TOKEN"
Host: api.travis-ci.com
```

```http
GET /api HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token "YOUR TRAVIS ACCESS TOKEN"
Host: travis.example.com
```

```shell
$ travis raw /
{"hello"=>"world"}

$ travis raw / --pro
{"hello"=>"world"}

$ travis raw / --api-endpoint https://travis.example.com/api
{"hello"=>"world"}
```

```ruby
require 'travis'

# talk to travis-ci.org via client object
client = Travis::Client.new
repository = client.repo('travis-ci/travis.rb')

# talk to travis-ci.org via Travis namespace
repository = Travis::Repository.find('travis-ci/travis.rb')

# talk to travis-ci.com via client object
client = Travis::Client.new('https://api.travis-ci.com')
client.access_token = 'YOUR TRAVIS ACCESS TOKEN'
repository = client.repo('travis-pro/billing')

# talk to travis-ci.com via Travis::Pro namespace
Travis::Pro.access_token = 'YOUR TRAVIS ACCESS TOKEN'
repository = Travis::Pro::Repository.find('travis-pro/billing')

# talk to travis.example.com via client object
client = Travis::Client.new('https://travis.example.com/api')
client.access_token = 'YOUR TRAVIS ACCESS TOKEN'
repository = client.repo('my/repo')

# talk to travis.example.com via custom namespace
My = Travis::Client::Namespaces.new('https://travis.example.com/api')
My.access_token = 'YOUR TRAVIS ACCESS TOKEN'
My::Repository.find('my/repo')
```

Welcome to the Travis CI API documentation. This is the API used by the official Travis CI web interface, so everything the web ui is able to do can also be accomplished via the API.

The first thing you will have to find out is the correct API endpoint to use.

- **Travis CI for open source:** For open source projects tested on [travis-ci.org](https://travis-ci.org), use **<https://api.travis-ci.org>**.
- **Travis Pro:** For private projects tested on [travis-ci.com](https://travis-ci.com), use **<https://api.travis-ci.com>**.
- **Travis Enterprise:** For projects running on a custom setup, use **[https://travis.example.com/api](<>)** (where you replace travis.example.com with the domain Travis CI is running on).

Note that both Pro and Enterprise will require almost all API calls to be [authenticated](#authentication).

# Making Requests

```http
GET / HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{"hello":"world"}
```

```shell
$ travis raw /
{"hello":"world"}
```

```ruby
require 'travis'

# You usually don't want to fire API requests manually
client = Travis::Client.new
client.get_raw('/') # => {"hello"=>"world"}

client.get('/repos/sinatra/sinatra')
# => {"repo"=>#<Travis::Client::Repository: sinatra/sinatra>}
```

<aside class="warning">
  If you do not set the **Accept** header, you might retrieve our old API formats. These are deprecated and will be removed soon.
</aside>

When you write your own Travis CI client, please keep the following in mind:

- Always set the **User-Agent** header. This header is not required right now, but will be in the near future. Assuming your client is called "My Client", and its current version is 1.0.0, a good value would be `MyClient/1.0.0`. For our command line client running on OS X 10.9 on Ruby 2.1.1, it might look like this: `Travis/1.6.8 (Mac OS X 10.9.2 like Darwin; Ruby 2.1.1; RubyGems 2.0.14) Faraday/0.8.9 Typhoeus/0.6.7`.
- Always set the **Accept** header to `application/vnd.travis-ci.2+json`.

Any existing client library should take care of these for you.

# External APIs

```http
GET /config HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "config": {
    "host": "travis-ci.org",
    "pusher": { "key": "5df8ac576dcccf4fd076" },
    "github": {
      "api_url": "https://api.github.com",
      "scopes": [
        "read:org", "user:email", "repo_deployment",
        "repo:status", "write:repo_hook"
      ]
    }
  }
}
```

```shell
$ travis raw /config
{"config"=>
  {"host"=>"travis-ci.org",
   "pusher"=>{"key"=>"5df8ac576dcccf4fd076"},
   "github"=>
    {"api_url"=>"https://api.github.com",
     "scopes"=>
      ["read:org",
       "user:email",
       "repo_deployment",
       "repo:status",
       "write:repo_hook"]}}}
```

```ruby
require 'travis'
client = Travis::Client.new
client.config
# => {"host"=>"travis-ci.org",
#     "pusher"=>{"key"=>"5df8ac576dcccf4fd076"},
#     "github"=>
#      {"api_url"=>"https://api.github.com",
#       "scopes"=>
#        ["read:org",
#         "user:email",
#         "repo_deployment",
#         "repo:status",
#         "write:repo_hook"]}}
```

Travis CI integrates with external services, some of which your client library might want to interface with directly.
Most prominently, it uses GitHub as source for users, organizations and repositories, and Pusher for live streaming logs.

You can ask the API for the connection details to these services by loading the `config` endpoint.

This includes, amongst other things:

- The GitHub API endpoint (this might be a GitHub enterprise endpoint) and the GitHub scopes currently required by Travis CI. These are the scopes you should use when [generating a temporary GitHub token](#creating-a-temporary-github-token) for authentication.
- The [Pusher](http://pusher.com/) application key. If the setup is running behind a firewall and uses [Slanger](https://github.com/stevegraham/slanger), it will also include the Slanger URL.

# Authentication

```http
GET /users HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.travis-ci.org
Authorization: token "YOUR TRAVIS ACCESS TOKEN"
```

```shell
$ travis whoami -t "YOUR TRAVIS ACCESS TOKEN"
```

```ruby
require 'travis'

# against the Travis namespace
Travis.access_token = 'YOUR TRAVIS ACCESS TOKEN'
Travis::User.current

# against a client object
client = Travis::Client.new(access_token: 'YOUR TRAVIS ACCESS TOKEN')
client.user
```

<aside class="notice">
Do not confuse the <i>access token</i> with the token found on your profile page.
</aside>

To authenticate against Travis CI, you need an API access token.

You can retrieve a token by using a GitHub token to prove who you are. In the future, we are planning to add a proper OAuth handshake for third party applications.

## With a GitHub token

```http
POST /auth/github HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.travis-ci.org
Content-Type: application/json
Content-Length: 37

{"github_token":"YOUR GITHUB TOKEN"}
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{"access_token":"YOUR TRAVIS ACCESS TOKEN"}
```

```shell
$ travis login --github-token "YOUR GITHUB TOKEN"
Successfully logged in!

$ travis token
Your access token is YOUR TRAVIS ACCESS TOKEN
```

```ruby
require 'travis'

# against the Travis namespace
Travis.github_auth(token)

# against a client object
client = Travis::Client.new
client.github_auth(token)
```

If you have a GitHub token, you can use the GitHub authentication endpoint to exchange it for an access token.
The Travis API server will not store the token or use it for anything else than verifying the user account.

Note that therefore the API cannot be used to create new user accounts. The user will have to log in at least once via the web interface before interfacing with the API by other means.

## Creating a temporary GitHub token

```http
POST /authorizations HTTP/1.1
Host: api.github.com
Content-Type: application/json
Authorization: Basic ...

{
  "scopes": [
    "read:org", "user:email", "repo_deployment",
    "repo:status", "write:repo_hook"
  ],
  "note": "temporary token to auth against travis"
}
```

```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1,
  "url": "https://api.github.com/authorizations/1",
  "scopes": [
    "read:org", "user:email", "repo_deployment",
    "repo:status", "write:repo_hook"
  ],
  "token": "YOUR GITHUB TOKEN",
  "note": "temporary token to auth against travis"
}
```

```http
POST /auth/github HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.travis-ci.org
Content-Type: application/json
Content-Length: 37

{"github_token":"YOUR GITHUB TOKEN"}
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{"access_token":"YOUR TRAVIS ACCESS TOKEN"}
```

```http
DELETE /authorizations/1 HTTP/1.1
Host: api.github.com
Authorization: Basic ...
```

```shell
$ travis login --auto
Successfully logged in!

$ travis token
Your access token is YOUR TRAVIS ACCESS TOKEN
```

```ruby
require 'travis'
require 'travis/tools/github'

# drop_token will make the token a temporary one
github = Travis::Tools::Github.new(drop_token: true) do |g|
  g.ask_login    = -> { print("GitHub login:     "); gets }
  g.ask_password = -> { print("Password:         "); gets }
  g.ask_otp      = -> { print("Two-factor token: "); gets }
end

github.with_token do |token|
  Travis.github_auth(token)
end

Travis.access_token # => "YOUR TRAVIS ACCESS TOKEN"
```

Since Travis CI will not store the GitHub token handed to it for authentication, it is possible to generate a temporary GitHub token and remove it again after the authentication handshake.

To create and delete the GitHub token, you can either use the [GitHub web interface](https://github.com/settings/applications) or automate it via the [GitHub API](https://developer.github.com/v3/oauth_authorizations/#create-a-new-authorization).

Make sure your GitHub token has the scopes [required](#external-apis) by Travis CI.

If you automate this process, authentication will become a handshake consisting of three requests:

- Create a GitHub token via the GitHub API, store GitHub token and URL.
- Use the `/auth/github` endpoint to exchange it for an access token. Store the access token.
- Delete the GitHub token via the GitHub API.

Some client libraries will automate this handshake for you.

## GitHub OAuth handshake

> Triggering an OAuth handshake between GitHub and Travis CI:

```html
<a href="https://api.travis-ci.com/auth/handshake">log in</a>
```

> Running the OAuth handshake in an iframe:

```html
<script>
  window.addEventListener("message", function(event) {
    console.log("received token: " + event.data.token);
  });

  var iframe = $('<iframe />').hide();
  iframe.appendTo('body');
  iframe.attr('src', "https://api.travis-ci.org/auth/post_message");
</script>
```

You can also trigger a full OAuth handshake between Travis CI and GitHub by opening `/auth/handshake` in a web browser. The endpoint takes an optional `redirect_to` query parameter, which takes a URL the web browser will end up on if the handshake is successful.

There is an alternative version of this that will try to run the handshake in a hidden iframe and using `window.postMessage` to hand the token to the website embedding the iframe. **This endpoint will only work for whitelisted websites.**

# Entities

## Accounts

```http
GET /accounts HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.travis-ci.org
Authorization: token "YOUR TRAVIS ACCESS TOKEN"
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
   "accounts" : [
      {
         "repos_count" : 167,
         "name" : "Konstantin Haase",
         "type" : "user",
         "id" : 267,
         "login" : "rkh"
      },
      {
         "repos_count" : 70,
         "name" : "Travis CI",
         "type" : "organization",
         "id" : 87,
         "login" : "travis-ci"
      }
   ]
}
```

```shell
$ travis accounts
rkh (Konstantin Haase): subscribed, 167 repositories
travis-ci (Travis CI): subscribed, 70 repositories
```

```ruby
require 'travis'
Travis.access_token = 'YOUR TRAVIS ACCESS TOKEN'

Travis.accounts.each do |account|
  puts "#{account.login} has #{account.repos_count}"
end
```

A user might have access to multiple accounts. This is usually the account corresponding to the user directly and one account per GitHub organization.

### Attributes

| Attribute   | Description                                         |
| ----------- | --------------------------------------------------- |
| id          | user or organization id                             |
| name        | account name on GitHub                              |
| login       | account login on GitHub                             |
| type        | `user` or `organization`                            |
| repos_count | number of repositories                              |
| subscribed  | whether or not the account has a valid subscription |

The `subscribed` attribute is only available on Travis Pro.

### List accounts

`GET /accounts`

| Parameter | Default | Description                                                               |
| --------- | ------- | ------------------------------------------------------------------------- |
| all       | false   | whether or not to include accounts the user does not have admin access to |

This request always needs to be authenticated.

## Branches

```http
GET /repos/rails/rails/branches HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "branches": [
    {
      "id": 22554234,
      "repository_id": 891,
      "commit_id": 6534402,
      "number": "15184",
      "config": {},
      "state": "created",
      "started_at": "2014-04-08T00:17:34Z",
      "finished_at": "2014-04-08T00:48:59Z",
      "duration": 30546,
      "job_ids": [],
      "pull_request": false
    }
  ]
}
```

```shell
$ travis branches -r rails/rails
v4.1.0:         #15184 created  Dont encourage aliases now that …
master:         #15183 created  Dont abbreviate that which needs…
4-1-0:          #15183 created  Dont encourage aliases now that …
4-1-stable:     #15185 created  Merge branch '4-1-0' into 4-1-st…
adequaterecord: #15158 passed   wrap the literal value before ha…
```

```ruby
require 'travis'

repository = Travis::Repository.find('rails/rails')
repository.branches
# => {"v4.1.0"          => #<Travis::Client::Build: rails/rails#15184>,
#      "master"         => #<Travis::Client::Build: rails/rails#15183>,
#      "4-1-0"          => #<Travis::Client::Build: rails/rails#15183>,
#      "4-1-stable"     => #<Travis::Client::Build: rails/rails#15185>,
#      "adequaterecord" => #<Travis::Client::Build: rails/rails#15158>,
#      "4-0-stable"     => #<Travis::Client::Build: rails/rails#15143>}
```

The branches API can be used to get information about the latest build on a given branch.

### Attributes

See [builds](#builds).

### List Branches

This will list the latest 25 branches.

`GET /repos/{repository.id}/branches`

`GET /repos/{+repository.slug}/branches`

### Show Branch

`GET /repos/{repository.id}/branches/{branch}`

`GET /repos/{+repository.slug}/branches/{branch}`

## Broadcasts

```http
GET /broadcasts HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "broadcasts": [
    {
      "id": 42,
      "message": "We're switching our build infrastructure on April 29."
    }
  ]
}
```

```shell
$ travis raw /broadcasts
{"broadcasts"=>[{"id"=>451, "message"=>"This is a broadcast!"}]}
```

```ruby
require 'travis'

Travis::Broadcast.current.each do |broadcast|
  puts broadcast.message
end
```

### Attributes

| Attribute | Description       |
| --------- | ----------------- |
| id        | broadcast id      |
| message   | broadcast message |

### List Broadcasts

`GET /broadcasts`

This request always needs to be authenticated.

## Builds

```http
GET /repos/sinatra/sinatra/builds HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "builds": [
    {
      "commit_id": 6534711,
      "config": { },
      "duration": 2648,
      "finished_at": "2014-04-08T19:52:56Z",
      "id": 22555277,
      "job_ids": [22555278, 22555279, 22555280, 22555281],
      "number": "784",
      "pull_request": true,
      "pull_request_number": "1912",
      "pull_request_title": "Example PR",
      "repository_id": 82,
      "started_at": "2014-04-08T19:37:44Z",
      "state": "failed"
    }
  ],
  "jobs": [ ],
  "commits": [ ]
}
```

```shell
$ travis history
...
$ travis show 15 # show build #15
...
$ travis restart 15
...
$ travis cancel 15
...
```

```ruby
require 'travis'
Travis.access_token = 'YOUR TRAVIS ACCESS TOKEN'

repository = Travis::Repository.find('my/repo')
repository.each_build do |build|
  # restart all the builds
  build.restart
end
```

### Attributes

| Attribute           | Description                                      |
| ------------------- | ------------------------------------------------ |
| id                  | build id                                         |
| repository_id       | repository id                                    |
| commit_id           | commit id                                        |
| number              | build number                                     |
| pull_request        | true or false                                    |
| pull_request_title  | PR title if pull_request is true                 |
| pull_request_number | PR number if  pull_request is true               |
| config              | build config (secure values and ssh key removed) |
| state               | build state                                      |
| started_at          | time the build was started                       |
| finished_at         | time the build finished                          |
| duration            | build duration                                   |
| job_ids             | list of job ids in the build matrix              |

Note that `duration` might not correspond to `finished_at - started_at` if the build was restarted at a later point.

### List Builds

`GET /builds`

| Parameter     | Default | Description                                                                                |
| ------------- | ------- | ------------------------------------------------------------------------------------------ |
| ids           |         | list of build ids to fetch                                                                 |
| repository_id |         | repository id the build belongs to                                                         |
| slug          |         | repository slug the build belongs to                                                       |
| number        |         | filter by build number, requires slug or repository_id                                     |
| after_number  |         | list build after a given build number (use for pagination), requires slug or repository_id |
| event_type    |         | limit build to given event type (`push` or `pull_request`)                                 |

You have to supply either `ids`, `repository_id` or `slug`.

`GET /repos/{repository.id}/builds`

| Parameter    | Default | Description                                                |
| ------------ | ------- | ---------------------------------------------------------- |
| number       |         | filter by build number                                     |
| after_number |         | list build after a given build number (use for pagination) |
| event_type   |         | limit build to given event type (`push` or `pull_request`) |

`GET /repos/{+repository.slug}/builds`

| Parameter    | Default | Description                                                |
| ------------ | ------- | ---------------------------------------------------------- |
| number       |         | filter by build number                                     |
| after_number |         | list build after a given build number (use for pagination) |
| event_type   |         | limit build to given event type (`push` or `pull_request`) |

### Show Build

`GET /builds/{build.id}`

`GET /repos/{repository.id}/builds/{build.id}`

`GET /repos/{+repository.slug}/builds/{build.id}`

### Cancel Build

`POST /builds/{build.id}/cancel`

This request always needs to be authenticated.

### Restart Build

`POST /builds/{build.id}/restart`

This request always needs to be authenticated.

## Caches

```http
GET /repos/travis-pro/billing/builds HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.com
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "caches": [
    {
      "repository_id": 51007,
      "size": 103677795,
      "slug": "cache--rvm-2.0.0--gemfile-Gemfile",
      "branch": "master",
      "last_modified": "2014-03-06T16:19:49Z"
    }
  ]
}
```

```shell
$ travis cache -r travis-pro/billing
On branch master:
cache--rvm-2.0.0--gemfile-Gemfile  last modified: 2014-03-06 11:19:49  size: 98.87 MiB

On branch mm-ruby-2.1:
cache--rvm-2.0.0--gemfile-Gemfile  last modified: 2013-12-28 09:42:21  size: 98.87 MiB
cache--rvm-2.1.0--gemfile-Gemfile  last modified: 2013-12-28 09:42:21  size: 88.02 MiB

Overall size of above caches: 371.08 MiB

$ travis cache -r travis-pro/billing --delete --branch mm-ruby-2.1
```

```ruby
require 'travis'

repository = Travis::Repository.find('travis-pro/billing')
repository.caches.each do |cache|
  # delete all caches!
  cache.delete if cache.branch == 'mm-ruby-2.1'
end

# or in a single request
repository.delete_caches(branch: 'mm-ruby-2.1')
```

### Attributes

| Attribute     | Description                               |
| ------------- | ----------------------------------------- |
| repository_id | id of the repository the cache belongs to |
| size          | compressed cache size in bytes            |
| slug          | cache slug (generated from env)           |
| branch        | branch the cache is for                   |
| last_modified | last time the cache was updated           |

### List caches

`GET /repos/{repository.id}/caches`

`GET /repos/{+repository.slug}/caches`

| Parameter | Default | Description                                                         |
| --------- | ------- | ------------------------------------------------------------------- |
| branch    |         | limit listed caches to those on given branch                        |
| match     |         | limit listed caches to those with `slug` containing the given value |

This request always needs to be authenticated.

### Delete caches

`DELETE /repos/{repository.id}/caches`

`DELETE /repos/{+repository.slug}/caches`

| Parameter | Default | Description                                               |
| --------- | ------- | --------------------------------------------------------- |
| branch    |         | only delete caches on given branch                        |
| match     |         | only delete caches with `slug` containing the given value |

This request always needs to be authenticated.

## Commits

```http
GET /repos/sinatra/sinatra/builds HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "builds": [ ],
  "jobs": [ ],
  "commits": [
    {
      "id": 1873023,
      "sha": "a18f211f6f921affd1ecd8c18691b40d9948aae5",
      "branch": "master",
      "message": "Merge pull request #25 from henrikhodne/add-responses-to-documentation\n\nAdd responses to documentation",
      "committed_at": "2013-04-15T09:44:31Z",
      "author_name": "Henrik Hodne",
      "author_email": "me@henrikhodne.com",
      "committer_name": "Henrik Hodne",
      "committer_email": "me@henrikhodne.com",
      "compare_url": "https://github.com/travis-ci/travis-api/compare/0f31ff4fb6aa...a18f211f6f92"
    }
  ]
}
```

```shell
$ travis history -r sinatra/sinatra
#784 failed:     master Merge pull request #861 from kant/patch-1
#783 passed:     v1.4.5 v1.4.5
#782 passed:     master v1.4.5
```

```ruby
require 'travis'

repository = Travis::Repository.find('my/repo')
repository.each_build do |build|
  puts build.commit.message
end
```

There is no API endpoint for resolving commits, however commit data might be included in other API responses, like [builds](#builds) or [jobs](#jobs).

### Attributes

| Attribute       | Description             |
| --------------- | ----------------------- |
| id              | commit id               |
| sha             | commit sha              |
| branch          | branch the commit is on |
| message         | commit message          |
| committed_at    | commit date             |
| author_name     | author name             |
| author_email    | author email            |
| committer_name  | committer name          |
| committer_email | committer email         |
| compare_url     | link to diff on GitHub  |

## Hooks

```http
PUT /hooks HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.org
Content-Type: application/json

{
  "hook": {
    "id": 42,
    "active": true
  }
}
```

```shell
$ travis enable -r my/repo
```

```ruby
require 'travis'
Travis.access_token = 'YOUR TRAVIS ACCESS TOKEN'
Travis.hooks.each { |hook| hook.enable }
```

### Attributes

See [repository](#repositories).

### List Hooks

`GET /hooks`

This request always needs to be authenticated.

### Enable/Disable Hook

`PUT /hooks`

| Parameter    | Default | Description                                   |
| ------------ | ------- | --------------------------------------------- |
| hook[id]     |         | id of the hook/repository                     |
| hook[active] | false   | whether to turn hook on (true) or off (false) |

`PUT /hooks/{hook.id}`

| Parameter    | Default | Description                                   |
| ------------ | ------- | --------------------------------------------- |
| hook[active] | false   | whether to turn hook on (true) or off (false) |

This request always needs to be authenticated.

## Jobs

```http
POST /jobs/42/restart HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.org
```

```shell
$ travis restart 1.2 -r my/repo
```

```ruby
require 'travis'
Travis.access_token = 'YOUR TRAVIS ACCESS TOKEN'

Travis.repos('my/repo').last_build.jobs.each do |job|
  job.restart if job.failed?
end
```

### Attributes

| Attribute      | Description                                     |
| -------------- | ----------------------------------------------- |
| id             | job id                                          |
| build_id       | build id                                        |
| repository_id  | repository id                                   |
| commit_id      | commit id                                       |
| log_id         | log id                                          |
| number         | job number                                      |
| config         | job config (secure values and ssh key removed)  |
| state          | job state                                       |
| started_at     | time the job was started                        |
| finished_at    | time the job finished                           |
| duration       | job duration                                    |
| queue          | job queue                                       |
| allow_failure  | whether or not job state influences build state |

### Fetch Job

`GET /jobs/{job.id}`

### Fetch multiple jobs

<aside class='notice'>Job entities are included in build payloads.</aside>

| Parameter | Default | Description            |
| --------- | ------- | ---------------------- |
| ids       |         | list of job ids        |
| state     |         | job state to filter by |
| queue     |         | job queue to filter by |

You need to provide exactly one of the above parameters.
If you provide `state` or `queue`, a maximum of 250 jobs will be returned.

### Cancel Job

`POST /jobs/{job.id}/cancel`

This request always needs to be authenticated.

### Restart Job

`POST /jobs/{job.id}/restart`

This request always needs to be authenticated.

## Logs

```http
GET /jobs/42/logs HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: text/plain
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type text/plain

Using worker: ...
```

```shell
$ travis logs
... logs ...
```

```ruby
require 'travis'

rails = Travis::Repository.find('rails/rails')
job   = rails.last_build.jobs.first

# this will live stream if the job is currently running
job.log.body do |part|
  print part
end
```

### Attributes

| Attribute | Description |
| --------- | ----------- |
| id        | log id      |
| job_id    | job id      |
| body      | log body    |

### Chunked Attributes

You can retrieve the chunked attributes instead of the normal attributes b adding the attribute `chunked=true` to the mime-type specified in the `Accept` header.

| Attribute | Description |
| --------- | ----------- |
| id        | log id      |
| job_id    | job id      |
| parts     | log parts   |

The `parts` will be an array of JSON objects with the following attributes:

| Attribute | Description  |
| --------- | ------------ |
| number    | part number  |
| content   | part content |

### Fetching a Log

`GET /logs/{log.id}`

### Fetching Logs as plain text

<aside class='warning'>The response will not be JSON but plain text.</aside>

`GET /jobs/{job.id}/logs`

This might be necessary if the log has been archived, in which case it will result in a redirect.

### Streaming Logs

To stream the logs, you will have to subscribe to the channel for the job the log belongs to on Pusher (channel is `job-{job.id}`) and listen for `job:log` events. The payload will have the same format as parts have in the chunked attributes API payloads.

## Permissions

```http
GET /users/permissions HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "permissions": [1, 2, 3],
  "admin": [1, 2],
  "pull": [],
  "push": [3]
}
```

```shell
$ travis repos
```

```ruby
require 'travis'
Travis.access_token = 'YOUR TRAVIS ACCESS TOKEN'

Travis.user.push_access.each do |repo|
  puts "has push access to #{repo.slug}"
end
```

The permissions endpoint will return arrays of repository ids:

| Key         | ids for                                   |
| ----------- | ----------------------------------------- |
| permissions | repositories the user has access to       |
| admin       | repositories the user has admin access to |
| pull        | repositories the user has pull access to  |
| push        | repositories the user has push access to  |

The pull access list is only relevant for private projects.

### Fetch Permissions

`GET /users/permissions`

This request always needs to be authenticated.

## Repository Keys

```http
GET /repos/sinatra/sinatra/key HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "public_key": "-----BEGIN RSA PUBLIC KEY-----\\nMIGJAoGBAOcx131amMqIzm5+FbZz+DhIgSDbFzjKKpzaN5UWVCrLSc57z64xxTV6\\nkaOTZmjCWz6WpaPkFZY+czfL7lmuZ/Y6UNm0vupvdZ6t27SytFFGd1/RJlAe89tu\\nGcIrC1vtEvQu2frMLvHqFylnGd5Gy64qkQT4KRhMsfZctX4z5VzTAgMBAAE=\\n-----END RSA PUBLIC KEY-----\\n",
  "fingerprint": "ef:39:56:6e:2a:09:a2:10:2e:b5:39:ac:3d:3e:e1:05"
}
```

```shell
$ travis pubkey -r travis-ci/travis-api
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCOmOkC6MYRH1w2ib3AIC00GNwmgr8ch3mNHZ16x6cvSMjc6cURZt9Hav6gz03P5+9e5Vw1ztm3hvPR+IJsyOV/CSsYf1Cgboj6ZJ7tr3xOJXcqcMVfiGiG7Km6/psRdn0jrjTpU/qcru8Wx3zbQEf5NuXQyMVHmnl8/5w0WPV/Uw==

$ travis pubkey --pem -r travis-ci/travis-api
-----BEGIN RSA PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCOmOkC6MYRH1w2ib3AIC00GNwm
gr8ch3mNHZ16x6cvSMjc6cURZt9Hav6gz03P5+9e5Vw1ztm3hvPR+IJsyOV/CSsY
f1Cgboj6ZJ7tr3xOJXcqcMVfiGiG7Km6/psRdn0jrjTpU/qcru8Wx3zbQEf5NuXQ
yMVHmnl8/5w0WPV/UwIDAQAB
-----END RSA PUBLIC KEY-----

$ travis pubkey --fingerprint -r travis-ci/travis-api
99:66:93:03:41:0b:f1:f7:61:83:16:61:fa:47:c0:8f
```

```ruby
require 'travis'
repo = Travis::Repository.find('travis-ci/travis-api')

puts "SSH format:  ", repo.key.to_ssh
puts "PEM format:  ", repo.key.to_s
puts "Fingerprint: ", repo.key.fingerprint
puts repository.encrypt("example")
```

| Attribute   | Description                    |
| ----------- | ------------------------------ |
| key         | public key                     |
| fingerprint | fingerprint for the public key |

This key can be used to encrypt (but not decrypt) secure env vars.

### Fetch a Public Key

`GET /repos/{repository.id}/key`

`GET /repos/{+repository.slug}/key`

### Generate a Public Key

`POST /repos/{repository.id}/key`

`POST /repos/{+repository.slug}/key`

This will invalidate the current key, thus also rendering all encrypted variables invalid.

This request always needs to be authenticated.

## Repositories

```http
GET /repos/sinatra/sinatra HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "repo": {
    "id": 82,
    "slug": "sinatra/sinatra",
    "description": "Classy web-development dressed in a DSL",
    "last_build_id": 23436881,
    "last_build_number": "792",
    "last_build_state": "passed",
    "last_build_duration": 2542,
    "last_build_started_at": "2014-04-21T15:27:14Z",
    "last_build_finished_at": "2014-04-21T15:40:04Z",
    "active": "true"
  }
}
```

```shell
$ travis show -r travis-ci/travis-api
...
```

```ruby
require 'travis'
repos = Travis::Repository.find_all(owner_name: 'sinatra')
repos.each do |repo|
  puts repo.slug
end
```

### Attributes

| Attribute              | Description                         |
| ---------------------- | ----------------------------------- |
| id                     | repository id                       |
| slug                   | repository slug                     |
| description            | description on github               |
| last_build_id          | build id of the last build          |
| last_build_number      | build number of the last build      |
| last_build_state       | build state of the last build       |
| last_build_duration    | build duration of the last build    |
| last_build_started_at  | build started at of the last build  |
| last_build_finished_at | build finished at of the last build |
| active                 | repository's active status          |

### Fetch Repository

`GET /repos/{repository.id}`

`GET /repos/{+repository.slug}`

### Find Repositories

| Parameter  | Default | Description                                                               |
| ---------- | ------- | ------------------------------------------------------------------------- |
| ids        |         | list of repository ids to fetch, cannot be combined with other parameters |
| member     |         | filter by user that has access to it (github login)                       |
| owner_name |         | filter by owner name (first segment of slug)                              |
| slug       |         | filter by slug                                                            |
| search     |         | filter by search term                                                     |
| active     | `false` | if `true`, will only return repositories that are enabled                 |

If no parameters are given, a list or repositories with recent activity is returned.

## Requests

```http
GET /requests/6301283 HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "request": {
    "id": 6301283,
    "repository_id": 1121945,
    "commit_id": 5904016,
    "created_at": "2014-03-08T15:54:07Z",
    "owner_id": 4279,
    "owner_type": "Organization",
    "event_type": "push",
    "result": "accepted",
    "pull_request": false,
    "branch": "feat-container-injector"
  },
  "commit": {
    "id": 5904016,
    "sha": "09e2ce14f1debea64a1122851fc3f8f1c1a18ebc",
    "branch": "feat-container-injector",
    "message": "don't inject the service_container",
    "committed_at": "2014-03-08T15:53:42Z",
    "author_name": "Sebastiaan Stok",
    "author_email": "s.stok@rollerscapes.net",
    "committer_name": "Sebastiaan Stok",
    "committer_email": "s.stok@rollerscapes.net",
    "compare_url": "https://github.com/..."
  }
}
```

```shell
$ travis requests -r my/repo
...
```

```ruby
require 'travis'

Travis::Repository.find('sinatra/sinatra').requests.each do |request|
  puts "#{request.commit.sha}: #{request.result}"
end
```

Requests can be used to see if and why a GitHub even has or has not triggered a new build.

### Attributes

| Attribute           | Description                                                   |
| ------------------- | ------------------------------------------------------------- |
| id                  | request id                                                    |
| commit_id           | commit id                                                     |
| repository_id       | repository id                                                 |
| created_at          | created at                                                    |
| owner_id            | owner id                                                      |
| owner_type          | owner type (`"User"` or `"Organization"`)                     |
| event_type          | event type (`"push"` or `"pull_request"`)                     |
| base_commit         | base commit for pull requests                                 |
| head_commit         | head commit for pull requests                                 |
| result              | `"accepted"`, `"rejected"` or `null`                          |
| message             | human readable message explaining why event has been rejected |
| pull_request        | `true` or `false`                                             |
| pull_request_number | pull request number                                           |
| pull_request_title  | pull request title                                            |
| branch              | branch commit is on                                           |
| tag                 | tag if commit has been tagged                                 |

### Show Request

`GET /requests/{request.id}`

### List Requests

`GET /requests`

| Parameter     | Default | Description                                                              |
| ------------- | ------- | ------------------------------------------------------------------------ |
| repository_id |         | repository id the requests belong to                                     |
| slug          |         | repository slug the requests belong to                                   |
| limit         | 25      | maximum number of requests to return (cannot be larger than 100)         |
| older_than    |         | list requests before `older_than` (with `older_than` being a request id) |

You have to either provide `repository_id` or `slug`.

## Settings: General

```http
GET /repos/82/settings HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "settings": {
    "builds_only_with_travis_yml": true,
    "build_pushes": true,
    "build_pull_requests": true,
    "maximum_number_of_builds": 0
  }
}
```

```shell
$ travis settings
Settings for travis-ci/travis-api:
[-] builds_only_with_travis_yml    Only run builds with a .travis.yml
[+] build_pushes                   Build pushes
[+] build_pull_requests            Build pull requests
  0 maximum_number_of_builds       Maximum number of concurrent builds

$ travis settings build_pull_requests --enable
```

```ruby
require 'travis'
Travis.access_token = 'YOUR TRAVIS ACCESS TOKEN'
repo = Travis::Repository.find('my/repo')
repo.settings.build_pull_requests = false
repo.settings.save
```

### Attributes

| Attribute                   | Description                                                |
| --------------------------- | ---------------------------------------------------------- |
| builds_only_with_travis_yml | "builds only with .travis.yml" setting (`true` or `false`) |
| build_pushes                | "build pushes" setting (`true` or `false`)                 |
| build_pull_requests         | "build pull requests" setting (`true` or `false`)          |
| maximum_number_of_builds    | "maximum number of concurrent builds" setting (integer)    |

### Retrieve Settings

`GET /repos/{repository.id}/settings`

This request always needs to be authenticated.

### Update Settings

`PATCH /repos/{repository.id}/settings`

| Parameter | Default | Description                                                                       |
| --------- | ------- | --------------------------------------------------------------------------------- |
| settings  | `{}`    | Hash map of settings that should be updated and their new values (see Attributes) |

This request always needs to be authenticated.

## Settings: Environment Variables

```http
GET /settings/env_vars?repository_id=124920 HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "env_vars":[
    {
      "id": "018e66f2-cd3a-4295-aa1d-018fe9aa0fb4",
      "name": "example",
      "value": "foobar",
      "public": true,
      "repository_id": 124920
    },
    {
      "id": "ec9423da-9658-4cd6-b282-fd0e5f6ed2df",
      "name": "secret_example",
      "public": false,
      "repository_id": 124920
    }
  ]
}
```

```shell
$ travis env list
example=foobar
secret_example=[secure]
```

```ruby
require 'travis'
Travis.access_token  = 'YOUR TRAVIS ACCESS TOKEN'
repo                 = Travis::Repository.find('my/repo')
repo.env_vars['foo'] = bar
```

### Attributes

| Attribute     | Description                                               |
| ------------- | --------------------------------------------------------- |
| id            | env var id                                                |
| repository_id | repository id                                             |
| name          | env var name (exported)                                   |
| value         | env var value (exported, only included if public is true) |
| public        | whether or not value is public                            |

### List Variables

`GET /repos/settings/env_vars?repository_id={repository.id}`

This request always needs to be authenticated.

### Fetch Variable

`GET /repos/settings/env_vars/{env_var.id}?repository_id={repository.id}`

This request always needs to be authenticated.

### Add Variable

`POST /repos/settings/env_vars?repository_id={repository.id}`

| Parameter      | Default | Description                              |
| -------------- | ------- | ---------------------------------------- |
| env_var        |         | Hash map of env var variable (see below) |
| env_var.name   |         | Name of the new env var (string)         |
| env_var.value  |         | Value of the new env var (string)        |
| env_var.public | false   | whether or not to display the value      |

This request always needs to be authenticated.

### Update Variable

`PATCH /repos/settings/env_vars/{env_var.id}`

| Parameter      | Default       | Description                              |
| -------------- | ------------- | ---------------------------------------- |
| env_var        |               | Hash map of env var variable (see below) |
| env_var.name   | current value | Name of the new env var (string)         |
| env_var.value  | current value | Value of the new env var (string)        |
| env_var.public | current value | whether or not to display the value      |

This request always needs to be authenticated.

### Delete Variable

`DELETE /repos/settings/env_vars/{env_var.id}`

This request always needs to be authenticated.

## Settings: SSH Key

<aside class="notice">
This API is only available on Travis Pro.
</aside>

```http
GET /settings/ssh_key/124920 HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.com
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "ssh_key": {
    "description": "my custom key",
    "fingerprint": "99:66:93:03:41:0b:f1:f7:61:83:16:61:fa:47:c0:8f"
  }
}
```

```shell
$ travis sshkey
No custom SSH key installed.
```

```ruby
require 'travis/pro'
Travis::Pro.access_token = 'YOUR TRAVIS ACCESS TOKEN'
puts Travis::Pro::Repository.find('my/repo').ssh_key.description
```

### Attributes

| Attribute   | Description                               |
| ----------- | ----------------------------------------- |
| id          | ssh key id (corresponds to repository id) |
| description | key description                           |
| fingerprint | key fingerprint                           |

### Fetch Key

`GET /settings/ssh_key/#{ssh_key.id}`

This request always needs to be authenticated.

### Update or Create Key

`PATCH /settings/ssh_key/#{ssh_key.id}`

| Parameter           | Default                | Description                          |
| ------------------- | ---------------------- | ------------------------------------ |
| ssh_key             |                        | Hash map of ssh key data (see below) |
| ssh_key.description | current value or empty | key description                      |
| ssh_key.value       |                        | private key (required)               |

This request always needs to be authenticated.

### Delete Key

`DELETE /settings/ssh_key/#{ssh_key.id}`

This request always needs to be authenticated.

## Users

```http
GET /users/ HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Authorization: token YOUR TRAVIS ACCESS TOKEN
Host: api.travis-ci.org
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "user": {
    "id": 267,
    "name": "Konstantin Haase",
    "login": "rkh",
    "email": "github@rkh.im",
    "gravatar_id": "5c2b452f6eea4a6d84c105ebd971d2a4",
    "is_syncing": false,
    "synced_at": "2014-02-27T18:53:43Z",
    "correct_scopes": false,
    "created_at": "2011-03-30T16:25:21Z"
  }
}
```

```shell
$ travis whoami
You are rkh (Konstantin Haase)

$ travis sync
synchronizing: ... done
```

```ruby
require 'travis'
Travis.access_token = 'YOUR TRAVIS ACCESS TOKEN'
puts Travis.user.name
Travis.user.sync
```

### Attributes

| Attribute      | Description                                           |
| -------------- | ----------------------------------------------------- |
| id             | user id                                               |
| login          | user login on github                                  |
| name           | user name  on github                                  |
| email          | primary email address on github                       |
| gravatar_id    | avatarid                                              |
| is_syncing     | whether or not user account is currently being synced |
| synced_at      | last synced at                                        |
| correct_scopes | whether or not github token has the correct scopes    |
| channels       | pusher channels for this user                         |

### Show User

`GET /users/`

`GET /users/{user.id}`

This request always needs to be authenticated.

### Sync Users

`POST /users/sync`

Triggers a new sync with GitHub. Might return status `409` if the user is currently syncing.

This request always needs to be authenticated.

# Other Endpoints

## Linting

```http
PUT /lint/ HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.travis-ci.org
Content-Type: text/yaml

language: ruby
jdk: default
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "lint": {
    "warnings": [
      {
        "key": ["jdk"],
        "message": "specified jdk, but ruby does not include jruby"
      }
    ]
  }
}
```

```shell
$ travis lint example.yml
Warnings for example.yml:
[x] dropping jdk section: specified jdk, but ruby does not include jruby
```

```ruby
require 'travis'

content = <<-YAML
  language: ruby
  jdk: default
YAML

Travis.lint(content).warnings.each do |warning|
  puts "%p: %s" % [warning.key, warning.message]
end
```

`POST /lint`

| Parameter | Default | Description                  |
| --------- | ------- | ---------------------------- |
| content   |         | content of the `.travis.yml` |

`PUT /lint`

This is an alternative endpoint to the `POST` with parameter, to make it work well with tools like `curl` (`curl -T .travis.yml api.travis-ci.org/lint`). The request body can contain the YAML file directly.

# API Clients

There are a few API clients out there you can use for interacting with the Travis API, rather than manually triggering HTTP requests and parsing the responses.

## Official

The following clients are maintained by the Travis CI team:

- **[travis.rb](https://github.com/travis-ci/travis.rb)**: Command line client and Ruby library
- **[travis-web](https://github.com/travis-ci/travis-web)**: Web interface and JavaScript library, using Ember.js
- **[travis-sso](https://github.com/travis-ci/travis-sso)**: Single-Sign-On Rack middleware for Travis CI applications

## Web Browsers

> API requests using CORS:

```html
<script>
  // using XMLHttpRequest or XDomainRequest to send an API request
  var req = window.XDomainRequest ? new XDomainRequest() : new XMLHttpRequest();

  if(req) {
    req.open("GET", "https://api.travis-ci.org/", true);
    req.onreadystatechange = function() { alert("it worked!") };
    req.setRequestHeader("Accept", "application/vnd.travis-ci.2+json");
    req.send();
  }
</script>
```

> With jQuery:

```html
<script>
$.ajax({
  url: "https://api.travis-ci.org/",
  headers: { Accept: "application/vnd.travis-ci.2+json" },
  success: function() { alert("it worked!") }
});
</script>
```

> JSONP

```html
<script>
  function jsonpCallback() { alert("it worked!") };
</script>
<script src="https://api.travis-ci.org/?callback=jsonpCallback"></script>
```

When writing an in-browser client, you have to circumvent the browser's
[same origin policy](http://en.wikipedia.org/wiki/Same_origin_policy).
Generally, we offer two different approaches for this:
[Cross-Origin Resource Sharing](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing) (aka CORS)
and [JSONP](http://en.wikipedia.org/wiki/JSONP). If you don't have any good
reason for using JSONP, we recommend you use CORS.

### Cross-Origin Resource Sharing

All API resources set appropriate headers to allow Cross-Origin requests. Be
aware that on Internet Explorer you might have to use a different interface to
send these requests.

In contrast to JSONP, CORS does not lead to any execution of untrusted code.

Most JavaScript frameworks, like [jQuery](http://jquery.com), take care of CORS
requests for you under the hood, so you can just do a normal *ajax* request.

Our current setup allows the headers `Content-Type`, `Authorization`, `Accept` and the HTTP methods `HEAD`, `GET`, `POST`, `PATCH`, `PUT`, `DELETE`.

### JSONP

You can disable the same origin policy by treating the response as JavaScript.
Supply a `callback` parameter to use this.

This has the potential of code injection, use with caution.

## Third Party

Besides the official clients, there is a range of third party client available, amongst these:

- **[PHP Travis Client](https://github.com/l3l0/php-travis-client)**: PHP client library
- **[Travis Node.js](https://github.com/pwmckenna/node-travis-ci)**: Node.js client library
- **[travis-api-wrapper](https://github.com/cmaujean/travis-api-wrapper)**: Asynchronous Node.js wrapper
- **[travis-ci](https://github.com/mmalecki/node-travis-ci)**: Thin Node.js wrapper
- **[TravisMiner](https://github.com/smcintosh/travisminer)**: Ruby library for mining the Travis API
- **[TravisPy](http://travispy.readthedocs.org/en/latest/)**: Python library trying to closely mimic the official Ruby client
