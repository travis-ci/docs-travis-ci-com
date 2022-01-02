---
title: Using CCMenu with Travis CI
layout: en

---

![Screenshot of CC menu](/images/Backstop_Menubar_20140305_155352_20140305_155425.jpg "Screenshot of CC menu")

[CCMenu](http://ccmenu.org/) is a little tool for the macOS status bar to keep track of your repositories' latest build status from the convenience of your Mac.

[CCTray](http://sourceforge.net/projects/ccnet/files/CruiseControl.NET%20Releases/CruiseControl.NET%201.8.4/) is the equivalent tool for your Windows environment, [BuildNotify](https://bitbucket.org/Anay/buildnotify/wiki/Home) for Linux systems. The general instructions apply to all of them.

They were originally built for use with CruiseControl, but they work just as well with Travis CI, and you can use either to poll your Travis CI repositories and have their status
show in the menu bar or tray.

### Using the CC feed with repositories

Open source repositories use the URL scheme `https://api.travis-ci.org/repos/<owner>/<repository>/cc.xml` to access the CruiseControl feed. They're served directly from our API.

![Screenshot of public CC feed](/images/Projects_20140305_165324_20140305_165329.jpg "Screenshot of public CC feed")

To add a repository feed, we provide a generated URL (for both public and private repositories), which can be accessed by visiting the repository page and clicking on the Build Status Image, shown below:

<figure>
  <img alt="Screenshot of Build Status Image" src="/images/repository-build-status-image.png"/>
</figure>

Once the modal is open, select `CCTray` from the second dropdown, which
then displays the URL to be copied. If the repository is private, it will also
include the required token parameter:

<figure>
  <img alt="Screenshot of Build Status Image Modal with generated URL"
  src="/images/repository-build-status-modal-with-url.png"/>
</figure>

The generated URL includes the branch name selected in the modal. To specify a
different branch, either select a different branch before copying the URL or edit the
branch parameter manually. Should you choose to manually generate the URL, it
must have the following form:

- For open source projects use `https://api.travis-ci.org/repos/<owner>/<repository>/cc.xml?branch=<branch>`
- For closed source projects use `https://api.travis-ci.com/repos/<owner>/<repository>/cc.xml?token=<token>&branch=<branch>`.


### Using the CC feed with accounts

The above technique only allows you to add one repository at a time, which can be unwieldy for team members of organizations with several repositories they're working on. Rather than specify the owner and the repository, you can simply specify the owner and select a subset of projects.

- For open source projects use `https://api.travis-ci.org/repos/<owner>.xml`
- For closed source projects use `https://api.travis-ci.com/repos/<owner>.xml?token=<token>`.

CCMenu will show you a list of all the available repositories you can then add in single, swift action.

![Screenshot of CC feed listing](/images/Screenshot_20140305_164512_20140305_164517.jpg "Screenshot of CC feed listing")
