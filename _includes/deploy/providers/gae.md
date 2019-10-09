{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: gae
  project: <project>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Google App Engine is in **beta**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `project` | Project ID used to identify the project on Google Cloud &mdash; **required**, type: string |
| `keyfile` | Path to the JSON file containing your Service Account credentials in JSON Web Token format. To be obtained via the Google Developers Console. Should be handled with care as it contains authorization keys. &mdash; type: string, default: `service-account.json` |
| `config` | Path to your service configuration file &mdash; type: string or array of strings, default: `app.yaml` |
| `version` | The version of the app that will be created or replaced by this deployment. If you do not specify a version, one will be generated for you &mdash; type: string |
| `verbosity` | Adjust the log verbosity &mdash; type: string, default: `warning` |
| `promote` | Whether to promote the deployed version &mdash; type: boolean, default: `true` |
| `stop_previous_version` | Prevent the deployment from stopping a previously promoted version &mdash; type: boolean, default: `true` |
| `install_sdk` | Whether to install the Google Cloud SDK &mdash; type: boolean, default: `true` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

