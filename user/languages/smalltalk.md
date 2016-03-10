---
title: Building a Smalltalk Project
layout: en
permalink: /user/languages/smalltalk/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Smalltalk
projects. Please make sure to read our
[Getting Started](/user/getting-started/) and
[general build configuration](/user/customizing-the-build/) guides first.


### Community-Supported Warning

Travis CI support for Smalltalk is contributed by the community and may be removed or altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:smalltalk)
and cc [@bahnfahren](https://github.com/bahnfahren),
[@chistopher](https://github.com/chistopher),
[@fniephaus](https://github.com/fniephaus),
[@jchromik](https://github.com/jchromik), and
[@Nef10](https://github.com/Nef10) in the issue.

Travis uses [SmalltalkCI](https://github.com/hpi-swa/smalltalkCI) made by [fniephaus](https://github.com/fniephaus) to support Smalltalk.
 
## Basic configuration

For basic configuration you need a .yml and a .ston.

That is how your .travis.yml should look like:
```yaml
language: smalltalk
sudo: false

# Select operating system(s)
os:
  - linux
  - osx

# Select compatible Smalltalk image(s)
smalltalk:
  - Squeak-trunk
  - Squeak-5.0
  - Squeak-4.6
  - Squeak-4.5

  - Pharo-alpha
  - Pharo-stable
  - Pharo-5.0
  - Pharo-4.0
  - Pharo-3.0

  - GemStone-3.3.0
  - GemStone-3.2.12
  - GemStone-3.1.0.6
```

This is a minimal .smalltalk.ston:
```javascript
SmalltalkCISpec {
  #loading : [
    SCIMetacelloLoadSpec {
      #baseline : 'MyProject',
      #directory : 'packages',
      #platforms : [ #squeak, #pharo, #gemstone ]
    }
  ]
}
```

## Configuration

This documentation is just a minimal example and not as exhaustive as SmalltalkCI's readme. 
Please visit [smalltalkCI's GitHub repository](https://github.com/hpi-swa/smalltalkCI#templates) for further details.
