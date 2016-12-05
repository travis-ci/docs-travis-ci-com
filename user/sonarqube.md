---
title: Using SonarQube.com with Travis CI
layout: en
permalink: /user/sonarqube/
---

[SonarQube.com](https://sonarqube.com) is a cloud service offered by [SonarSource](https://sonarsource.com) and based on [SonarQube](http://www.sonarqube.org). SonarQube is a widely adopted open source platform to inspect continuously the quality of source code and detect bugs, vulnerabilities and code smells in more than 20 different languages.

Please refer to the [SonarQube documentation](http://redirect.sonarsource.com/doc/analyzing-source-code.html) for more details on how to configure different scanners.

## Requirements

You are using one of the two following environments:

* [CI Environment with JVM VM image](/user/ci-environment/) - for instance:

```yaml
language: java
```

* [Trusty CI Environment](/user/trusty-ci-environment/):

```yaml
dist: trusty
```

## Inspecting code with the SonarQube Scanner

Before inspecting your code, you need to:

1. [Create a user authentication token](https://sonarqube.com/account/security) for your account on SonarQube.com.
2. [Encrypt this token](/user/encryption-keys/#Usage): `travis encrypt abcdef0123456789`
3. Create a `sonar-project.properties` file for your project (see the [documentation](http://redirect.sonarsource.com/doc/install-configure-scanner.html)).

Then add the following lines to your `.travis.yml` file to trigger the analysis:

```yaml
addons:
  sonarqube:
    token:
      secure: ********* # encrypted value of your token
script:
  # other script steps might be done before running the actual SonarQube analysis
  - sonar-scanner
```

Please take a look at the [live example project](https://github.com/SonarSource/sq-com_example_standard-sqscanner-travis) to know more about this standard use case.

### SonarQube Scanner for Maven

Lots of Java projects build with Maven. To add a SonarQube inspection to your Maven build, add the following to your `.travis.yml` file:

```yaml
addons:
  sonarqube:
    token:
      secure: ********* # encrypted value of your token
script:
  # the following command line builds the project, runs the tests with coverage and then execute the SonarQube analysis
  - mvn clean org.jacoco:jacoco-maven-plugin:prepare-agent install sonar:sonar
```

Please take a look at the [live Maven-based example project](https://github.com/SonarSource/sq-com_example_java-maven-travis) to know more about this use case.

## Activation for branches

By default, the SonarQube.com add-on only analyzes the master branch. Activate it on other branches by specifying them in the `branches` parameter:

```yaml
addons:
  sonarqube:
    token:
      secure: *********
  branches:
    - master
    - maintenance
script:
  - sonar-scanner
```

`branches` accepts a list of regular expressions.

> Note that currently, each branch ends up being a dedicated project on SonarQube.com.

## Activation for pull requests

SonarQube.com can inspect internal pull requests of your repository and write comments on each line where issues are found.

> For security reasons, this advanced feature works only for **internal** pull requests. In other words, pull requests built from forks won't be inspected.

To activate analysis on pull requests, you need to follow those extra steps:

1. Generate a [personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) for the GitHub user which will be used by SonarQube.com to write the comments.
  - Requirements for that token are listed on [that page](http://docs.sonarqube.org/display/PLUG/GitHub+Plugin).
2. Encrypt this token.
3. Add it to your `.travis.yml` file:

```yaml
addons:
  sonarqube:
    token:
      secure: *********
    github_token:
      secure: *********
script:
  - sonar-scanner
```

## Upcoming improvements

Next versions of this add-on will provide the following features:

- No need to define a third-party GitHub user for pull request analysis.
- Support for external pull requests.
