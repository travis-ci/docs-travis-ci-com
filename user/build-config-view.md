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

> New builds resulting from submitting build configs via "Trigger Build" have to be configured properly, using the correct branch, 
commit, message, and config(s).
Especially the merging of submitted build configs (e.g. merging the custom config into an existing .travis.yml, but also merging 
multiple configs submitted, and merging config imports into either submitted configs, or the .travis.yml) has to happen using the 
given merge mode(s) and result in the correct build config result.

### Status details

#### Closed - Viewing the Config of the Current Build

The **Closed** status displays the raw config sources that have been used to configure the build (usually just .travis.yml, for builds triggered via API the build request's config, if any, and all config imports, if any)
the processed (validated and merged), resulting build config that has been used to create the build

It also lists build config validation messages, if any, or simply the message valid if no validation messages have been produced (can be provoked by providing valid values on language, os, and dist).

#### Open - Triggering a New Build with the Same Config

The **Open** status displays the same content as the Closed view, but allows to trigger a new build with the same config as the current one.

When the **Trigger build** button has been clicked it's state changes into a yellow button with a loading indicator, and the message changes to Submitting the build request. Once the build request has been processed, the message changes to Success. You have triggered build #[build-number] ..., and the button changes to green with the caption Go there.

#### Customizing - Changing the Config Previewed/Submitted

The **Customizing** status displays a form that allows changing the build's config sources. It can be used to e.g. try out and preview build configs for submitting build requests via API or including/merging them via config imports.

The default form has the fields:

* Branch, prefilled with the current build's branch.
*  Commit, prefilled with the current build's commit sha (truncated to 7 characters).
* Message, prefilled with (to be decided)
* Config, prefilled with the current build request's API config, if any
* Merge mode, pre-selected to the current build request's API merge mode, if any, or deep merge & append by default

> If the current build has been created by submitting multiple configs/merge modes via API (e.g. using this very feature) then all of them are displayed and prefilled on the form as well.

> Changing the selected branch will change the commit prefilled, even if it has been changed manually to some other than the original value.

Entering the Commit input field (focus) will display a small notice that reminds the user to enter a commit that belongs to the branch selected.

If the last config's merge mode is set to Replace then other config sources listed further down (e.g. .travis.yml) are hidden.

#### Preview - Previewing the Build Config and Jobs

The **Preview** status shows the build config and jobs that would result from submitting the current build config sources (customized or not) as a new build, with the build config on the left side, and the build's job on the right side. If multiple jobs would be produced then those are listed on the right side underneath each other.




