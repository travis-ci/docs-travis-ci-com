---
title: Use Java with Travis CI
layout: en
---

The following is a guide to getting started with Travis CI using Java.

## Prerequisite
Before getting started, create a `.travis.yml` file and add it to the root directory of your Java project. This file defines how Travis CI builds and tests your project.

## Specify the Language and JDK Version
Add the following code to let Travis CI know you are working with Java:

```yaml
language: java
```
{: data-file=".travis.yml"}

You can test your project across multiple Java versions. The following example uses `OpenJDK 11` and `OpenJDK 17`.

 ```yaml
jdk:
  - openjdk11
  - openjdk17
```
{: data-file=".travis.yml"}

### Install Build Dependencies
Travis CI automatically installs project dependencies based on your build tool (like Maven or Gradle). For Maven projects, use the following command:

 ```yaml
install:
  - mvn install -DskipTests=true -B -V
```
{: data-file=".travis.yml"}

The command above installs all necessary dependencies without running any tests during the installation. 

## Define the Test Command
Use the `script` key to specify the command you want Travis CI to run your unit tests. For a Maven project, use the following code:

 ```yaml
script:
  - mvn test
```
{: data-file=".travis.yml"}

The code above runs unit tests with the default Maven settings.  
 
## Commit and Push
Once the file is created, commit it to your repository. Travis CI detects the file and automatically starts building and testing your project each time you push a new change. The following is the complete code:
 
 ```yaml
language: java
jdk:
  - openjdk11
  - openjdk17
install:
  - mvn install -DskipTests=true -B -V
script:
  - mvn test
```
{: data-file=".travis.yml"}

## Further Reading
For more information on Java projects, see:
* [Building a Java Project](/user/languages/java/)
* [Building a JavaScript Project](/user/languages/javascript-with-nodejs/)
