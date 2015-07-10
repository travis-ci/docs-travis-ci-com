---
title: Using Docker in Builds
layout: en
permalink: /user/docker/
---

### Building a Docker Image from a Dockerfile

Do we need a repo with a Dockerfile? Possibly not if we just use the shortest possible Dockerfile.

Something like
```
FROM IMAGEWESUPPLY
RUN echo 'Running Docker in a Travis Build'
```

Then we build the image from the Dockerfile, tag it with the commit number?

```
docker build -t seriouscompany/seriousapp:$TRAVIS_COMMIT .
```

### Pushing a Docker Image to a Registry

As before but pushing to a registry. 

Credentials?

```
docker build -t seriouscompany/seriousapp:$TRAVIS_COMMIT .
docker push seriouscompany/seriousapp:$TRAVIS_COMMIT
```

#### Docker Hub

#### Quay.io

