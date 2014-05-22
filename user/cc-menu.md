---
title: Using CCMenu with Travis CI
layout: en
permalink: cc-menu/
---
<figure class="small right">
  <img src="http://s3itch.paperplanes.de/Backstop_Menubar_20140305_155352_20140305_155425.jpg" alt="Screen shot of OSX toolbar showing build statuses in CCMenu"/>
</figure>

[CCMenu](http://ccmenu.org/) is a little tool for the OS X status bar to keep track of your repositories' latest build status from the convenience of your Mac.

[CCTray](http://sourceforge.net/projects/ccnet/files/CruiseControl.NET%20Releases/CruiseControl.NET%201.8.4/) is the equivalent tool for your Windows environment, [BuildNotify](https://bitbucket.org/Anay/buildnotify/wiki/Home) for Linux systems. The general instructions apply to all of them.

They were originally built for use with CruiseControl, but they work just as well with Travis CI, and you can use either to poll your Travis CI repositories and have their status
show in the menu bar or tray.

### Using the CC feed with repositories

Open source repositories use the URL scheme `https://api.travis-ci.org/repos/<owner>/<repository>/cc.xml` to access the CruiseControl feed. They're served directly from our API.

<figure>
  <img src="http://s3itch.paperplanes.de/Projects_20140305_165324_20140305_165329.jpg" alt="Screenshot of the projects configuration pane with the project name and URL set to the travis-ci/travis-api project endpoint set" />
</figure>

Private repositories use a different URL scheme, served from a different [API endpoint](https://api.travis-ci.com):

<figure>
  <img src="http://s3itch.paperplanes.de/Screenshot_20140305_165022_20140305_165032.jpg" alt="Screenshot of add project dialog using the token parameter for private feed authentication"/>
</figure>

Private repositories require an authenticated URL with a token in it. You can find the token in your profile:

![Screenshot of Mathias Meyer's Travis CI profile page with arrow pointing to Token value.](/images/token.jpg)

### Using the CC feed with accounts

The above technique only allows you to add one repository at a time, which can be unwieldy for team members of organizations with several repositories they're working on.

Rather than specify the owner and the repository, you can also specify just the owner, for instance `https://api.travis-ci.org/repos/travis-ci.xml`.

CCMenu will show you a list of all the available repositories you can then add in single, swift action.

<figure>
  <img src="http://s3itch.paperplanes.de/Screenshot_20140305_164512_20140305_164517.jpg" alt="Screenshot of project list, showing the first three projects highlighted for adding."
  />
</figure>

Pretty handy!
