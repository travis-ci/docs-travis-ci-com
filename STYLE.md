# Travis CI documentation style guide

## Markdown and structure

We're planning to lint the Markdown with [Coala.io][coala] and the [MarkdownBear][bear].

We'll be using a subset (TBD) of the full [list of checks][checks].

[coala]: http://coala.io/ "Coala CI"

[bear]: https://github.com/coala/bear-docs/blob/master/docs/MarkdownBear.rst "MarkdownBear"

[checks]: https://github.com/coala/bear-docs/blob/master/docs/MarkdownBear.rst#settings "MarkdownBear checks"

### Headings

For historical reasons, the top level heading in Jekyll markdown files is level 2 (##) not level 1 (#).

We use ATX style headings, and do not use the optional closing hashes:

```markdown
## This is an H2

### This is an H3

#### This is an H4
```

We do not use underline style headings:

```
Do not use this style heading
=============================
```

### TOC

Add a table of contents to a page with the following HTML snippet:

```html
<div id="toc"></div>
```

### GUI

Make sure all references to items in a GUI match the case of the UI, and are marked with *asterisks*.

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

If you're talking about applications or services, only the actual command should be marked as code, not the name of the service:

- Start the PostgreSQL database by running `psql`.

### Blockquotes / Notes / Warnings

As we have no use for blockquotes we use `>` to indicate notes and warnings:

```markdown
> Note this important info!
```

### Code blocks

Code blocks should be fenced with triple back-ticks "\`\`\`" and named according to [prism.js][prism] for syntax highlighting.

[prism]: http://prismjs.com/#languages-list "Prism language list"

```markdown
your code here
```

### Common misspellings and words to avoid

- Always refer to *Travis CI* and never to Travis.

## Images
