---
title: Using SonarQube.com with Travis CI
layout: en
permalink: /user/sonarqube/
---
**[SonarQube.com](https://sonarqube.com)** is the cloud service based on [SonarQube](http://www.sonarqube.org), the widely adopted "continuous inspection" open source platform that allows developers to find bugs, vulnerabilities and code smells in more than 20 different languages. It offers all the dashboards and tools to continuously track modifications of your code to make sure your code will only get better and better over time.

SonarQube.com is free for open-source projects. The only requirement is to have a GitHub account to connect to the service. It is then up to you to trigger the analysis, and this is where this Travis CI add-on simplifies your user experience.

## Trigger an analysis

Triggering the analysis is done thanks to a **SonarQube Scanner** - just like everyone would do for any SonarQube analysis. Depending on the build technology that you are using, you will use one SonarQube Scanner or another. Please refer to the [online documentation for SonarQube Scanners](http://redirect.sonarsource.com/doc/analyzing-source-code.html) in order to have more details.  

### Using the SonarQube Scanner

Most projects will use the SonarQube Scanner, and here is the simplest `.travis.yml` file to trigger the analysis in this case:

    addons:
      sonarqube: true
    env:
      global:
        - secure: ********* # defines SONAR_TOKEN=abcdef0123456789

    script:
      # other script steps might be done before running the actual SonarQube analysis
      - sonar-scanner -Dsonar.login=$SONAR_TOKEN

The `SONAR_TOKEN` parameter is a user token that you will have created for your account on your SonarQube.com. Note that you might as well have defined it an environment variable in the Travis settings of your project instead of putting it right into the `.travis.yml` file.

### Using the SonarQube Scanner for Maven

Lost of Java projects build with Maven. In that case, a simple `.travis.yml` file would look like:

    addons:
      sonarqube: true
    env:
      global:
        - secure: ********* # defines SONAR_TOKEN=abcdef0123456789

    script:
      # the following command line builds the project, runs the tests with coverage and then execute the SonarQube analysis
      - mvn clean org.jacoco:jacoco-maven-plugin:prepare-agent install sonar:sonar -Dsonar.login=$SONAR_TOKEN

## Upcoming improvements

Next versions of this add-on will provide the following features:

 * Remove the need to pass the `sonar.login` parameter in the command-line
 * Proper and transparent management of branches (currently, you will have to use the `sonar.branch` parameter to properly analyze different branches of your repository)
 * Less configuration and scripting required to analyze pull requests
