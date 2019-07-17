---
title: Reporting artifacts to DeepSource
layout: en
---

[DeepSource](https://deepsource.io) is a source code analysis tool that flags anti-patterns, security vulnerabilities, style violations, and provides actionable issues and metrics.

DeepSource's analyzers accepts artifacts pushed from external sources via the CLI. An example artifact would be test coverage file.

The following guide walks through how to push an artifact as part of the build process.

## Set the DEEPSOURCE_DSN environment variable

To authenticate the artifact push, DeepSource provides a `DSN` per repository. It can be found under `Settings > Reporting` section of DeepSource's repository dashboard.
Refer to [Environment variables](https://docs.travis-ci.com/user/environment-variables/) section of Travis documentation for how to set environment variables.

Since the `DSN` consists of sensitive information, we recommend setting it via `Repository Settings` method as mentioned [here](https://docs.travis-ci.com/user/environment-variables/#defining-variables-in-repository-settings)

## Configure the analyzer in .deepsource.toml

Before pushing an artifact, make sure the analyzer is enabled in `.deepsource.toml` file.

For example: To push test coverage artifact, make sure the `test-coverage` analyzer is added to `.deepsource.toml` file.

```toml
[[analyzers]]
name = "test-coverage"
enabled = true
```

Refer to [DeepSource's analyzer documentation](https://deepsource.io/docs/analyzers/) for instructions specific to the analyzer.

## Install CLI and push artifacts

- Install deepsource CLI by executing `curl https://deepsource.io/cli | sh`
- Report the artifact by executing `./bin/deepsource report --analyzer <ANALYZER_SHORTCODE> --key <ARTIFACT_KEY> --value-file <ARTIFACT_VALUE_FILE>`

Refer to [DeepSource CLI documentation](https://deepsource.io/docs/configuration/cli.html) for detailed instructions.

## Example

The following `.travis.yml` configuration pushes python test coverage to DeepSource's `test-coverage` analyzer.

```yaml
# Set build language to Python
language: python

# Set python version to 3.6
python: 3.6

# Install dependencies
install:
  - pip install -r requirements.txt

# Run tests
script:
  - coverage run test_hello.py

# Report results to DeepSource
after_success:
  # Generate coverage report in xml format
  - coverage xml

  # Install deepsource CLI
  - curl https://deepsource.io/cli | sh

  # Report coverage artifact to 'test-coverage' analyzer
  - ./bin/deepsource report --analyzer test-coverage --key python --value-file ./coverage.xml
```

> Questions? We're happy to sort it out for you. Reach out to us at [support@deepsource.io](mailto:support@deepsource.io)
