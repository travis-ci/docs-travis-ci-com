---
title: Enterprise Customer Worker Queues
layout: en_enterprise
---

Setting up custom worker queues on Travis CI Enterprise allows your team to designate a particular worker (or group of workers) for building specific repositories. This is especially useful for differentiating workers that have been customized specially.

Custom queues require [enabling two feature flags](#Enable-Queues-on-the-Platform). Once these flags are set, you can define the configuration for your custom queues in the [Management Console settings](#Define-Custom-Queues-in-the-Management-Console), and [allocate workers to the new queues](#Define-Custom-Queues-Settings-on-The-Workers)

<div id="toc"></div>

## Enable Queues on the Platform

To allow your Travis CI Enterprise platform instance to route jobs to customized queues, the `template_selection` and `multi_os` feature flags must be set. To do this, ssh into your platform server, then run `travis console`. Run the following command to enable the required feature flags: 
```
Travis::Features.enable_for_all(:template_selection); Travis::Features.enable_for_all(:multi_os); exit
```

The new settings will take effect immediately, but job routing will remain the same until new queues are defined. 

## Define Custom Queues in the Management Console  

Once the custom queue feature flags are enabled, the routing must configured in the management console. This is defined in yaml, in the **Advanced Configuration YAML** section at the bottom of the management console **Settings** page, e.g. `https://<your-domain>:8800/settings`.  

There are a number of options/selectors used to define routing to a custom queue. Some must be specified in the `.travis.yml`, others (such as those that indicate repo ownership) should not be specified in the `.travis.yml`. Repos that match _all_ of the selectors for a custom queue will be built on that custom queue. We recommend using the following selectors:

  - `language` - defines the build environment based on the chosen language of the project†
  - `group` - mostly semantic, for defining 'groups' of environments†
  - `owner` - either be an org or a user
  - `slug` - a repository, in the form: `org/repo` or `user/repo`


† `language` and `group` selectors must be specified in the `.travis.yml`. See [the example](#Advanced-ConfigurationYAML-Example) for more details. 

Note: We do not recommend using `dist` and `os` for these selectors. These two have some of their own routing processes built-in and may not entirely behave as intended. 

All selectors should be given as a list in the "Advanced Configuration YAML" in the format:
```yaml
production:
  queues:
  - queue: name
    selector: value
  - queue: another.queue
    selector: different_value
    selector: something_else
```
see the [example](#Advanced-Configuration-YAML-Example) for details on syntax. Click "Save" on the Management Console Settings when you are ready. Travis CI Enterprise will restart, with your new queue settings.

### Advanced Configuration YAML Example 

The syntax for the **Advanced Configuration YAML** field is very important. Improper syntax will result in builds being routed to defaults, usually a `builds.linux` queue (if this has not been modified on your installation.) Syntax for a custom queue looks as follows: 

```yaml
production:
  queues:
  - queue: builds.ruby
    owner: travis-ci
    language: ruby
    group: enterprise
  - queue: builds.python
    owner: acnagy
    language: python
  - queue: dockercluster
    services:
    - docker
  - queue: legacy
    group: legacy
  - queue: docs
    slug: 'travis-ci/docs-travis-ci-com' 
```

Although selectors that indicate ownership (such as `owner` and `slug`) do not need to be set in the `.travis.yml`, other selectors must be. For example, to build an `enterprise`, Ruby project owned by the `travis-ci` organization, a `.travis.yml` would need to look as follows:

```yaml
group: enterprise
language: ruby
# rest of the yaml, per standard spec
```
{: data-file=".travis.yml"}

but, to build this repo, [`travis-ci/docs-travis-ci.com`](https://github.com/travis-ci/docs-travis-ci-com), no special configuration would be required.

## Define Custom Queues Settings on The Workers

To allocate a worker to a particular queue, the `QUEUE_NAME` variable must be set in the worker config, which is located at `etc/default/travis-worker`. Update the environment variable to match the queue name specified in your [custom queue configuration yaml](#Advanced-Configuration-YAML-Example). Then restart the worker with: 
```
sudo service travis-worker restart
```
The new queue settings will take effect upon restart. 
