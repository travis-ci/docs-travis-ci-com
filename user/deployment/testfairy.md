---
title: TestFairy deployment
layout: en
deploy: v1

---

Travis CI can automatically deploy your Android and iOS Apps to [TestFairy](https://www.testfairy.com/).

For a minimal configuration, add the following `deploy` key to your `.travis.yml`:

```yaml
deploy:
  provider: testfairy
  api-key: "TESTFAIRY API KEY"
  app-file: Path to the app file (APK/IPA)
```
{: data-file=".travis.yml"}

You can find your API key on [TestFairy settings page](https://app.testfairy.com/settings/).

Always encrypt your api-key. If you have the Travis CI command line client installed, run the following command in your repository directory:

```bash
$ travis encrypt "YOUR API KEY" --add deploy.api-key
```

## Symbols file

Attach your symbols mapping file so TestFairy can de-obfuscate and symbolicate crash reports automatically. Set the `symbols-file` key to your `proguard_mapping.txt` file or to a zipped `.dSYM` file.

```yaml
deploy:
  provider: testfairy
  api-key: "TESTFAIRY API KEY"
  app-file: Path to the app file (APK/IPA)
  symbols-file: Path to the symbols file
```
{: data-file=".travis.yml"}

## Invite testers automatically

To automatically invite testers upon build upload, specify a comma-separated list of groups in the `testers-groups` key. Set the `notify` key to `true` if you want to notify them via email:

```yaml
deploy:
  provider: testfairy
  api-key: "TESTFAIRY API KEY"
  app-file: Path to the app file (APK/IPA)
  notify: false
  testers-groups: qa-stuff,friends
```
{: data-file=".travis.yml"}
