---
title: Ubuntu Precise to Ubuntu Trusty Migration Guide
layout: en
---

Ubuntu Trusty is becoming the default Linux distribution instead of Ubuntu Precise on Travis CI. Here are the most common issues our customers ran into and how you can fix them.

# Staying on Precise

If you’d like to stay on Ubuntu Precise or need more time to set up your repository with Ubuntu Trusty, please explicitly set `dist: precise` in your .travis.yml file as soon as possible.

# PyPy Support

Using `pypy2` and `pypy3` for selecting PyPy versions is not supported anymore, instead you need to specify the full version number, e.g.: `python: pypy2.7-5.8.0`.

Supported versions:

* `pypy-5.4`: `PyPy 5.4.0 [Python 2.7.10]`
* `pypy-5.7.1`: `PyPy 5.7.1 [Python 2.7.13]`
* `pypy2.7-5.8.0`: `PyPy 5.8.0 [Python 2.7.13]`
* `pypy3.5-5.8.0`: `PyPy 5.8.0-beta0 [Python 3.5.3]`
