---
title: Using SonarCloud with Travis CI
layout: en
redirect_from:
  - /user/sonarqube/
---

[SonarCloud](https://sonarcloud.io) is the leading online service to catch Bugs and Security Vulnerabilities in your Pull Requests and throughout your code repositories. Totally free for open-source projects (paid plan for private projects), SonarCloud pairs with existing cloud-based CI/CD workflows, and provides clear resolution guidance for any Code Quality or Security issue it detects. With already more than 1 billion lines of code under analysis, SonarCloud empowers development teams of all sizes to write cleaner and safer code, across more than 20 programming languages.

Please refer to the [SonarCloud documentation](https://sonarcloud.io/documentation) for more details.

## Requirements

If a Java JRE/JDK is present within the build environment, it has to be at least Java 11 or higher.

The default Travis dist
```yaml
dist: xenial
```
{: data-file=".travis.yml"}
inlcudes Java 11 by default.

## Inspecting code with the SonarQube Scanner

Before inspecting your code, you need to:

1. [Create a user authentication token](https://sonarcloud.io/account/security) for your account on SonarCloud.
2. [Encrypt this token](/user/encryption-keys/#usage) `travis encrypt abcdef0123456789` or define `SONAR_TOKEN` in your [Repository Settings](/user/environment-variables/#defining-variables-in-repository-settings)
3. [Find which SonarCloud.io organization](https://sonarcloud.io/account/organizations) you want to push your project on and get its key
4. Create a `sonar-project.properties` file for your project (see the [documentation](http://redirect.sonarsource.com/doc/install-configure-scanner.html)).

Then add the following lines to your `.travis.yml` file to trigger the analysis:

```yaml
addons:
  sonarcloud:
    organization: "sonarcloud_organization_key" # the key of the org you chose at step #3
    token:
      secure: "*********" # encrypted value of your token
script:
  # other script steps might be done before running the actual analysis
  - sonar-scanner
```
{: data-file=".travis.yml"}

Please take a look at the [live example project](https://github.com/SonarSource/sq-com_example_standard-sqscanner-travis) to know more about this standard use case.

### SonarQube Scanner for Maven

Lots of Java projects build with Maven. To add a SonarCloud inspection to your Maven build, add the following to your `.travis.yml` file:

```yaml
addons:
  sonarcloud:
    organization: "sonarcloud_organization_key" # the key of the org you chose at step #3
    token:
      secure: "*********" # encrypted value of your token
script:
  # the following command line builds the project, runs the tests with coverage and then execute the SonarCloud analysis
  - mvn clean verify sonar:sonar -Pcoverage -Dsonar.projectKey=myorg_myrepo
```
{: data-file=".travis.yml"}

> Please note the following:
- the "coverage" profile (defined in your POM file) activates the generation of the JaCoCo XML report
- "sonar.projectKey" can also be set as a property on the main POM file. Its value can be found on the right side of the project homepage on SonarCloud

Please take a look at the [live Maven-based example project](https://github.com/SonarSource/sq-com_example_java-maven-travis) to know more about this use case.

Without POM update, or if you are [Testing Against Multiple JDKs](languages/java/#testing-against-multiple-jdks) (SonarCloud analysis should be executed only once), or need multiple steps Maven commands ; execute [JaCoCo XML report generation](https://www.eclemma.org/jacoco/trunk/doc/report-mojo.html) at end of your main build. Script section would be like:

```yaml
script:
- mvn clean org.jacoco:jacoco-maven-plugin:prepare-agent package org.jacoco:jacoco-maven-plugin:report
- if [ "$JAVA_HOME" = "/usr/local/lib/jvm/openjdk11" ]; then mvn sonar:sonar; fi
```
{: data-file=".travis.yml"}

## Analysis of internal pull requests

SonarCloud can inspect internal pull requests of your repository and write comments on each line where issues are found.

> For security reasons, this advanced feature works only for **internal** pull requests. In other words, pull requests built from forks won't be inspected.

To activate analysis on pull requests, you need to [install the SonarCloud application](https://github.com/apps/sonarcloud) on your GitHub organization(s).

Note that if you used SonarCloud before the GitHub application and therefore configured GitHub tokens on your projects, you should now delete those tokens from the "Administration > General Settings > Pull Requests" page of your projects.

## Upcoming improvements

Future versions of this add-on will provide the following features:

- Support for external pull requests.

## Accessing full SCM history

Travis CI uses [shallow clone](https://docs.travis-ci.com/user/customizing-the-build/#git-clone-depth) to speed up build times, but a truncated SCM history may cause issues when SonarCloud computes blame data. To avoid this, you can access the full SCM history with:

```yaml
git:
  depth: false
```

## Deprecated features

If you are a long-time SonarCloud user, you might have the following entries in your `.travis.yml` file:
- "branches"
- "github_token"

If this is the case, you will get warnings in the log, telling you that this behaviour will be removed soon. You should get rid of those entries in your `.travis.yml` file to benefit from the latest features of SonarCloud.

## Note for SonarQube users

If you are familiar with SonarQube, you can be tempted to deal with some properties relatives to [Branch Analysis](https://docs.sonarqube.org/display/SONAR/Branch+Analysis) (ex: `sonar.branch.name`) and/or [Pull Request Analysis](https://docs.sonarqube.org/display/SONAR/Pull+Request+Analysis) (ex: `sonar.pullrequest.key`).

These properties are completely useless, the SonarCloud add-on manages them for you depending the analysis type.

## Build Config Reference

You can find more information on the build config format for [SonarCloud](https://config.travis-ci.com/ref/job/addons/sonarcloud) in our [Travis CI Build Config Reference](https://config.travis-ci.com/).

