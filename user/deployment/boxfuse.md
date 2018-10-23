---
title: Boxfuse Deployment
layout: en

---

Travis CI can automatically deploy your [Boxfuse](https://boxfuse.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```yaml
deploy:
  provider: boxfuse
  user: "YOUR BOXFUSE CLIENT USER"
  secret: "YOUR BOXFUSE CLIENT SECRET"
  payload: "YOUR APPLICATION ARTIFACT (typically a jar, war, tar.gz or zip file)"
```
{: data-file=".travis.yml"}

We recommended that you encrypt your Boxfuse user and secret. Assuming you have the Travis CI command line client installed, you can do it like this (you will be prompted for values on the command line):

```bash
travis encrypt --add deploy.user
travis encrypt --add deploy.secret
```

Alternatively you can pass in your credentials using Travis CI [encrypted environment variables](/user/environment-variables/#encrypting-environment-variables) called `BOXFUSE_USER` and `BOXFUSE_SECRET`. You can define these variables either using the Travis CI command line client or directly in the Travis CI repository settings UI.

Finally you can also fully configure Boxfuse by placing a `boxfuse.conf` file in the root of your repository. More info about configuration in the [Boxfuse Command-line Client documentation](https://boxfuse.com/docs/commandline/).

### Specifying the Boxfuse app and image version

By default Boxfuse will detect the app and the version automatically from the name of your payload file. You can override this like this:

```yaml
deploy:
  provider: boxfuse
  user: "YOUR BOXFUSE CLIENT USER"
  secret: "YOUR BOXFUSE CLIENT SECRET"
  payload: "YOUR APPLICATION ARTIFACT (typically a jar, war, tar.gz or zip file)"
  image: "YOUR BOXFUSE APP AND VERSION (ex.: myapp:1.23)"
```
{: data-file=".travis.yml"}

You can also use Travis CI [environment variables](/user/environment-variables) like `TRAVIS_BUILD_NUMBER` to assign a version to the image. Ex.: `image: "myapp:$TRAVIS_BUILD_NUMBER"`

### Specifying the Boxfuse environment

By default Boxfuse will deploy to your `test` environment. You can override this like this:

```yaml
deploy:
  provider: boxfuse
  user: "YOUR BOXFUSE CLIENT USER"
  secret: "YOUR BOXFUSE CLIENT SECRET"
  payload: "YOUR APPLICATION ARTIFACT (typically a jar, war, tar.gz or zip file)"
  env: "YOUR BOXFUSE ENVIRONMENT (default: test)"
```
{: data-file=".travis.yml"}

### Using alternative configuration files

You can also fully configure Boxfuse by placing a `boxfuse.conf` file in the root of your repository. You can specify an alternative configuration file like this:

```yaml
deploy:
  provider: boxfuse
  configfile: "YOUR BOXFUSE CONFIGURATION FILE"
```
{: data-file=".travis.yml"}

### Specifying custom arguments

If the [Boxfuse Client](https://boxfuse.com/docs/commandline) functionality you need is not included here, you can pass additional arguments to the Boxfuse executable by using the `extra_args` parameter:

```yaml
deploy:
  provider: boxfuse
  extra_args: "YOUR EXTRA ARGS (ex.: -X)"
```
{: data-file=".travis.yml"}

### Further information

Go to the [Boxfuse website](https://boxfuse.com) to learn more about Boxfuse and how to configure it.
