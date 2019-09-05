---
title: Transifex Deployment
layout: en
deploy: v2
provider: transifex
---

Travis CI supports uploading to [Transifex](https://www.transifex.com/).

A minimal configuration is:

```yaml
deploy:
  provider: transifex
  controller: transifex.transifexapps.com
  username: "Transifex User Name"
  password: "Transifex Password"
  app: App_name
  cli_version: vX.Y.Z  # e.g. v2.7.0 being the latest at this time
```
{: data-file=".travis.yml"}

It is recommended that you encrypt your password.
Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
$ travis encrypt "YOUR TRANSIFEX PASSWORD" --add deploy.password
```

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

```bash
$ travis setup transifex
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

{% include deploy/shared.md %}
