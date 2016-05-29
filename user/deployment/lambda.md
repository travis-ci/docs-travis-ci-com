---
title: Lambda Deployment
layout: en
permalink: /user/deployment/lambda/
---

Travis CI supports uploading to [AWS Lambda](https://aws.amazon.com/lambda/).

A minimal configuration is:

```yaml
deploy:
  provider: lambda
  function_name: "lambda-test"
  role: "arn:aws:iam::0123456789012:role/lambda_basic_execution"
  handler_name: "index.handler"
  access_key_id: "AWS ACCESS KEY ID"
  secret_access_key: "AWS SECRET ACCESS KEY"
```

It is recommended that you encrypt your password.
Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
$ travis encrypt "AWS SECRET ACCESS KEY" --add deploy.secret_access_key
```

You will be prompted to enter your secret access key on the command line.

### Optional configuration parameters

See [documentation](https://github.com/travis-ci/dpl#lambda) for additional
configuration parameters

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).
