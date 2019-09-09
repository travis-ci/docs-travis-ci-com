## Deploying to multiple targets

Running multiple deployments to different providers (or the same provider with
different configurations) is possible by adding configurations to the `deploy`
section as a list. For example, if you want to deploy to both s3 and Heroku,
your `deploy` section would look something like this:

```yaml
deploy:
  - provider: s3
    access_key_id: <AWS access key id>
    secret_access_key: <AWS secret access key>
    # ⋮
  - provider: heroku
    api_key: <Heroku api key>
    # ⋮
```
{: data-file=".travis.yml"}

