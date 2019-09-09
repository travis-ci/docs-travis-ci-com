## Status

Support for deployments to Bintray is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `user` | Bintray user &mdash; **required**, type: string |
| `key` | Bintray API key &mdash; **required**, **secret**, type: string |
| `file` | Path to a descriptor file for the Bintray upload &mdash; **required**, type: string |
| `passphrase` | Passphrase as configured on Bintray (if GPG signing is used) &mdash; type: string |

## Environment variables

All options can be given as environment variables if prefixed with `BINTRAY_`.

For example, `key` can be given as `BINTRAY_KEY=<key>`.

{% include deploy/secrets.md name="key" env_name="BINTRAY_KEY" %}