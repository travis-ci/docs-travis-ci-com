## How to opt in to different deployment tooling versions

In order to use different version of our deployment tooling, please add the
following to your `.travis.yml`:

```yaml
deploy:
  provider: <provider>
  # ⋮
  dpl_version: <version> # Optional, defaults to the latest stable version
```
if you want to use the latest edge version of the deployment tooling:

```yaml
deploy:
  provider: <provider>
  # ⋮
  edge: true
```
if you want to use other edge version of the deployment tooling:

```yaml
deploy:
  provider: <provider>
  # ⋮
  dpl_version: <version.beta>
  edge: true
```

{: data-file=".travis.yml"}
