---
title: Enterprise Customer Worker Queues
layout: en_enterprise
---

Custom queues give your team more granular control over routing jobs to specific workers. This is especially helpful in conjunction with customized [worker configuration](/user/enterprise/worker-configuration/) and/or modified [build environments](/user/enterprise/build-images).

There are two [feature flags](#Enable-Queues-on-the-Platform) required for custom queues. After setting these flags, you can define the configuration for your queues in the [Management Console settings](#Define-Custom-Queues-in-the-Management-Console), and [allocate workers to the new queues](#Define-Custom-Queues-Settings-on-The-Workers)

<div id="toc"></div>

## Enable Queues on the Platform

To allow your Travis CI Enterprise platform instance to route jobs to customized queues, set the `template_selection` and `multi_os` feature flags. To do this, ssh into your platform server, then run `travis console`. Run the following command to enable the required feature flags: 
```
Travis::Features.enable_for_all(:template_selection); Travis::Features.enable_for_all(:multi_os); exit
```

The new settings will take effect immediately, but job routing will remain the same until new queues are defined. 

## Define Custom Queues in the Management Console  

After enabling the feature flags for custom queues, configure the job routing in the management console. This is defined in yaml, in the **Advanced Configuration YAML** section at the bottom of the management console **Settings** page, e.g. `https://<your-domain>:8800/settings`.  

There are a number of options/selectors used to define routing to a custom queue. Repos that match _all_ of the selectors for a custom queue will be built on that custom queue. We recommend using the following selectors:

  - `language` - defines the build environment based on the chosen language of the project†
  - `group` - mostly semantic, for defining 'groups' of environments†
  - `owner` - either be an org or a user
  - `slug` - a repository, in the form: `org/repo` or `user/repo`


† Specify the `language` and `group` for a job in the `.travis.yml`. Do not specify ownership-type selectors (`owner`, `slug`) in the configuration. See [the example](#Advanced-Configuration-YAML-Example) for more details. 

> Note: We do not recommend using `dist` and `os` for these selectors. These two have some of their own routing processes built-in and may not entirely behave as intended. 

Define selectors in "Advanced Configuration YAML" in the following format:
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

The syntax for the **Advanced Configuration YAML** field is very important. Incorrect syntax will result in builds being routed to defaults, usually a `builds.linux` queue, depending on if there are any modifications to your installation. Here's an example of a custom queue definition: 

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

For this example, to build an `enterprise`, Ruby project owned by the `travis-ci` organization, a `.travis.yml` would need to look as follows:

```yaml
group: enterprise
language: ruby
# rest of the yaml, per standard spec
```
{: data-file=".travis.yml"}

Building [`travis-ci/docs-travis-ci.com`](https://github.com/travis-ci/docs-travis-ci-com) repo, however, does not require any special configuration.

## Define Custom Queues Settings on The Workers

To allocate a worker to a particular queue, define the `QUEUE_NAME` variable in the worker config. This is located at `etc/default/travis-worker`. Update the environment variable to match the queue name specified in your [custom queue configuration yaml](#Advanced-Configuration-YAML-Example). Then restart the worker with: 
```
sudo service travis-worker restart
```
The new queue settings will take effect upon restart. 

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
