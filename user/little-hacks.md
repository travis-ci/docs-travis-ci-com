---
title: Build Hacks
permalink: build-hacks/
layout: en
---

<div id="toc"></div>

## Update/Downgrade Maven

The newer Maven isn't always stable compared to previous ones, potentially
breaking plugins, This script downloads and installs the latest 3.1.1 release
and sets it as a default

    before_install:
      - "wget http://apache.mirror.iphh.net/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz && tar xfz apache-maven-3.1.1-bin.tar.gz && sudo mv apache-maven-3.1.1 /usr/local/maven-3.1.1 && sudo rm -f /usr/local/maven && sudo ln -s /usr/local/maven-3.1.1 /usr/local/maven"
