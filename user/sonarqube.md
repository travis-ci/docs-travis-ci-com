---
title: Using SonarQube.com with Travis CI
layout: en
permalink: /user/sonarqube/
---
**[SonarQube.com](https://sonarqube.com)** is the cloud service based on [SonarQube](http://www.sonarqube.org), the widely adopted "continuous inspection" open source platform that allows developers to find bugs, vulnerabilities and code smells in more than 20 different languages. It offers all the dashboards and tools to continuously track modifications of your code to make sure your code will only get better and better over time.

SonarQube.com is free for open-source projects. The only requirement is to have a GitHub account to connect to the service. It is then up to you to trigger the analysis, and this is where this Travis CI add-on simplifies your user experience.

## Activate the add-on

Simply add the following lines to your `.travis.yml` file:

    addons:
      sonarqube: true

This will set up everything required to simply trigger the SonarQube analysis later on.

## Trigger the analysis

Triggering the analysis is done thanks to a **SonarQube Scanner** - just like everyone would do for any SonarQube analysis. Depending on the build technology that you are using, you will use [one SonarQube Scanner or another](http://redirect.sonarsource.com/doc/analyzing-source-code.html).  

For example, using the standard [SonarQube Scanner](http://redirect.sonarsource.com/doc/install-configure-scanner.html), you can simply trigger the analysis this way:

    script:
      - sonar-scanner -Dsonar.login=$SONAR_TOKEN

The `sonar-scanner` executable is installed and configured by the SonarQube add-on, nothing to do!

The `sonar.login` parameter is a user token that you will have created for your account on your SonarQube.com. In this example, you pass it as a `$SONAR_TOKEN` environment variable that you might have set in the Travis settings of your project or specified in the `.travis.yml` file using `travis encrypt` to secure it.


## Upcoming improvements

Next versions of this add-on will provide the following features:

 * Remove the need to pass the `sonar.login` parameter in the command-line
 * Proper and transparent management of branches (currently, you will have to use the `sonar.branch` parameter to properly analyze different branches of your repository)
 * Less configuration and scripting required to analyze pull requests
