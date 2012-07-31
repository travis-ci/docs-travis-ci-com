---
title: The Travis API
layout: en
permalink: api/
---

### Repositories

#### Index

    http://travis-ci.org/repositories.json

#### Response (<http://travis-ci.org/repositories.json>)

    [
      {
        "last_build_started_at": "2012-06-21T12:00:59Z", 
        "last_build_status": null, 
        "description": "A repository of CocoaPods specifications.", 
        "last_build_result": null, 
        "last_build_number": "628", 
        "slug": "CocoaPods/Specs", 
        "last_build_language": null, 
        "last_build_id": 1673195, 
        "last_build_finished_at": null, 
        "id": 8424, 
        "last_build_duration": null
      },
      ...
    ]

#### Index by owner

    http://travis-ci.org/repositories.json?owner_name=:owner

#### Response (<http://travis-ci.org/repositories.json?owner_name=travis-ci>)

    [
      {
        "last_build_started_at": "2012-06-21T10:23:31Z", 
        "last_build_status": 1, 
        "description": "Travis Worker manages VMs and runs your tests. It is the key component of Travis. See also https://github.com/travis-ci/travis-cookbooks", 
        "last_build_result": 1, 
        "last_build_number": "807", 
        "slug": "travis-ci/travis-worker", 
        "last_build_language": null, 
        "last_build_id": 1672557, 
        "last_build_finished_at": "2012-06-21T10:49:24Z", 
        "id": 409, 
        "last_build_duration": 1693
      },
      ...
    ]
#### Index search

    http://travis-ci.org/repositories.json?search=:query

#### Response (<http://travis-ci.org/repositories.json?search=requests>)

    [
      {
        "last_build_started_at": "2012-06-21T12:05:37Z", 
        "last_build_status": null, 
        "description": "Python HTTP Requests for Humans\u2122.", 
        "last_build_result": null, 
        "last_build_number": "377", 
        "slug": "kennethreitz/requests", 
        "last_build_language": null, 
        "last_build_id": 1673216, 
        "last_build_finished_at": null, 
        "id": 8276, 
        "last_build_duration": null
      },
      ...
    ]

