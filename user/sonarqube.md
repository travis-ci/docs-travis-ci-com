---
title: Using SonarQube.com with Travis CI
layout: en
permalink: /user/sonarqube/
---

[SonarQube.com](https://sonarqube.com) is a cloud service offered by [SonarSource](https://sonarsource.com) and based on [SonarQube](http://www.sonarqube.org). SonarQube is a widely adopted open source platform to inspect continuously the quality of source code and detect bugs, vulnerabilities and code smells in more than 20 different languages.

Please refer to the [SonarQube documentation](http://redirect.sonarsource.com/doc/analyzing-source-code.html) for more details on how to configure different scanners.

## Inspecting code with the SonarQube Scanner

Before inspecting your code, you need to:

1. Create a user token for your account on SonarQube.com.
2. [Encrypt this token](/user/encryption-keys/#Usage) in a `SONAR_TOKEN` variable.
3. Create a `sonar-project.properties` file for your project (see the [documentation](http://redirect.sonarsource.com/doc/install-configure-scanner.html)).

Then add the following lines to your `.travis.yml` file to trigger the analysis:

```yaml
addons:
  sonarqube: true
env:
  global:
    - secure: ********* # defines SONAR_TOKEN=abcdef0123456789
script:
  # other script steps might be done before running the actual SonarQube analysis
  - sonar-scanner -Dsonar.login=$SONAR_TOKEN
```

### SonarQube Scanner for Maven

Lots of Java projects build with Maven. To add a SonarQube inspection to your Maven build, add the following to your `.travis.yml` file:

```yaml
addons:
  sonarqube: true
env:
  global:
    - secure: ********* # defines SONAR_TOKEN=abcdef0123456789
script:
  # the following command line builds the project, runs the tests with coverage and then execute the SonarQube analysis
  - mvn clean org.jacoco:jacoco-maven-plugin:prepare-agent install sonar:sonar -Dsonar.login=$SONAR_TOKEN
```

## Upcoming improvements

Next versions of this add-on will provide the following features:

- Remove the need to pass the `sonar.login` parameter in the command-line
- Proper and transparent management of branches (currently, you will have to use the `sonar.branch` parameter to properly analyze different branches of your repository)
- Less configuration and scripting required to analyze pull requests
