---
title: Hackage Deployment
layout: en

---

Travis CI supports uploading to [Hackage](https://hackage.haskell.org/).

A minimal configuration is:

```yaml
deploy:
  provider: hackage
  username: "Hackage User Name"
  password: "Hackage Password"
```
{: data-file=".travis.yml"}

It is recommended to encrypt password.
Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
$ travis encrypt --add deploy.password
```

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

```bash
$ travis setup hackage
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).
