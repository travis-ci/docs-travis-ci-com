---
title: npm Releasing
layout: en
permalink: /user/deployment/npm/
---

Travis CI can automatically release your npm package to [npmjs.org](https://npmjs.org/) after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: npm
      email: "YOUR EMAIL ADDRESS"
      api_key: "YOUR API KEY"

Most likely, you would only want to deploy to npm when a new version of your
package is cut. To do this, you can tell Travis CI to only deploy on tagged
commits, like so:

    deploy:
      provider: npm
      email: "YOUR EMAIL ADDRESS"
      api_key: "YOUR API KEY"
      on:
        tags: true

If you tag a commit locally, remember to run `git push --tags` to ensure that your tags are uploaded to Github.

You can find your api key in `~/.npmrc`.

It is recommended to encrypt that key. Assuming you have the Travis CI command line client installed, you can do it like this:

    travis encrypt --add deploy.api_key

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

    $ travis setup npm

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Branch to release from

You can explicitly specify the branch to release from with the **on** option:

    deploy:
      provider: npm
      email: ...
      api_key: ...
      on:
        branch: production

Alternatively, you can also configure Travis CI to release from all branches:

    deploy:
      provider: npm
      email: ...
      api_key: ...
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a release.

### Releasing build artifacts

After your tests ran and before the release, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts that are supposed to be released, too. There is now an option to skip the clean up:

    deploy:
      provider: npm
      email: ...
      api_key: ...
      skip_cleanup: true

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

### Running commands before and after release

Sometimes you want to run commands before or after releasing a package. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.
