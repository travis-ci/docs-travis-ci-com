---
title: npm Releasing
layout: en
---

Travis CI can automatically release your npm package to [npmjs.com][npmjs]
or another npm-like registry after a successful build. By default Travis CI
publishes to npmjs.com, however if you have a `publishConfig.registry` key in your
`package.json` then Travis CI publishes to that registry instead.





A minimal `.travis.yml` configuration for publishing to [npmjs.com][npmjs] with npm version 2+ looks like:

```yaml
deploy:
  provider: npm
  email: "YOUR_EMAIL_ADDRESS"
  api_key: "YOUR_AUTH_TOKEN"
```
{: data-file=".travis.yml"}

You can have the `travis` tool set up everything for you:

```bash
$ travis setup npm
```

Keep in mind that the above command has to run in your project directory, so
it can modify the `.travis.yml` for you.

## NPM auth token

Your NPM Auth Token can be obtained by:

1. Log in to your NPM account, and generate a new token at `https://www.npmjs.com/settings/USER/tokens`, where
  `USER` is the name of the user account which is capable of publishing the npm package.
1. Use the NPM CLI command [`npm adduser`](https://docs.npmjs.com/cli/adduser) to create a user, then open the `~/.npmrc` file:
    1. For NPM v2+, use the `authToken` value.
    1. For NPM ~1, use the `auth` value.

Always [encrypt](/user/encryption-keys/#Usage) your auth token. Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
$ travis encrypt YOUR_AUTH_TOKEN --add deploy.api_key
```

## What to release

Most likely, you would only want to deploy to npm when a new version of your
package is cut. To do this, you can tell Travis CI to only deploy on tagged
commits, like so:

```yaml
deploy:
  ...
  on:
    tags: true
```
{: data-file=".travis.yml"}

If you tag a commit locally, remember to run `git push --tags` to ensure that
your tags are uploaded to GitHub.

You can explicitly specify the branch to release from with the **on** option:

```yaml
deploy:
  ...
  on:
    branch: production
```
{: data-file=".travis.yml"}

Alternatively, you can also configure Travis CI to release from all branches:

```yaml
deploy:
  ...
  on:
    all_branches: true
```
{: data-file=".travis.yml"}

Builds triggered from Pull Requests will never trigger a release.

## Releasing build artifacts

After your tests ran and before the release, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts that are supposed to be released, too. There is now an option to skip the clean up:

```yaml
deploy:
  ...
  skip_cleanup: true
```
{: data-file=".travis.yml"}

## Conditional releases

[A deployment issue](https://github.com/travis-ci/travis-ci/issues/4738) is
reported when multiple attempts are made.
We recommend deploying from only one job with
[Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

## Tagging releases

You can automatically add [npm distribution tags](https://docs.npmjs.com/getting-started/using-tags) with the `tag` option:

```yaml
deploy:
  ...
  tag: next
```
{: data-file=".travis.yml"}

## Note on `.gitignore`

Notice that `npm` deployment honors `.gitignore` if `.npmignore` does not exist.
This means that if your build creates artifacts in places listed in `.gitignore`,
they will not be included in the uploaded package.

See [`npm` documentation](https://docs.npmjs.com/misc/developers#keeping-files-out-of-your-package)
for more details.

If your `.gitignore` file matches something that your build creates, use
[`before_deploy`](#Running-commands-before-and-after-deploy) to change
its content, or create (potentially empty) `.npmignore` file
to override it.

## Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually deploying.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}

## Troubleshooting "npm ERR! You need a paid account to perform this action."

npm assumes that [scoped packages](https://docs.npmjs.com/misc/scope) are
private by default. You can explicitly tell npm your package is a public package
and avoid this error by adding the following to your `package.json` file:

```json
  "publishConfig": {
    "access": "public"
  },
```

[npmjs]: https://npmjs.com/
