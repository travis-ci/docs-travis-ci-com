---
title: L'API Travis
layout: default
---

### Repositories

#### Index
    http://travis-ci.org/repositories.json

#### Réponse (http://travis-ci.org/repositories.json)

    [
      {
        "slug": "sstephenson/execjs",
        "last_build_id": 62016,
        "last_build_started_at": "2011-08-01T17:37:44Z",
        "last_build_status": null,
        "last_build_number": "15",
        "id": 389,
        "last_build_finished_at": null
      },
      ...
    ]

[Hurl](http://hurl.it/hurls/919a2b3a2ac6dd60239c2548b183fc0a7ba49890/863c0ad50ec63156ec169be3a542d4408fe02d42)

#### Show

    http://travis-ci.org/:owner_name/:name.json

#### Réponse (http://travis-ci.org/travis-ci/travis-ci.json)
    {
      "slug": "travis-ci/travis-ci",
      "last_build_id": 61817,
      "last_build_started_at": "2011-08-01T14:50:07Z",
      "last_build_status": 0,
      "last_build_number": "721",
      "id": 59,
      "status": "stable",
      "last_build_finished_at": "2011-08-01T14:56:44Z"
    }

[Hurl](http://hurl.it/hurls/1a475b8b354d98647764c8f7d863f5732c2dbc18/33e7c4e5c62612cdbeac17917c6ebd9f8d3d6344)

### Builds

#### Index

    http://travis-ci.org/:owner_name/:name/builds.json

#### Réponse (http://travis-ci.org/travis-ci/travis-ci/builds.json)

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

[Hurl](http://hurl.it/hurls/7f51dc1660a6b915159498c19e493637c6395443/ef84212b3be1a146ff07804ec93c689afb81ef72)

#### Show

    http://travis-ci.org/:owner_name/:name/builds/:id.json

#### Réponse (http://travis-ci.org/travis-ci/travis-ci/builds/63812.json)

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
    }

[Hurl](http://hurl.it/hurls/e69fc3c78fe69ed27e4ef772af5ac6bf005bffce/af2ecf26f637b4cf16b112a35179f9c4277d5b0c)
