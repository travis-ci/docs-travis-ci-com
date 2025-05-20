# Travis CI Documentation Style Guide

## Markdown and Structure

We're planning to lint the Markdown with [Coala.io][coala] and the [MarkdownBear][bear].

We'll be using a subset (TBD) of the full [list of checks][checks].

[coala]: http://coala.io/ "Coala CI"

[bear]: https://github.com/coala/bear-docs/blob/master/docs/MarkdownBear.rst "MarkdownBear"

[checks]: https://github.com/coala/bear-docs/blob/master/docs/MarkdownBear.rst#settings "MarkdownBear checks"

We use Kramdown, with [GFM](https://guides.github.com/features/mastering-markdown/#GitHub-flavored-markdown) code blocks, and a few Kramdown-related exceptions introduced with `{: }` such as class names for specific formatting of columns and notes.

## Headings

For historical reasons, the top-level heading in Jekyll's markdown files is level 2 (##), not level 1 (#). Only the page’s title is a level 1 heading. 

We use ATX-style headings and do not use the optional closing hashes:

```markdown
## This is an H2

### This is an H3

#### This is an H4
```

We do not use underlined style headings:

```markdown
Do not use this style heading
=============================
```

## Lists

If you have long lists, you can wrap them into 2 (`.column-2`) or 3 (`.column-3`) columns using one of the following CSS classes after your list item:

```css
* long list item 1
* long list item 2
{: .column-2 }
```

## Links

Make sure all links have titles:

```markdown
The [link][example1] in the text

[example1]: http://www.example.com  "Example URL"
```

or

```markdown
The [link](http://www.example.com "Example URL") in the text
```

When linking internal pages, use absolute paths and trailing slashes: `/user/languages/c/`.
You can link to headings and remember to remove special characters, for example:

To link to "##Node.js Page," use `#nodejs-page`.


## In-page Options

### Notes, warnings, and blocks

Travis CI uses the blockquote symbol `>` for general-purpose notes and warnings.

See an example below:

> Note: This feature is only available in Version 2.0.

### Beta features

Mark all beta features with a specially formatted note. Both the `> BETA` and
the `{: .beta}` are required.

See an example below:

> BETA Awesome new feature that might not be enabled and is subject to change.
{: .beta}

#### Alpha features

Mark all alpha features with a specially formatted note. Both the `> ALPHA` and
the `{: alpha}` are required.

> ALPHA: Awesome new feature that might explode for extra fun.
{: .alpha}

### GUI

Ensure all references to items in a GUI match the case of the UI and are marked with *asterisks*.


### Code Inline

All function names, filenames, etc., should be marked with `back-ticks`.

If you're talking about applications or services, only the actual command should be marked as code, not the name of the service:

- Start the PostgreSQL database by running `psql`.

### Blockquotes / Notes / Warnings

As we have no use for blockquotes, we use `>` to indicate notes and warnings:

```markdown
> Note this important info!

```

### Code blocks

Code blocks should be fenced with triple back-ticks "\`\`\`" and named according to [prism.js][prism] for syntax highlighting.

[prism]: http://prismjs.com/#languages-list "Prism language list"

```markdown
your code here
```

You can also set the filename for a code block by adding a Kramdown attribute after it:

```markdown
This code is in .travis.yml
```
{: data-file=".travis.yml"}

### In-page table of contents

All Travis CI pages have tables of contents generated automatically from H2 and H3

Add `no_toc: true` to the frontmatter to remove the TOC from a page.

### Terminology
The following are some common misspellings and words to avoid

- Always refer to *Travis CI* and never to Travis.

## Images

Add images inline-style with a brief description.

To add an image, follow these steps:
1 Capture the image.
2 Save the image in the  `images/` path.
3 Add the image to the documentation as follows:
![description text](image path or URL) 

### Screencapture gifs

1. Run a build (or whatever you are trying to capture),
2. Capture it with [licecap](https://www.cockos.com/licecap/).
3. Save the gif in the following path:  `images/`  


## Documentation Template

A basic template for contributing to new documentation pages or sections is as follows: 

```markdown
---
title: “Insert Page Title”
layout: en

---

Start your introduction here. Usually, an introduction is between one and three sentences. 

## Section Heading 

Section introduction sentence. 

* **Item1** - a group of *jobs* that run in sequence. 
* **Item2** - a group of *jobs* that run in parallel as part of a sequential *build* process composed of multiple [stages](/user/build-stages/).
* **Item3** - an automated process that clones your repository into a virtual
  environment and then carries out a series of *phases* such as compiling your
  code, running tests, etc. 
* **Item4** - the [sequential steps](/user/job-lifecycle/)
  of a *job*. 

```
{: data-file=".travis.yml"}

The example above shows a paragraph with different formatting options. 

Check out the [Travis CI documentation](https://docs.travis-ci.com/) for more examples.
