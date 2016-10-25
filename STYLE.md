# Travis CI documentation style guide

## Markdown and structure

We're planning to lint the Markdown with [Coala.io][coala] and the [MarkdownBear][bear].

We'll be using a subset (TBD) of the full [list of checks][checks].

[coala]:  http://coala.io/  "Coala CI"
[bear]:   https://github.com/coala/bear-docs/blob/master/docs/MarkdownBear.rst  "MarkdownBear"
[checks]: https://github.com/coala/bear-docs/blob/master/docs/MarkdownBear.rst#settings "MarkdownBear checks"


### GUI

Make sure all references to items in a GUI matches the case of the UI, and is marked with *asterisks*.

### Links

Make sure all links have titles:

```markdown
The [link][example1] in the text

[example1]: http://www.example.com  "Example URL"
```

or

```markdown
The [link](http://www.example.com "Example URL") in the text

```

### Code Inline

All function names, filenames, etc should be marked with `back-ticks`.

### Code blocks

Code blocks should be fenced with triple back-ticks "\`\`\`" and named according to [prism.js][prism] for syntax highlighting.

````markdown
```markdown
your code here
```
````

[prism]:  http://prismjs.com/#languages-list  "Prism language list"

## Text

### Titles

Should be in normal sentence case

### Common misspellings and words to avoid

* Always refer to *Travis CI* and never to Travis.


## Images
