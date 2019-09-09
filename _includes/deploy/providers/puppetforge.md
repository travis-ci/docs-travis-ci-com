## Status

Support for deployments to Puppet Forge is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `username` | Puppet Forge user name &mdash; **required**, type: string, alias: `user` |
| `password` | Puppet Forge password &mdash; **required**, **secret**, type: string |
| `url` | Puppet Forge URL to deploy to &mdash; type: string, default: `https://forgeapi.puppetlabs.com/` |

## Environment variables

All options can be given as environment variables if prefixed with `PUPPETFORGE_`.

For example, `password` can be given as `PUPPETFORGE_PASSWORD=<password>`.

{% include deploy/secrets.md name="password" env_name="PUPPETFORGE_PASSWORD" %}