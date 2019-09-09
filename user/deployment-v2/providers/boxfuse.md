---
title: Boxfuse Deployment
layout: en
deploy: v2
provider: boxfuse
---

Travis CI can automatically deploy your [Boxfuse](https://boxfuse.com/) application after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: boxfuse
  user: <user>
  secret: <secret>
  payload: <path/to/artifact> # typically a jar, war, tar.gz or zip file
```
{: data-file=".travis.yml"}

{% include deploy/providers/boxfuse.md %}

Finally you can also configure Boxfuse by placing a `boxfuse.conf` file in the
root of your repository. More info about configuration in the
[Boxfuse Command-line Client documentation](https://boxfuse.com/docs/commandline/).

### Specifying the app and image version

By default Boxfuse will detect the app and the version automatically from the
name of your payload file.

You can override this using the following:

```yaml
deploy:
  provider: boxfuse
  # ⋮
  image: <image> # boxfuse app and version (e.g. myapp:1.23)
```
{: data-file=".travis.yml"}

You can also use Travis CI [environment variables](/user/environment-variables)
like `TRAVIS_BUILD_NUMBER` to assign a version to the image, e.g.
`image: "myapp:$TRAVIS_BUILD_NUMBER"`.

### Specifying the environment

By default Boxfuse will deploy to your `test` environment.

You can override this using the following:

```yaml
deploy:
  provider: boxfuse
  # ⋮
  env: <env>
```
{: data-file=".travis.yml"}

### Specifying a configuration file

You can also fully configure Boxfuse by placing a `boxfuse.conf` file in the
root of your repository. You can specify an alternative configuration file like
this:

```yaml
deploy:
  provider: boxfuse
  # ⋮
  config_file: ./boxfuse-alt.conf
```
{: data-file=".travis.yml"}

### Specifying custom arguments

If the [Boxfuse Client](https://boxfuse.com/docs/commandline) functionality you
need is not included here, you can pass additional arguments to the Boxfuse
executable by using the `extra_args` parameter:

```yaml
deploy:
  provider: boxfuse
  extra_args: <extra_args> # e.g. -X
```
{: data-file=".travis.yml"}

### Further information

Go to the [Boxfuse website](https://boxfuse.com) to learn more about Boxfuse
and how to configure it.

{% include deploy/shared.md %}
