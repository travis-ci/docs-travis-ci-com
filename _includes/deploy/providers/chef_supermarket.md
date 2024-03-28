{% unless include.minimal == false %}
For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: chef_supermarket
  user_id: <user_id>
  category: <category>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}



{{ include.content }}
{% endunless %}

## Status

Support for deployments to Chef Supermarket is in **alpha**. Please see [Maturity Levels](/user/deployment-v2#maturity-levels) for details.
## Known options

Use the following options to further configure the deployment.

| `user_id` | Chef Supermarket user name &mdash; **required**, type: string |
| `name` | Cookbook name &mdash; type: string, alias: `cookbook_name` (deprecated, please use `name`), note: defaults to the name given in metadata.json or metadata.rb |
| `category` | Cookbook category in Supermarket &mdash; **required**, type: string, alias: `cookbook_category` (deprecated, please use `category`), see: [https://docs.getchef.com/knife_cookbook_site.html#id12](https://docs.getchef.com/knife_cookbook_site.html#id12) |
| `client_key` | Client API key file name &mdash; type: string, default: `client.pem` |
| `dir` | Directory containing the cookbook &mdash; type: string, default: `.` |

### Shared options

| `cleanup` | Clean up build artifacts from the Git working directory before the deployment &mdash; type: boolean |
| `run` | Commands to execute after the deployment finished successfully &mdash; type: string or array of strings |


