---
title: TestFairy Deployment
layout: en
deploy: v2
provider: testfairy
---

Travis CI can automatically deploy your Android and iOS Apps to [TestFairy](https://www.testfairy.com/).

{% include deploy/providers/testfairy.md %}

You can find your API key on [TestFairy settings page](https://app.testfairy.com/settings/).

## Symbols file

Attach your symbols mapping file so TestFairy can de-obfuscate and symbolicate
crash reports automatically. Set the `symbols-file` key to your
`proguard_mapping.txt` file or to a zipped `.dSYM` file.

```yaml
deploy:
  provider: testfairy
  # ⋮
  symbols_file: Path to the symbols file
```
{: data-file=".travis.yml"}

## Invite testers automatically

To automatically invite testers upon build upload, specify a comma-separated
list of groups in the `testers-groups` key. Set the `notify` key to `true` if
you want to notify them via email:

```yaml
deploy:
  provider: testfairy
  # ⋮
  notify: true
  testers_groups: qa-stuff,friends
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