[Hurl](http://hurl.it/hurls/919a2b3a2ac6dd60239c2548b183fc0a7ba49890/863c0ad50ec63156ec169be3a542d4408fe02d42)

#### Show

    http://travis-ci.org/:owner_name/:name.json

#### Response (<http://travis-ci.org/travis-ci/travis-ci.json>)

    {
      "last_build_started_at": "2012-06-20T11:48:28Z", 
      "public_key": "-----BEGIN RSA PUBLIC KEY-----\nMIGJAoGBAOcx131amMqIzm5+FbZz+DhIgSDbFzjKKpzaN5UWVCrLSc57z64xxTV6\nkaOTZmjCWz6WpaPkFZY+czfL7lmuZ/Y6UNm0vupvdZ6t27SytFFGd1/RJlAe89tu\nGcIrC1vtEvQu2frMLvHqFylnGd5Gy64qkQT4KRhMsfZctX4z5VzTAgMBAAE=\n-----END RSA PUBLIC KEY-----\n", 
      "last_build_status": 0, 
      "description": "A distributed build system for the open source community.", 
      "last_build_result": 0, 
      "last_build_number": "1937", 
      "slug": "travis-ci/travis-ci", 
      "last_build_language": null, 
      "last_build_id": 1664040, 
      "last_build_finished_at": "2012-06-20T11:51:27Z", 
      "id": 59, 
      "last_build_duration": 179
    }

[Hurl](http://hurl.it/hurls/1a475b8b354d98647764c8f7d863f5732c2dbc18/33e7c4e5c62612cdbeac17917c6ebd9f8d3d6344)

### Builds

#### Index

    http://travis-ci.org/:owner_name/:name/builds.json

#### Response (<http://travis-ci.org/travis-ci/travis-ci/builds.json>)

    [
      {
        "repository_id": 59, 
        "event_type": "push", 
        "finished_at": "2012-06-20T11:51:27Z", 
        "number": "1937", 
        "state": "finished", 
        "result": 0, 
        "branch": "master", 
        "duration": 179, 
        "commit": "70fda3be3643ecc6ab0e744000f466445fc27219", 
        "message": "update travis-core and other bits", 
        "started_at": "2012-06-20T11:48:28Z", 
        "id": 1664040
      },
      ...
    ]

[Hurl](http://hurl.it/hurls/7f51dc1660a6b915159498c19e493637c6395443/ef84212b3be1a146ff07804ec93c689afb81ef72)

#### Show

    http://travis-ci.org/:owner_name/:name/builds/:id.json

#### Response (<http://travis-ci.org/travis-ci/travis-ci/builds/63812.json>)

    {
      "status": 0, 
      "repository_id": 59, 
      "committer_email": "josh.kalderimis@gmail.com", 
      "committer_name": "Josh Kalderimis", 
      "author_email": "josh.kalderimis@gmail.com", 
      "finished_at": "2012-06-20T11:51:27Z", 
      "matrix": [
        {
          "repository_id": 59, 
          "finished_at": "2012-06-20T11:51:27Z", 
          "number": "1937.1", 
          "allow_failure": false, 
          "result": 0, 
          "started_at": "2012-06-20T11:48:28Z", 
          "config": {
            "before_script": [
              "cp config/database.example.yml config/database.yml"
            ], 
            "language": "ruby", 
            "script": "RAILS_ENV=test bundle exec rake test:ci --trace", 
            "bundler_args": "--without development", 
            "notifications": {
              "irc": "irc.freenode.org#travis", 
              "campfire": {
                "secure": "JJezWGD9KJY/LC2aznI3Zyohy31VTIhcTKX7RWR4C/C8YKbW9kZv3xV6Vn11\nSHxJTeZo6st2Bpv6tjlWZ+HCR09kyCNavIChedla3+oHOiuL0D4gSo+gkTNW\nUKYZz9mcQUd9RoQpTeyxvdvX+l7z62/7JwFA7txHOqxbTS8jrjc="
              }
            }, 
            "before_install": [
              "gem install bundler --pre"
            ], 
            "rvm": "1.9.3", 
            ".result": "configured"
          }, 
          "id": 1664041
        }
      ], 
      "number": "1937", 
      "author_name": "Josh Kalderimis", 
      "compare_url": "https://github.com/travis-ci/travis-ci/compare/c0c19cc3af2b...70fda3be3643", 
      "committed_at": "2012-06-20T11:48:18Z", 
      "state": "finished", 
      "result": 0, 
      "branch": "master", 
      "duration": 179, 
      "commit": "70fda3be3643ecc6ab0e744000f466445fc27219", 
      "message": "update travis-core and other bits", 
      "started_at": "2012-06-20T11:48:28Z", 
      "config": {
        "before_script": [
          "cp config/database.example.yml config/database.yml"
        ], 
        "language": "ruby", 
        "script": "RAILS_ENV=test bundle exec rake test:ci --trace", 
        "bundler_args": "--without development", 
        "notifications": {
          "irc": "irc.freenode.org#travis", 
          "campfire": {
            "secure": "JJezWGD9KJY/LC2aznI3Zyohy31VTIhcTKX7RWR4C/C8YKbW9kZv3xV6Vn11\nSHxJTeZo6st2Bpv6tjlWZ+HCR09kyCNavIChedla3+oHOiuL0D4gSo+gkTNW\nUKYZz9mcQUd9RoQpTeyxvdvX+l7z62/7JwFA7txHOqxbTS8jrjc="
          }
        }, 
        "before_install": [
          "gem install bundler --pre"
        ], 
        "rvm": [
          "1.9.3"
        ], 
        ".result": "configured"
      }, 
      "id": 1664040, 
      "event_type": "push"
    }

[Hurl](http://hurl.it/hurls/e69fc3c78fe69ed27e4ef772af5ac6bf005bffce/af2ecf26f637b4cf16b112a35179f9c4277d5b0c)

### Workers

#### Index

    http://travis-ci.org/workers.json

#### Response (<http://travis-ci.org/workers.json>)

    [
      {
        "name": "jvm-3", 
        "last_error": null, 
        "state": "working", 
        "id": 60999, 
        "host": "jvm-otp1.worker.travis-ci.org", 
        "last_seen_at": "2012-06-21T12:23:04Z", 
        "payload": {
          "repository": {
            "source_url": "git://github.com/libgit2/libgit2.git", 
            "id": 11467, 
            "slug": "libgit2/libgit2"
          }, 
          "type": "test", 
          "queue": "builds.jvmotp", 
          "job": {
            "commit": "221cc5f07a8adb9f3a4924360ee9c291bddaeb20", 
            "ref": "refs/pull/781/merge", 
            "id": 1673402, 
            "branch": "development", 
            "number": "439.1"
          }, 
          "build": {
            "commit": "221cc5f07a8adb9f3a4924360ee9c291bddaeb20", 
            "ref": "refs/pull/781/merge", 
            "id": 1673402, 
            "branch": "development", 
            "number": "439.1"
          }, 
          "config": {
            "branches": {
              "only": [
                "development"
              ]
            }, 
            "env": "OPTIONS=\"-DTHREADSAFE=ON -DCMAKE_BUILD_TYPE=Release\"", 
            "language": "erlang", 
            "script": [
              "mkdir _build", 
              "cd _build", 
              "cmake .. -DCMAKE_INSTALL_PREFIX=../_install $OPTIONS", 
              "cmake --build . --target install"
            ], 
            "notifications": {
              "email": {
                "on_failure": "always", 
                "on_success": "change"
              }, 
              "recipients": [
                "vicent@github.com"
              ]
            }, 
            "after_script": [
              "ctest -V ."
            ], 
            "install": [
              "sudo apt-get install -qq cmake"
            ], 
            ".result": "configured"
          }
        }
      },
      ...
    ]


### Jobs

#### Index

    http://travis-ci.org/jobs.json

#### Response (<http://travis-ci.org/jobs.json>)

#### Show

    http://travis-ci.org/jobs/:id.json

#### Response (<http://travis-ci.org/jobs/1772523.json>)
    {
      "finished_at": "2012-06-21T10:37:41Z", 
      "number": "720.2", 
      "author_name": "Shane Tomlinson", 
      "result": 0, 
      "message": "Add idp_auth_complete to the page_request_test.\n\nissue #1794", 
      "started_at": "2012-06-21T10:28:38Z", 
      "id": 1672523, 
      "build_id": 1672521, 
      "repository_id": 8339, 
      "committer_email": "stomlinson@mozilla.com", 
      "log": ""
      "author_email": "stomlinson@mozilla.com", 
      "state": "finished", 
      "branch": "issue_1794_idp_auth_complete_page_request_test", 
      "config": {
        "before_script": [
          "export DISPLAY=:99.0", 
          "sh -e /etc/init.d/xvfb start"
        ], 
        ".result": "configured", 
        "language": "node_js", 
        "node_js": 0.59999999999999998, 
        "notifications": {
          "irc": {
            "channels": [
              "irc.mozilla.org#identity"
            ], 
            "skip_join": false, 
            "use_notice": false
          }, 
          "email": [
            "lloyd@mozilla.com", 
            "jbonacci@mozilla.com", 
            "jrgm@mozilla.com"
          ]
        }, 
        "before_install": [
          "sudo apt-get install -qq libgmp3-dev", 
          "mysql -e 'create database browserid;'"
        ], 
        "env": "WHAT_TESTS=back_mysql MYSQL_USER=root", 
        "mysql": {
          "username": "root", 
          "adapter": "mysql2", 
          "database": "browserid", 
          "encoding": "utf8"
        }
      }, 
      "status": 0, 
      "worker": "nodejs1.worker.travis-ci.org:travis-nodejs-1", 
      "compare_url": "https://github.com/mozilla/browserid/commit/9a29fc3c8c1e", 
      "committed_at": "2012-06-21T10:20:36Z", 
      "commit": "9a29fc3c8c1e95c9cd88a98c61e9b53ef99bcf28", 
      "committer_name": "Shane Tomlinson", 
      "sponsor": {
        "url": "http://transloadit.com", 
        "name": "Transloadit"
      }
    }

### JSONP

The server acknowledges [JSONP](http://en.wikipedia.org/wiki/JSONP "Wikipedia on JSONP") requests. This allows a javascript client to relax the [same origin policy](http://en.wikipedia.org/wiki/Same_origin_policy "Wikipedia on Same Origin Policy") and retrieve the above json by specifying a callback function.

#### Example

JSONP works with any of the above urls. The example below uses the url for builds and appends a callback

    http://travis-ci.org/:owner_name/:name/builds.json?callback=:function

#### Response (<http://travis-ci.org/travis-ci/travis-ci/builds.json?callback=foo>)

    foo(
      [
        {
          "number": "731",
          "committed_at": "2011-08-02T23:16:51Z",
          "commit": "9b5786d7164ef5a960e0d7b87764b9cbc0fb95e3",
          "finished_at": "2011-08-02T23:27:17Z",
          "config": {
            "script": "bundle exec rake test:ci",
            ".configured": "true",
            "bundler_args": "--without development",
            "notifications": {
              "irc": "irc.freenode.org#travis"
            },
            "rvm": [
              "1.8.7",
              "1.9.2",
              "1.9.3",
              "ree"
            ]
          },
          "author_name": "Josh Kalderimis",
          "matrix": [
            {
              "number": "731.1",
              "committed_at": "2011-08-02T23:16:51Z",
              "commit": "9b5786d7164ef5a960e0d7b87764b9cbc0fb95e3",
              "finished_at": "2011-08-02T23:24:06Z",
              "config": {
                "script": "bundle exec rake test:ci",
                ".configured": "true",
                "bundler_args": "--without development",
                "notifications": {
                  "irc": "irc.freenode.org#travis"
                },
                "rvm": "1.8.7"
              },
              "author_name": "Josh Kalderimis",
              "log": "Using worker: main.railshoster:worker-3\n\n$ git clone --depth=1000 --quiet git://github.com/travis-ci/travis-ci.git ... ",
              "branch": "master",
              "id": 63812,
              "parent_id": 63811,
              "started_at": "2011-08-02T23:20:13Z",
              "author_email": "josh.kalderimis@gmail.com",
              "status": 0,
              "repository_id": 59,
              "message": "Merge branch 'staging'",
              "compare_url": "https://github.com/travis-ci/travis-ci/compare/ca5b190...9b5786d"
            },
           ...
          ],
          "log": "",
          "branch": "master",
          "id": 63811,
          "started_at": "2011-08-02T23:23:05Z",
          "author_email": "josh.kalderimis@gmail.com",
          "status": 0,
          "repository_id": 59,
          "message": "Merge branch 'staging'",
          "compare_url": "https://github.com/travis-ci/travis-ci/compare/ca5b190...9b5786d"
        },
        ...
      ]
    )
