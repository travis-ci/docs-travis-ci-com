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

## Analysis of internal pull requests

SonarCloud can inspect internal pull requests of your repository and write comments on each line where issues are found.

> For security reasons, this advanced feature works only for **internal** pull requests. In other words, pull requests built from forks won't be inspected.

To activate analysis on pull requests, you need to follow those extra steps:

1. Generate a [personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) for the GitHub user which will be used by SonarCloud to write the comments.
  - This GitHub user should not be one of the developers, but rather a technical account which has write access to the repository and which will act as a bot
  - The token must have the following scopes:
    -  "repo:status" and "public_repo" for public repositories
    -  all of "repo" scope for private repositories
2. Go to the "Administration > General Settings > Pull Requests" page of your project on SonarCloud
  - Enter this token in the "GitHub > Authentication token" section 

> When specifying the token in SonarCloud, make sure that you click twice on "Save"! To be sure that your token was saved, reload the administration page and make sure that you see a "Change" button on the "Authentication token" section.

## Upcoming improvements

Future versions of this add-on will provide the following features:

- No need to define a third-party GitHub user for pull request analysis. SonarCloud will use its own identity.
- Support for external pull requests.

## Depreated features

If you are a long-time SonarCloud user, you might have the following entries in your `.travis.yml` file:
- "branches"
- "github_token"

If this is the case, you will get warnings in the log, telling you that this behaviour will be removed soon. You should get rid of those entries in your `.travis.yml` file to benefit from the latest features of SonarCloud.
