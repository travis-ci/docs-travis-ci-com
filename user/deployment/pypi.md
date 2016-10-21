---
title: PyPI deployment
layout: en
permalink: /user/deployment/pypi/
---

Travis CI can automatically release your Python package to [PyPI](https://pypi.python.org/) after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```
deploy:
  provider: pypi
  user: "Your username"
  password: "Your password"
```

Most likely, you would only want to deploy to PyPI when a new version of your
package is cut. To do this, you can tell Travis CI to only deploy on tagged
commits, like so:

```
deploy:
  provider: pypi
  user: ...
  password: ...
  on:
    tags: true
```

If you tag a commit locally, remember to run `git push --tags` to ensure that your tags are uploaded to GitHub.

Assuming you have the Travis CI command line client installed, you can encrypt your password like this:

```
travis encrypt --add deploy.password
```

You will be prompted to enter your password on the command line.

You can also have the `travis` tool set up everything for you:

```
$ travis setup pypi
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Branch to release from

You can explicitly specify the branch to release from with the **on** option:

```
deploy:
  provider: pypi
  user: ...
  password: ...
  on:
    branch: production
```

Alternatively, you can also configure Travis CI to release from all branches:

```
deploy:
  provider: pypi
  api_key: ...
  on:
    all_branches: true
```

By default, Travis CI will only release from the **master** branch.

Builds triggered from Pull Requests will never trigger a release.

### Releasing to a different index:

If you wish to release to a different index you can do so:

```
deploy:
      provider: pypi
      user: ...
      password:...
      server: https://mypackageindex.com/index
```

### Uploading different distributions

By default, only a source distribution ('sdist') will be uploaded to PyPI.
If you would like to upload different distributions, specify them using the `distributions` option, like this:

```
deploy:
  provider: pypi
  user: ...
  password: ...
  distributions: "sdist bdist_wheel" # Your distributions here
```

If you specify `bdist_wheel` in the distributions, the `wheel` package will automatically be installed.

### Releasing build artifacts

After your tests ran and before the release, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts that are supposed to be released, too. There is now an option to skip the clean up:

```
deploy:
  provider: pypi
  user: ...
  password: ...
  skip_cleanup: true
```

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

### Running commands before and after release

Sometimes you want to run commands before or after releasing a package. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.

```
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
