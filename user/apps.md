---
title: Apps, Clients and Tools
layout: en

---

There is a wide range of tools you can use to interact with Travis CI:

- **[Websites](#websites)**: [Full Web Clients](#full-web-clients), [Dashboards](#dashboards), [Tools](#tools)
- **[Mobile Applications](#mobile)**: [Android](#android), [iOS](#ios), [Windows Phone](#windows-phone)
- **[Desktop](#desktop)**: [macOS](#macos), [Linux](#linux), [Cross Platform](#cross-platform)
- **[Command Line Tools](#commandline)**: [Full Clients](#full-clients), [Build Monitoring](#build-monitoring), [Generators](#generators)
- **[Plugins](#plugins)**: [Google Chrome](#google-chrome), [Opera](#opera), [Editors](#editors), [Other](#other)
- **[Libraries](#libraries)**: [Ruby](#ruby), [JavaScript](#javascript), [PHP](#php), [Python](#python), [Elixir](#elixir), [R](#r), [Go](#go)
  {: .toc-list}

And if you don't find anything that fits your needs, you can also interact with our [API](/api/) directly.

Note however that Travis CI can not take any responsibility of for third-party tools you might use.

# Websites {#websites}

## Full Web Clients

### Travis CI Web Client

![travis-web](/images/apps/travis-web.jpg){:.app}{:.official}

Our official web interface, written in [Ember.js](http://www.emberjs.com)

- [travis-ci.com](https://travis-ci.com)
- [source code](https://github.com/travis-ci/travis-web)


## Dashboards

### TravisLight

![travis-light](/images/apps/travis-light.jpg){:.app}

Online build monitoring tool<br>
By William Durand

- [website](http://williamdurand.fr/TravisLight/)
- [source code](https://github.com/willdurand/TravisLight)

### Team Dashboard

![travis-light](/images/apps/team-dashboard.jpg){:.app}

Visualize your team's metrics all in one place<br>
By Frederik Dietz

- [website](http://fdietz.github.io/team_dashboard/)
- [source code](https://github.com/fdietz/team_dashboard)

### CI Status

![ci-status](/images/apps/ci-status.png){:.app}

Travis CI dashboard<br>
By Piwik.

- [source code](https://github.com/piwik/ci-status)

### node-build-monitor

![node-build-monitor](/images/apps/node-build-monitor.jpg){:.app}

Simple and extensible Build Monitor written in Node.js<br>
By Marcell Spies

- [website](http://marcells.github.io/node-build-monitor)
- [source code](https://github.com/marcells/node-build-monitor)

### CI Dashboard

![ci-dashboard](/images/apps/ci-dashboard.jpg){:.app}

Travis CI builds dashboard<br>
By Ahmed El-Sayed

- [source code](https://github.com/ahmedelsayed-93/ci-dashboard)


## Tools

### Travis Web Encrypter

![travis-encrypt](/images/apps/travis-encrypt.jpg){:.app}

Encrypt Secure Variables<br>
By Konstantin Haase

- [website](http://rkh.github.io/travis-encrypt/public/index.html)
- [source code](https://github.com/rkh/travis-encrypt)

<a name='mobile'></a>

# Mobile Applications

## Android

### Siren of Shame (Android)

![Siren of Shame](/images/apps/siren-android.jpg){:.app}

Gamification for your builds<br>
By Automated Architecture

- [website](http://sirenofshame.com/)
- [play store](https://play.google.com/store/apps/details?id=com.automatedarchitecture.sirenofshame2)

## iOS

### Jarvis

![jarvis](/images/apps/jarvis.jpg){:.app}

iPad client for Travis CI, supports private projects<br>
By NinjaConcept GmbH

- [app store](https://itunes.apple.com/us/app/jarvis/id846922611)


### Project Monitor

![Project Monitor](/images/apps/project-monitor.jpg){:.app}

iPhone app that monitors public and private builds<br>
By Dimitri Roche

- [app store](https://itunes.apple.com/us/app/project-monitor/id857272990)
- [source code](https://github.com/dimroc/iOS.ProjectMonitor)

### Siren of Shame (iOS)

![Siren of Shame](/images/apps/siren-ios.jpg){:.app}

Gamification for your builds<br>
By Automated Architecture

- [website](http://sirenofshame.com/)
- [app store](https://itunes.apple.com/us/app/siren-of-shame/id637677118)

## Windows Phone

### Travis7

![travis7](/images/apps/travis7.jpg){:.app}

A Windows Phone client for Travis CI<br>
By Tim Felgentreff

- [website](http://travis7.codeplex.com/)

# Desktop

If you are looking for **desktop notifications**, our command line client [supports them](https://github.com/travis-ci/travis.rb#monitor).

## macOS

### CCMenu

![CCMenu](/images/apps/ccmenu.jpg){:.app}

macOS status bar app<br>
By ThoughtWorks Inc.

- [website](http://ccmenu.org/)
- [app store](https://itunes.apple.com/us/app/ccmenu/id603117688)
- [tutorial](/user/cc-menu/)

![Travis CI in Screensaver Ninja with Custom CSS](/images/apps/screensaver-ninja.gif){:.app}

## Linux

### BuildNotify

![BuildNotify](/images/apps/buildnotify.jpg){:.app}

Linux alternative to CCMenu<br>
By Anay Nayak

- [website](https://bitbucket.org/Anay/buildnotify/wiki/Home)
- [tutorial](/user/cc-menu/)

## Cross Platform

### Build Checker App

![BuildCheckerApp](/images/apps/build-checker-app.png){:.app}

Check CI-server build statuses<br>
By Will Mendes.

- [website](https://github.com/willmendesneto/build-checker-app#readme)

### CatLight

![CatLight Build Status](/images/apps/catlight-tray.png){:.app}

Shows build status in tray / menu bar<br>
By catlight.io

- [website](https://catlight.io)

<a name='commandline'></a>

# Command Line Tools

## Full Clients

### Travis CLI

![cli](/images/apps/cli.jpg){:.app}

Feature complete command line client

- [website](https://github.com/travis-ci/travis#readme)

### PSTravis

Command line client for PowerShell

- [website](https://github.com/felixfbecker/PSTravis#readme)

## Build Monitoring

### Bickle

![bickle](/images/apps/bickle.jpg){:.app}

Display build status in your terminal<br>
By Jiri Pospisil

- [website](https://github.com/mekishizufu/bickle#readme)

### Travis Surveillance

![travis-surveillance](/images/apps/travis-surveillance.jpg){:.app}

Monitor a project in your terminal<br>
By Dylan Egan

- [website](https://github.com/dylanegan/travis-surveillance#readme)

### Travis Build Watcher

![travis-build-watcher](/images/apps/travis-build-watcher.jpg){:.app}

Trigger a script on build changes<br>
By Andrew Sutherland

- [website](https://github.com/asutherland/travis-build-watcher)

### Status Gravatar

![status-gravatar](/images/apps/status-gravatar.jpg){:.app}

Sets Gravatar profile image depending on build status<br>
By Gleb Bahmutov

- [website](https://github.com/bahmutov/status-gravatar)

### Chroma Feedback

![chroma feedback](/images/apps/chroma-feedback.jpg){:.app}

Turn your Razer keyboard, mouse or headphone into a extreme feedback device<br>
By Henry Ruhs

- [website](https://github.com/redaxmedia/chroma-feedback)

## Generators

### travis-encrypt

![travis-encrypt](/images/apps/node-travis-encrypt.jpg){:.app}

Encrypt environment variables<br>
By Patrick Williams

- [website](https://github.com/pwmckenna/node-travis-encrypt)

### travis-tools

![travis-tools](/images/apps/travis-tools.jpg){:.app}

Easy secure data encryption<br>
By Michael van der Weg

- [website](https://github.com/eventEmitter/travis-tools)

### Travisify (Ruby)

![travisify-ruby](/images/apps/travisify-ruby.jpg){:.app}

Creates .travis.yml with tagging and env variables<br>
By James Smith

- [website](https://github.com/theodi/travisify)

### Travisify (Node.js)

![travisify-node](/images/apps/travisify-node.jpg){:.app}

Add Travis CI hooks to your GitHub project<br>
By James Halliday

- [website](https://github.com/substack/travisify)

# Plugins

## Google Chrome

### My Travis

![chrome-my-travis](/images/apps/chrome-my-travis.jpg){:.app}

Monitor your projects builds within Chrome<br>
By Leonardo Quixadá

- [website](https://chrome.google.com/webstore/detail/my-travis/ddlafmkcenhiahiikbgjemcbdengmjbg)

### github+travis

![chrome-github-travis](/images/apps/chrome-github-travis.jpg){:.app}

Display build status next to project name on GitHub<br>
By Tomas Carnecky

- [website](https://chrome.google.com/webstore/detail/klbmicjanlggbmanmpneloekhajhhbfb)

### GitHub Status

![chrome-github-status](/images/apps/chrome-github-status.jpg){:.app}

Display build status next to project name on GitHub<br>
By excellenteasy

- [website](https://chrome.google.com/webstore/detail/github-status/mgbkbopoincdiimlleifbpfjfhcndahp)

## Opera

### GitHub+Travis

![chrome-github-travis](/images/apps/chrome-github-travis.jpg){:.app}

Display build status next to project name on GitHub<br>
By smasty

- [website](https://addons.opera.com/en/extensions/details/travisgithub/)

## Editors

### Atom Plugin

![atom](/images/apps/atom.jpg){:.app}

Travis CI integration for [Atom](https://atom.io/)<br>
By Tom Bell

- [website](https://github.com/tombell/travis-ci-status)

### Brackets Plugin

![brackets](/images/apps/brackets.jpg){:.app}

Travis CI integration for [Brackets](http://brackets.io/)<br>
By Cas du Plessis

- [website](https://github.com/AgileAce/Brackets-TravisCI)

### Emacs Package

![emacs](/images/apps/emacs.jpg){:.app}

Travis CI integration for [Emacs](https://www.gnu.org/software/emacs/)<br>
By Skye Shaw

- [website](https://github.com/sshaw/build-status)


### Vim Plugin

![vim](/images/apps/vim.jpg){:.app}

Travis CI integration for [Vim](http://www.vim.org/)<br>
By Keith Smiley

- [website](https://github.com/Keithbsmiley/travis.vim)

## Other

### git-travis

![git-travis](/images/apps/git.png){:.app}

Git subcommand to display build status<br>
By Dav Glass

- [website](https://github.com/davglass/git-travis#readme)

### gh-travis

![NodeGH](/images/apps/nodegh.jpg){:.app}

NodeGH plugin for integrating Travis CI<br>
By Eduardo Antonio Lundgren Melo and Zeno Rocha Bueno Netto

- [website](https://github.com/node-gh/gh-travis)

### Travis CI 🡒 Discord Webhook

![TravisCI Discord Webhook](https://github.com/DiscordHooks.png){:.app}

Serverless solution for sending build status from Travis CI to Discord as webhooks.<br>
By Sankarsan Kampa

- [website](https://github.com/DiscordHooks/travis-ci-discord-webhook)

# Libraries

## Ruby

- [travis.rb](https://github.com/travis-ci/travis.rb) **(official)**
- [TravisMiner](https://github.com/smcintosh/travisminer) by Shane McIntosh
- [hoe-travis](https://github.com/drbrain/hoe-travis) by Eric Hodel
- [Knapsack](https://github.com/ArturT/knapsack) by Artur Trzop


## JavaScript

- [travis-ci](https://github.com/pwmckenna/node-travis-ci) by Patrick Williams
- [node-travis-ci](https://github.com/mmalecki/node-travis-ci) by Maciej Małecki
- [travis-api-wrapper](https://github.com/cmaujean/travis-api-wrapper) by Christopher Maujean
- [travis.js](https://github.com/travis-ci/travis.js) by Konstantin Haase
- [ee-travis](https://github.com/eventEmitter/ee-travis) by Michael van der Weg
- [Favis CI](https://github.com/jaunesarmiento/favis-ci) by Jaune Sarmiento

## PHP

- [php-travis-client](https://github.com/l3l0/php-travis-client) by Leszek Prabucki

## Python

- [TravisPy](http://travispy.readthedocs.org/en/latest/) by Fabio Menegazzo

## PowerShell

- [PSTravis](https://github.com/felixfbecker/PSTravis) by Felix Becker

## Elixir

- [travis.ex](https://github.com/localytics/travis.ex) by Kevin Deisz

## R

- [travis](https://github.com/ropenscilabs/travis) by Kirill Müller

## Go
- [go-travis](https://github.com/shuheiktgw/go-travis) by Shuhei Kitagawa
