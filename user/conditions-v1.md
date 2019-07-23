---
title: Conditions
layout: en
---

> This page documents conditions v1 which is now the default version. The
> documentation for v0 can be found [here](/user/conditions-v0).

Conditions can be used to filter out, and reject builds, stages, and jobs by
specifying conditions in your build configuration (your `.travis.yml` file).
See [Conditional Builds, Stages, and Jobs](/user/conditional-builds-stages-jobs)
for details.

Conditions can be tested using the `travis-conditions` command. See
[Testing Conditions](/user/conditions-testing).

## Integration

Conditions are parsed and evaluated using [this library](https://github.com/travis-ci/travis-conditions/),
by the component that accepts your build request, and generates your build,
stages, and jobs.

The following known attributes are available, and can be used in conditions:

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

> Note that this means conditions do not have access to the build environment,
> and they are **not** evaluated in Bash. Bash variables or subprocesses can **not**
> be evaluated. Variable names and unquoted strings starting with a dollar char
> `$` raise a parse error, causing the build request to be rejected. Quoted
> strings still can start with a dollar char, so if you definitely need a string
> to start with a dollar char you can enclose it in quotes.

## Specification

The following expressions are parsed and evaluated.

Individual terms:

```
true
false
```

Comparing values:

```
1 = 1
true != false
```

Comparing function calls to attributes:

```
env(FOO) = type
```

Comparing function calls:

```
env(FOO) = env(BAR)
```

Matching against regular expressions:

```
branch =~ /^(one|two)-three$/
env(FOO) =~ /^(one|two)-three$/
```

Attribute in lists:

```
branch IN (one, other)
```

Function calls in lists:

```
repo IN (env(ONE), env(OTHER))
```

Predicates:

```
tag IS present
tag IS blank
```

Nested function calls:

```
env(env(FOO))
```

Boolean operators:

```
branch = master AND env(FOO) = foo
branch = master OR env(FOO) = foo
branch = master AND env(FOO) = foo OR tag = bar
branch = master AND (env(FOO) = foo OR tag = bar)
NOT branch = master
```

Parenthesis:

```
(tag =~ ^v) AND (branch = master)
((tag =~ ^v) AND (branch = master))
```

All keywords (such as `AND`, `OR`, `NOT`, `IN`, `IS`, attribute and functions
names) are case-insensitive.

### Boolean operators

The following boolean operators are supported:

* `AND`
* `OR`
* `NOT`

`AND` binds stronger than `OR`, and `NOT` binds stronger than `AND`. Therefore
the following expressions are the same:

```
branch = master AND os = linux OR tag = bar
(branch = master AND os = linux) OR tag = bar

NOT branch = master AND os = linux
NOT (branch = master) AND os = linux
```

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
branch =~ ^master$
env(foo) =~ ^bar$
```

If an expression needs to include whitespace, or end in a parenthesis it needs
to be enclosed in forward slashes:

```
branch =~ /(master|foo)/
```

> Usually parenthesis are not required (e.g. the above list of alternatives could
> also be written as just `master|foo`). If you do need to end a regular
> expression with a parenthesis, or if it contains whitespace, then the whole
> expression needs to be enclosed in forward slashes.

### Function calls

There are two function available:

* `env`
* `concat`

The function `env` returns the value of given environment variable:

```
env(FOO)
```

`env` supports environment variables that are set in the `env` key (including
`env.global`) of your `.travis.yml` or specified in your repository settings.

> Note that there is no function `env.global` or similar. Instead all
> environment variables are available through `env`.

The function `concat` accepts any number of arguments and concatenates them
into a single string:

```
concat("foo", "-", env(BAR))
# => "foo-bar"
```

This can also be used in the context of matching a regular expression. For
example with `env: SERVICE=some-service` the following is equivalent to
`branch =~ ^srv-some-service-`:

```
branch =~ concat(^srv-,env(SERVICE),-)
```

### Lists

This matches against a list (array) of values:

```
branch IN (master, dev)
env(foo) IN (bar, baz)
```

> Note that commas are required to separate values.

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
`present` and `blank`. It is **not** the same as `=`, and expressions like the
following do *not* work:

```
# this does not work
branch IS "master"

# instead use =
branch = "master"
```

However, `IS` **can** be used to match against the boolean predicates `true` and
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

## Examples

Build only when on the master branch (note for PRs this is the base branch
name):

```
branch = master
```

Build only when the tag name matches the given regular expression:

```
tag =~ /^(v1|v2)/
```

Build only when the build type is either `push` or `pull_request`:

```
type IN (push, pull_request)
```

Build only when the branch name is not be one of several names:

```
branch NOT IN (master, dev)
```

Build only when the sender login name matches the given name - use quotes for
strings that contain spaces or special characters (the sender is the GitHub user who creates a build):

```
sender = my_account
sender != "deploy bot"
```

Do not build on forks:

```
fork = false
```

Build only when the commit message doesn't match against the given regular expression:

```
commit_message !~ /(no-deploy|wip)/
```

Build only on Linux:

```
os = linux
```
