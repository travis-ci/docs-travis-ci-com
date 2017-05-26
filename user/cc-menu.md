---
title: Using CCMenu with Travis CI
layout: en
permalink: /user/cc-menu/
---

<figure class="small right">
  <img alt="Screenshot of CC menu" src="http://s3itch.paperplanes.de/Backstop_Menubar_20140305_155352_20140305_155425.jpg"/>
</figure>

[CCMenu](http://ccmenu.org/) is a little tool for the OS X status bar to keep track of your repositories' latest build status from the convenience of your Mac.

[CCTray](http://sourceforge.net/projects/ccnet/files/CruiseControl.NET%20Releases/CruiseControl.NET%201.8.4/) is the equivalent tool for your Windows environment, [BuildNotify](https://bitbucket.org/Anay/buildnotify/wiki/Home) for Linux systems. The general instructions apply to all of them.

They were originally built for use with CruiseControl, but they work just as well with Travis CI, and you can use either to poll your Travis CI repositories and have their status
show in the menu bar or tray.

### Using the CC feed with repositories

Open source repositories use the URL scheme `https://api.travis-ci.org/repos/<owner>/<repository>/cc.xml` to access the CruiseControl feed. They're served directly from our API.

<figure>
  <img alt="Screenshot of public CC feed" src="http://s3itch.paperplanes.de/Projects_20140305_165324_20140305_165329.jpg"/>
</figure>

Private repositories use a different URL scheme, served from a different [API endpoint](https://api.travis-ci.com): `https://api.travis-ci.com/repos/<owner>/<repository>/cc.xml?token=token>`.

<figure>
  <img alt="Screenshot of private CC feed" src="http://s3itch.paperplanes.de/Screenshot_20140305_165022_20140305_165032.jpg"/>
</figure>

Private repositories require an authenticated URL with a token in it. You can find the token in your profile:

![Travis CI user token](/images/user-token.png)

By default, the feed will fetch the status of the default branch of the repository. To specify a different branch, use the `branch` parameter:

- For open source projects use `https://api.travis-ci.org/repos/<owner>/<repository>/cc.xml?branch=<branch>`
- For closed source projects use `https://api.travis-ci.com/repos/<owner>/<repository>/cc.xml?token=<token>&branch=<branch>`.


### Using the CC feed with accounts

The above technique only allows you to add one repository at a time, which can be unwieldy for team members of organizations with several repositories they're working on. Rather than specify the owner and the repository, you can simply specify the owner and select a subset of projects.

- For open source projects use `https://api.travis-ci.org/repos/<owner>.xml`
- For closed source projects use `https://api.travis-ci.com/repos/<owner>.xml?token=<token>`.

CCMenu will show you a list of all the available repositories you can then add in single, swift action.

<figure>
  <img alt="Screenshot of CC feed listing" src="http://s3itch.paperplanes.de/Screenshot_20140305_164512_20140305_164517.jpg"/>
</figure>

Pretty handy!
