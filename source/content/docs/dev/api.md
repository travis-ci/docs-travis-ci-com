---
title: The Travis API
kind: article
layout: article
---

### Repositories

#### Index
    http://travis-ci.org/repositories.json

#### Response (http://travis-ci.org/repositories.json)

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

#### Response (http://travis-ci.org/travis-ci/travis-ci.json)
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

