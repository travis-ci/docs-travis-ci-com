## How to opt in to v2

In order to use version `v2` of our deployment tooling, please add the
following to your `.travis.yml`:

```yaml
deploy:
  provider: <provider>
  # ⋮
  edge: true
```
{: data-file=".travis.yml"}
