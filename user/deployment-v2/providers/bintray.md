---
title: Bintray Deployment
layout: en
deploy: v2
provider: bintray
---

Travis CI can automatically upload build artifacts to [Bintray](https://bintray.com/)
after a successful build.

{% include deploy/providers/bintray.md %}

## Descriptor file

The descriptor is in JSON file format in three sections:

```js
{
  "package": {
    "name": "auto-upload",
    "repo": "myRepo",
    "subject": "myBintrayUser",
    "desc": "I was pushed completely automatically",
    "website_url": "www.jfrog.com",
    "issue_tracker_url": "https://github.com/bintray/bintray-client-java/issues",
    "vcs_url": "https://github.com/bintray/bintray-client-java.git",
    "github_use_tag_release_notes": true,
    "github_release_notes_file": "RELEASE.txt",
    "licenses": ["MIT"],
    "labels": ["cool", "awesome", "gorilla"],
    "public_download_numbers": false,
    "public_stats": false,
    "attributes": [
       { "name": "att1", "values" : ["val1"], "type": "string" },
       { "name": "att2", "values" : [1, 2.2, 4], "type": "number" },
       { "name": "att5", "values" : ["2014-12-28T19:43:37+0100"], "type": "date" }
    ]
  },
  "version": {
      "name": "0.5",
      "desc": "This is a version",
      "released": "2015-01-04",
      "vcs_tag": "0.5",
      "attributes": [
         { "name": "VerAtt1", "values" : ["VerVal1"], "type": "string" },
         { "name": "VerAtt2", "values" : [1, 3.3, 5], "type": "number" },
         { "name": "VerAtt3", "values" : ["2015-01-01T19:43:37+0100"], "type": "date" }
      ],
      "gpgSign": false
  },
  "files": [
    {
      "includePattern": "build/bin(.*)*/(.*\\.gem)",
      "excludePattern": ".*/do-not-deploy/.*",
      "uploadPattern": "gems/$2"
    },
    {
      "includePattern": "build/docs/(.*)",
      "uploadPattern": "docs/$1",
      "listInDownloads": true
    }
  ],
  "publish": true
}
```

### Package Section

Bintray package information. The following information is mandatory on open source projects:

- `name` is the Bintray package name
- `repo` is the Bintray repository name
- `subject` is the Bintray subject, which is either a user or an organization
- `vcs_url` is the Bintray version control system url, such as a github repository url
- `licenses` is the [Bintray licences](https://bintray.com/docs/api/#_licenses){: data-proofer-ignore=""}, which is a list with at least one item.

### Version Section

Package version information. In case the version already exists on Bintray, only the name field is mandatory.

### Files Section

Configure the files you would like to upload to Bintray and their upload path.

You can define one or more groups of patterns. Each group contains three patterns:

* `includePattern`: Pattern in the form of Ruby regular expression, indicating
  the path of files to be uploaded to Bintray. If files are in your root
  directory, indicate a relative path : `\./`
* `excludePattern`: Optional. Pattern in the form of Ruby regular expression,
  indicating the path of files to be removed from the list of files specified
  by the includePattern.
* `uploadPattern`: Upload path on Bintray. The path can contain symbols in the
  form of $1, $2,... that are replaced with capturing groups defined in the
  include pattern.

If `listInDownloads` is set to `true` matching artifacts will appear in the
"Download list" or "Direct downloads". This can be done only on published
versions, so `publish` should be set to `true`.

In the example above, the following files are uploaded:

* All gem files located under `build/bin/` (including sub directories), except
  for files under a `do-not-deploy` directory. The files will be uploaded to
  Bintray under the `gems` folder.
* All files under `build/docs`. The files will be uploaded to Bintray under the
  `docs` folder, and will appear in the downloads list of the project overview.

> Regular expressions defined as part of the `includePattern` and
`excludePattern` properties must be wrapped with brackets.

### Debian Upload

When artifacts are uploaded to a Debian repository on Bintray using the
Automatic index layout, the Debian distribution information is required and
must be specified. The information is specified in the descriptor file by the
matrixParams as part of the files closure as shown in the following example:

`uploadPattern` should respect [bintray automatic layout scheme](https://blog.bintray.com/category/packages-metadata/).

```js
"files": [
  {
    "includePattern": "build/bin/(.*\.deb)",
    "uploadPattern": "pool/main/m/mypackage/$1",
    "matrixParams": {
      "deb_distribution": "vivid",
      "deb_component": "main",
      "deb_architecture": "amd64"
    }
  }
]
```

### Overwriting Existing Files

If an artifact by a given name already exists in the Bintray repository, then
by default it is not overwritten. If you want to replace the existing file,
define the `override` key in your matrix properties:

```js
"files": [
  {
    "includePattern": "build/bin/(myfile.bin)",
    "uploadPattern": "$1",
    "matrixParams": {
        "override": 1
    }
  }
]
```

{% include deploy/shared.md %}
