---
title: Building specific branches
layout: en
permalink: /user/customizing-the-build/specific-branches/
---

## Building Specific Branches

Travis CI uses the `.travis.yml` file from the branch containing the git commit that triggers the build. Include branches using a safelist, or exclude them using a blocklist.

### Safelisting or blocklisting branches

Specify which branches to build using a safelist, or blocklist branches that you do not want to be built:

```yml
# blocklist
branches:
  except:
  - legacy
  - experimental

# safelist
branches:
  only:
  - master
  - stable
```

> Note that safelisting also prevents tagged commits from being built. If you consistently tag your builds in the format `v1.3` you can safelist them all with [regular expressions](#Using-regular-expressions), for example `/^v\d+\.\d+(\.\d+)?(-\S*)?$/`.

If you use both a safelist and a blocklist, the safelist takes precedence. By default, the `gh-pages` branch is not built unless you add it to the safelist.

To build _all_ branches:

    branches:
      only:
        - gh-pages
        - /.*/

> Note that for historical reasons `.travis.yml` needs to be present *on all active branches* of your project.

### Using regular expressions

You can use regular expressions to safelist or blocklist branches:

```yaml
branches:
  only:
  - master
  - /^deploy-.*$/
```

Any name surrounded with `/` in the list of branches is treated as a regular expression and can contain any quantifiers, anchors or character classes supported by [Ruby regular expressions](http://www.ruby-doc.org/core-1.9.3/Regexp.html).

Options that are specified after the last `/` (e.g., `i` for case insensitive matching) are not supported but can be given inline instead.  For example, `/^(?i:deploy)-.*$/` matches `Deploy-2014-06-01` and other
branches and tags that start with `deploy-` in any combination of cases.
