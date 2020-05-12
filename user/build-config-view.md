---
title: The Build Config View

layout: en
---

The Build Config view gives you the possibility to

* Trigger a build (make sure to configure them properly - see Note at the bottom)
* Customize your build
* Preview your build
* Cancel your build

## Build Config Validation turned off

You cannot access the Build Config Validation feature with the setting [x] Build Config Validation turned off. 

This is because the feature needs to go through Yml's API, while Trigger Build goes through just Gatekeeper, 
and skips .yml for processing the build config. So the build preview and actual build triggered might yield inconsistent results.

> Everything else from here on in this document assumes that the setting [x] Build Config Validation is turned on.


## Build Config Validation Indicator and Messages

For both a build with multiple jobs, and a build with an individual job, on the build view and the job view:

* Green - If a build config has info level validation messages then a green dot indicates the validity on the View Config tab, 
and validation messages are listed only on the build and job's config view, not on the main build matrix or job log views.
* Yellow or red - If a build config has warning, error, or alert level validation messages then a yellow or red dot indicates this on the 
View Config tab, and validation messages are listed on both the build/job's config view, as well as the main build matrix 
and job log views.

## Build Config Preview and Trigger Build Views

The config tab has the following states:

* Closed - Viewing the config of the current build 
* Open - Triggering a new build with the same config 
* Customize - Customizing the build config 
* Preview - Previewing a build as it would be created by submitting the config as a new build 

All but the closed view also have two sub-states:

* Before triggering a new build
* After triggering a new build

Status details:
...

> New builds resulting from submitting build configs via "Trigger Build" have to be configured properly, using the correct branch, 
commit, message, and config(s).
Especially the merging of submitted build configs (e.g. merging the custom config into an existing .travis.yml, but also merging 
multiple configs submitted, and merging config imports into either submitted configs, or the .travis.yml) has to happen using the 
given merge mode(s) and result in the correct build config result.


