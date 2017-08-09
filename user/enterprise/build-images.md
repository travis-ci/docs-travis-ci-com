---
title: Customizing Build Images
layout: en

---

## Customizing build images

After pulling the build images from
[quay.io](https://quay.io/organization/travisci) either through
[installation](/user/enterprise/installation) or manually, make sure they
they've been re-tagged to `travis:[language]`. Once this configuration is in
place, you can fully customize these images according to your needs.

**Note**: you'll need to re-apply your customizations after
upgrading build images from [quay.io](https://quay.io/organization/travisci).

The process is to:

-   start a Docker container based on one of the default build images
    `travis:[language]`,
-   run your customizations inside that container, and
-   commit the container to a Docker image with the original
    `travis:language name (tag)`.

For example, in order to install a particular Ruby version which is not
available on the default `travis:ruby` image, and make it persistent,
you can run:

```    
      docker -H tcp://0.0.0.0:4243 run -it --name travis_ruby travis:ruby su travis -l -c 'rvm install [version]'
      docker -H tcp://0.0.0.0:4243 commit travis_ruby travis:ruby
      docker -H tcp://0.0.0.0:4243 rm travis_ruby
```