## Status

Support for deployments to Heroku API is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `api_key` | Heroku API key &mdash; **required**, **secret**, type: string |

## Environment variables

All options can be given as environment variables if prefixed with `HEROKU_`.

For example, `api_key` can be given as `HEROKU_API_KEY=<api_key>`.

{% include deploy/secrets.md name="api_key" env_name="HEROKU_API_KEY" %}