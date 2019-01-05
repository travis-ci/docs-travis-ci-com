---
title: Testing Conditions
layout: en
---

Conditions can be used to filter out, and reject builds, stages, and jobs by
specifying conditions in your build configuration (your `.travis.yml` file).
See [Conditional Builds, Stages, and Jobs](/user/conditional-builds-stages-jobs)
and [Conditions](/user/conditions-v1) for details.

The gem [travis-conditions](https://github.com/travis-ci/travis-conditions) comes
with an executable that can be used to test conditions.

## Installation

```
$ gem install travis-conditions
```

## Usage

```
$ travis-conditions <command>
```

The two commands available are `parse` and `eval`.

### parse

Check the syntax of a condition by inspecting the resulting abstract syntax
tree.

```
$ travis-conditions parse "branch = foo"
[:eq, [:var, :branch], [:val, "foo"]]

```

### eval

Check conditions against a given data hash.

```
$ travis-conditions eval "branch = foo" --data '{"branch": "foo"}'
true

$ echo '{"branch": "foo"}' | travis-conditions eval "branch = foo"
true
```

The given JSON data can include known attributes (such as branch, tag, repo,
see [this page](/user/conditions-v1) for a complete list of attributes) and an
"env" key that can either hold a hash, or an array of strings:

```
{"env": {"foo": "bar"}}
{"env": ["foo=bar"]}
```

For example:

```
$ travis-conditions eval "env(foo) = bar" --data '{"env": {"foo": "bar"}}'
true
$ travis-conditions eval "env(foo) = bar" --data '{"env": ["foo=bar"]}'
true
```
