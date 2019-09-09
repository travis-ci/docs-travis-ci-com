## Known options

Use the following options to further configure the deployment:

| `user_id` | Chef Supermarket user name &mdash; **required**, type: string |
| `name` | Cookbook name &mdash; type: string, alias: `cookbook_name` (deprecated, please use `name`), note: defaults to the name given in metadata.json or metadata.rb |
| `category` | Cookbook category in Supermarket &mdash; **required**, type: string, alias: `cookbook_category` (deprecated, please use `category`), see: [https://docs.getchef.com/knife_cookbook_site.html#id12](https://docs.getchef.com/knife_cookbook_site.html#id12) |
| `client_key` | Client API key file name &mdash; type: string, default: `client.pem` |
| `dir` | Directory containing the cookbook &mdash; type: string, default: `.` |

