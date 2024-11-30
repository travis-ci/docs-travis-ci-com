---
title: Use Python with Travis CI
layout: en
---

The following is a guide to getting started with Travis CI using Python.

## Prerequisite
In the root of your Python project, create a file named `.travis.yml`. This file defines how Travis CI builds and tests your project.

## Specify the Language and Version
Add the following code to let Travis CI know you are working with Python and the versions you want to test against:

 ```yaml
language: python
python:
  - "3.8"
  - "3.9"
  - "3.10"
 ```
{: data-file=".travis.yml"}

## Install Build Dependencies
Travis CI will automatically run commands to install your dependencies. In our example, a `requirements.txt` file manages dependencies. 

 ```yaml
 install:
  - pip install -r requirements.txt
```
{: data-file=".travis.yml"}

## Define the Test Command
Specify a command to run your tests. The example below uses `pytest`:

 ```yaml
 script:
  - pytest
```
{: data-file=".travis.yml"}

## Commit and Push 
Once you’ve configured your `.travis.yml` file, push it to your GitHub repository, and Travis CI will trigger the build and test process automatically. The following is the complete example:

```yaml
language: python
python:
  - "3.8"
  - "3.9"
  - "3.10"
install:
  - pip install -r requirements.txt
script:
  - pytest
```
{: data-file=".travis.yml"}

## Further Reading
For more information on Python projects, see:
* [Building a Python Project](/user/languages/python/)
* [First .travis.yml file](https://youtu.be/MLMwfDjMMIE)
* [Getting Started with Python](https://www.youtube.com/watch?v=nkqgB7VNDEE)
