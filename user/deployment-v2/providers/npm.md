---
title: NPM Releases
layout: en
deploy: v2
provider: npm
---

Travis CI can automatically release to [NPM](https://www.npmjs.com)
or another npm-like registry after a successful build.

{% include deploy/providers/npm.md %}

## NPM auth token

Your NPM Auth token can be obtained the following ways:

Log in to your NPM account, and generate a new token at `https://www.npmjs.com/settings/<user>/tokens`,
where `<user>` is the name of your user account.

Or use the NPM CLI command [`npm adduser`](https://docs.npmjs.com/cli/adduser)
to create a user, then open the `~/.npmrc` file:

* For NPM v2+, use the `authToken` value.
* For NPM ~1, use the `auth` value.

## Tagging releases

You can automatically add [npm distribution tags](https://docs.npmjs.com/getting-started/using-tags)
using the `tag` option:

```yaml
deploy:
  # ⋮
  tag: next
```
{: data-file=".travis.yml"}

## Note on .gitignore

Note that `npm` deployment honors `.gitignore` if `.npmignore` does not exist.
This means that if your build creates artifacts in places listed in `.gitignore`,
they will not be included in the uploaded package.

See [`npm` documentation](https://docs.npmjs.com/misc/developers#keeping-files-out-of-your-package)
for more details.

If your `.gitignore` file matches something that your build creates, use
[`before_deploy`](#running-commands-before-and-after-deploy) to change
its content, or create (potentially empty) `.npmignore` file
to override it.

## Troubleshooting "npm ERR! You need a paid account to perform this action."

`npm` assumes that [scoped packages](https://docs.npmjs.com/misc/scope) are
private by default. You can explicitly tell npm your package is a public package
and avoid this error by adding the following to your `package.json` file:

```json
  "publishConfig": {
    "access": "public"
  },
```

{% include deploy/shared.md tags=true %}

