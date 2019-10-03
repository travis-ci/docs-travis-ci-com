{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: pypi
  username: <username>
  password: <encrypted password>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to PyPI is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `username` | PyPI Username &mdash; **required**, type: string, alias: `user` |
| `password` | PyPI Password &mdash; **required**, **secret**, type: string |
| `server` | Release to a different index &mdash; type: string, default: `https://upload.pypi.org/legacy/` |
| `distributions` | Space-separated list of distributions to be uploaded to PyPI &mdash; type: string, default: `sdist` |
| `docs_dir` | Path to the directory to upload documentation from &mdash; type: string, default: `build/docs` |
| `skip_existing` | Do not overwrite an existing file with the same name on the server. &mdash; type: boolean |
| `upload_docs` | Upload documentation &mdash; type: boolean, default: `false`, note: most PyPI servers, including upload.pypi.org, do not support uploading documentation |
| `twine_check` | Whether to run twine check &mdash; type: boolean, default: `true` |
| `remove_build_dir` | Remove the build dir after the upload &mdash; type: boolean, default: `true` |
| `setuptools_version` | type: string, format: `/\A\d+(?:\.\d+)*\z/` |
| `twine_version` | type: string, format: `/\A\d+(?:\.\d+)*\z/` |
| `wheel_version` | type: string, format: `/\A\d+(?:\.\d+)*\z/` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `PYPI_`.

For example, `password` can be given as `PYPI_PASSWORD=<password>`.
{% include deploy/secrets.md name="password" env_name="PYPI_PASSWORD" %}