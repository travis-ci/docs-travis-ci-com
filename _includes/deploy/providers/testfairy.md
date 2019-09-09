## Status

Support for deployments to TestFairy is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment:

| `api_key` | TestFairy API key &mdash; **required**, **secret**, type: string |
| `app_file` | Path to the app file that will be generated after the build (APK/IPA) &mdash; **required**, type: string |
| `symbols_file` | Path to the symbols file &mdash; type: string |
| `testers_groups` | Tester groups to be notified about this build &mdash; type: string, e.g.: e.g. group1,group1 |
| `notify` | Send an email with a changelog to your users &mdash; type: boolean |
| `auto_update` | Automaticall upgrade all the previous installations of this app this version &mdash; type: boolean |
| `advanced_options` | Comma_separated list of advanced options &mdash; type: string, e.g.: option1,option2 |

## Environment variables

All options can be given as environment variables if prefixed with `TESTFAIRY_`.

For example, `api_key` can be given as `TESTFAIRY_API_KEY=<api_key>`.

{% include deploy/secrets.md name="api_key" env_name="TESTFAIRY_API_KEY" %}