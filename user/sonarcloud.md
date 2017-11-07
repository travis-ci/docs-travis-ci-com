---
title: Using SonarCloud with Travis CI
layout: en
redirect_from:
  - /user/sonarqube/
---

[SonarCloud](https://sonarcloud.io) is a cloud service offered by [SonarSource](https://sonarsource.com) and based on [SonarQube](http://www.sonarqube.org). SonarQube is a widely adopted open source platform to inspect continuously the quality of source code and detect bugs, vulnerabilities and code smells in more than 20 different languages.

Please refer to the [SonarQube documentation](http://redirect.sonarsource.com/doc/analyzing-source-code.html) for more details on how to configure different scanners.

## Requirements

You are using one of the two following environments:

* [CI Environment with JVM VM image](/user/reference/precise/) - for instance:

```yaml
language: java
```
{: data-file=".travis.yml"}

* [Trusty CI Environment](/user/reference/trusty/):

```yaml
dist: trusty
```
{: data-file=".travis.yml"}

## Inspecting code with the SonarQube Scanner

Before inspecting your code, you need to:

1. [Create a user authentication token](https://sonarcloud.io/account/security) for your account on SonarCloud.
2. [Encrypt this token](/user/encryption-keys/#Usage) `travis encrypt abcdef0123456789` or define `SONAR_TOKEN` in your [Repository Settings](/user/environment-variables/#Defining-Variables-in-Repository-Settings)
3. [Find which SonarCloud.io organization](https://sonarcloud.io/account/organizations) you want to push your project on and get its key
4. Create a `sonar-project.properties` file for your project (see the [documentation](http://redirect.sonarsource.com/doc/install-configure-scanner.html)).

Then add the following lines to your `.travis.yml` file to trigger the analysis:

```yaml
addons:
  sonarcloud:
    organization: "sonarcloud_organization_key" # the key of the org you chose at step #3
    token:
      secure: ********* # encrypted value of your token
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
      secure: ********* # encrypted value of your token
script:
  # the following command line builds the project, runs the tests with coverage and then execute the SonarCloud analysis
  - mvn clean org.jacoco:jacoco-maven-plugin:prepare-agent install sonar:sonar
```
{: data-file=".travis.yml"}

Please take a look at the [live Maven-based example project](https://github.com/SonarSource/sq-com_example_java-maven-travis) to know more about this use case.

## Activation for branches

By default, the SonarCloud add-on only analyzes the master branch. Activate it on other branches by specifying them in the `branches` parameter:

```yaml
addons:
  sonarcloud:
    organization: "sonarcloud_organization_key"
    token:
      secure: *********
    branches:
      - master
      - maintenance
script:
  - sonar-scanner
```
{: data-file=".travis.yml"}

`branches` accepts a list of regular expressions.

> Note that currently, each branch ends up being a dedicated project on SonarCloud.

## Activation for internal pull requests

SonarCloud can inspect internal pull requests of your repository and write comments on each line where issues are found.

> For security reasons, this advanced feature works only for **internal** pull requests. In other words, pull requests built from forks won't be inspected.

To activate analysis on pull requests, you need to follow those extra steps:

1. Generate a [personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) for the GitHub user which will be used by SonarCloud to write the comments.
  - Requirements for that token are listed on [that page](http://docs.sonarqube.org/display/PLUG/GitHub+Plugin).
2. Encrypt this token.
3. Add it to your `.travis.yml` file:

```yaml
addons:
  sonarcloud:
    organization: "sonarcloud_organization_key"
    token:
      secure: *********
    github_token:
      secure: *********
script:
  - sonar-scanner
```
{: data-file=".travis.yml"}

## Upcoming improvements

Future versions of this add-on will provide the following features:

- No need to define a third-party GitHub user for pull request analysis.
- Support for external pull requests.
