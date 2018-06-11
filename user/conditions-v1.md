---
title: Conditions
layout: en
---

> This page documents the behavior of conditions `v1`, which is currently
> available using `conditions: v1` in your `.travis.yml` file. This new
> version replaces `v0` which is currently the default version, and in the
> process of being deprecated in favor of `v1`. The documentation for `v0` can
> be found [here](/user/conditions-v0).

Conditions can be used to filter out, and reject builds, stages, and jobs by
specifying conditions in your build configuration (your `.travis.yml` file).
See [Conditional Builds, Stages, and Jobs](/user/conditional-builds-stages-jobs)
for details.

## Examples

```
# require the branch name to be master (note for PRs this is the base branch name)
branch = master

# require the tag name to match a regular expression (enclose in slashes for
# more complicated expressions)
tag =~ ^v1
tag =~ /^(v1|v2)/

# require the event type to be either `push` or `pull_request`
type IN (push, pull_request)

# require the branch name to not be one of several names
branch NOT IN (master, dev)

# require the sender login name to match a given name (use quotes for strings
# that contain spaces or special characters)
sender == my_account
sender != "deploy bot"

# exclude forks
fork == false

# match the commit message
commit_message !~ /no-deploy/

# match the os
os == linux
```

## Integration

Conditions are being parsed using [this library](https://github.com/travis-ci/travis-conditions/pull/1)
by the component that accepts your build request, and generates your build,
stages, and jobs.

The following known attributes are available:

* `type` (the current event type, known event types are: `push`, `pull_request`, `api`, `cron`)
* `repo` (the current repository slug `owner_name/name`)
* `branch` (the current branch name; for pull requests: the base branch name)
* `tag` (the current tag name)
* `commit_message` (the current commit message)
* `sender` (the event sender's login name)
* `fork` (`true` or `false` depending if the repository is a fork)
* `head_repo` (for pull requests: the head repository slug `owner_name/name`)
* `head_branch` (for pull requests: the head repository branch name)
* `os` (the operating system)
* `language` (the build language)
* `sudo` (sudo access)
* `dist` (the distribution)
* `group` (the image group)

Also, environment variables from your build configuration (`.travis.yml`) and
repository settings are available, and can be matched using `env(FOO)`, see
below.

Note that this means conditions do not have access to the build environment,
and they are *not* evaluted in Bash. Bash variables or subprocesses can *not*
be evaluated.

Variable names and unquoted strings starting with a dollar char `$` raise a
parse error, causing the build request to be rejected. Quoted strings still can
start with a dollar char, so if you definitely need a string to start with a
dollar char you can enclose it in quotes.

## Specification

The following expressions are parsed and evaluated as expected:

```
# individual terms
true
false

# compare values
1 = 1
true != false

# compare function calls
env(FOO) = env(BAR)

# compare function calls to attributes
env(FOO) = type

# nested function calls
env(env(FOO))

# function calls in lists
repo IN (env(ONE), env(OTHER))

# parenthesis
(tag =~ ^v) AND (branch = master)
```

All keywords (such as `AND`, `OR`, `NOT`, `IN`, `IS`, attribute and functions
names) are case-insensitive.

The only functions currently is:

```
# (the value of the environment variable `FOO`)
env(FOO)
```

The function `env` currently supports environment variables that are given in
your build configuration (e.g. on `env` or `env.global`), and environment
variables specified in your repository settings.  Note that there is no
function `env.global` or similar. Instead all environment variables are
available through `env`.

### Values

Values are strings that are given without quotes, not containing any whitespace
or special characters, or single or double quoted strings:

```
"a word"
'a word'
a_word
```

### Equality and inequality

This matches a string literally:

```
branch = master
sender != "my bot"
env(foo) = bar
"bar" = env("foo")
```

### Regular expressions

This matches a string using a regular expression:

```
# for simple expressions, not ending in a closing parenthesis:
branch =~ ^master$
env(foo) =~ ^bar$

# if an expression needs to include whitespace, or end in a parenthesis wrap it with slashes:
branch =~ /(master|foo)/
```

Usually parenthesis are not required (e.g. the above list of alternatives could
also be written as just `master|foo`). If you do need to end a regular
expression with a parenthesis, or if it contains whitespace, then the whole
expression needs to be wrapped in `/` slashes.

### Lists

This matches against a list (array) of values:

```
branch IN (master, dev)
env(foo) IN (bar, baz)
```

Note that commas are required to separate values.

Values that include whitespace or special characters should be quoted:

```
env(foo) IN ("bar baz", "buz bum")
```

The operator `IN` can be negated as follows:

```
# these are the same
NOT branch IN (master, dev)
branch NOT IN (master, dev)
```

### Predicates

Known predicates are:

```
present
blank
true
false
```

This requires a value to be present or missing:

```
branch IS present
branch IS blank
env(foo) IS present
env(foo) IS blank
```

The operator `IS` can be negated as follows:

```
# these are all the same
env(foo) IS NOT present
NOT env(foo) IS present
env(foo) IS blank
```

Note that the operator `IS` is intended to work with the well known predicates
`present` and `blank`. It is not the same as `=`, and expressions like the
following do *not* work:

```
# this does not work
branch IS "master"

# instead use =
branch = "master"
```

However, `IS` can also be used to match against the boolean values `true` and
`false` (this has been included after we found many users to expect this to
work):

```
branch IS true
branch = true # this is the same
```

### Aliases

The following aliases are in place:

* `!` is an alias to `NOT`
* `&&` is an alias to `AND`
* `||` is an alias to `OR`
* `==` is an alias to `=`
* `~=` is an alias to `=~`

### Line continuation (multiline conditions):

We were surprised to see users to expect line continuation using `\` to work,
as it does, for example, in Ruby or Python. We liked the idea, so we allowed
the following:

```
if: env(PRIOR_VERSION) IS present AND \
    env(PRIOR_VERSION) != env(RELEASE_VERSION) AND \
    branch = master AND \
    type = push
```

Using YAML multiline strings:

```
if: |
  env(PRIOR_VERSION) IS present AND \
  env(PRIOR_VERSION) != env(RELEASE_VERSION) AND \
  branch = master AND \
  type = push
```
