## Status

Support for deployments to Rubygems is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `api_key` | Rubygems api key &mdash; **secret**, type: string |
| `username` | Rubygems user name &mdash; type: string, alias: `user` |
| `password` | Rubygems password &mdash; **secret**, type: string |
| `gem` | Name of the gem to release &mdash; type: string, default: `repo name` |
| `gemspec` | Gemspec file to use to build the gem &mdash; type: string |
| `gemspec_glob` | Glob pattern to search for gemspec files when multiple gems are generated in the repository (overrides the gemspec option) &mdash; type: string |
| `host` | type: string |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |

## Environment variables

All options can be given as environment variables if prefixed with `RUBYGEMS_`.

For example, `api_key` can be given as `RUBYGEMS_API_KEY=<api_key>`.

{% include deploy/secrets.md name="api_key" env_name="RUBYGEMS_API_KEY" %}