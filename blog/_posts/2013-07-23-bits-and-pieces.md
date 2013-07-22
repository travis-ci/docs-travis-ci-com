---
title: Bits and Pieces
author: Konstantin Haase
twitter: konstantinhaase
created_at: Tue 23 Jul 2013 16:25:00 CEST
layout: post
permalink: blog/2013-07-23-bits-and-pieces
---

### Continuous Deployment

##### Restarting Heroku applications

Sometimes you need to restart your Heroku application after running some command.
One example is running migrations for a Rails application, which only loads the database schema on boot.

You can now simply add `restart` to the `run` section of your `.travis.yml`:

    deploy:
      provider: heroku
      run:
      - "rake db:migrate"
      - restart

##### Deploying build artifacts

### Command Line Tool

##### Setup wizard for continuous deployment and addons

##### Improved value encryption

##### Branch overview and details

##### Accessing the public key

##### Lots of small fixes