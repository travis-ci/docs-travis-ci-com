---
title: Deis Deployment
layout: en
permalink: /user/deployment/deis/
---

Travis CI supports uploading to [Deis](http://deis.io/).

A minimal configuration is:

```yaml
deploy:
  provider: deis
  controller: deis.deisapps.com
  username: "Deis User Name"
  password: "Deis Password"
  app: App_name
```

It is recommended that you encrypt your password.
Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
$ travis encrypt "YOUR DEIS PASSWORD" --add deploy.password
```

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

```bash
$ travis setup deis
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

### Note on `.gitignore`

As this deployment strategy relies on `git`, be mindful that the deployment will
honor `.gitignore`.

If your `.gitignore` file matches something that your build creates, use
[`before_deploy`](#Running-commands-before-and-after-deploy) to change
its content.

### Running commands before and after deploy

Sometimes you want to run commands before or after triggering a deployment. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.

```yaml
    before_deploy: "echo 'ready?'"
    deploy:
      ..
    after_deploy:
      - ./after_deploy_1.sh
      - ./after_deploy_2.sh
```
