---
title: TestFairy deployment
layout: en

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

## Android

To deploy your Android application (`app-file`), add your keystore certificate file (`keystore-file`), password for the keystore (`storepass`)  and entity to be identified with the app (`alias`) to your `.travis.yml`:

```yaml
deploy:
  provider: testfairy
  api-key: "TESTFAIRY API KEY"
  app-file: Path to the app file (APK/IPA)
  keystore-file: Path to your keystore-file
  storepass: keystore-pass
  alias: entity-alias
```
{: data-file=".travis.yml"}

Always [encrypt](/user/encrypting-files/) your keystore file.

## Symbols file

Attach your symbols mapping file so TestFairy can de-obfuscate and symbolicate crash reports automatically. Set the `symbols-file` key to your `proguard_mapping.txt` file or to a zipped `.dSYM` file.

```yaml
deploy:
  provider: testfairy
  api-key: "TESTFAIRY API KEY"
  app-file: Path to the app file (APK/IPA)
  keystore-file: Path to your keystore-file
  storepass: keystore-pass
  alias: entity-alias
  symbols-file: Path to the symbols file
```
{: data-file=".travis.yml"}

## Invite testers automatically

To automatically invite testers upon build upload, specify a comma-seperated list of groups in the `testers-groups` key. Set the `notify` key to `true` if you want to notify them via email:

```yaml
deploy:
  provider: testfairy
  api-key: "TESTFAIRY API KEY"
  app-file: Path to the app file (APK/IPA)
  keystore-file: Path to your keystore-file
  storepass: keystore-pass
  alias: entity-alias
  notify: false
  testers-groups: qa-stuff,friends
```
{: data-file=".travis.yml"}

## More Options

- **auto-update**: Upgrade previous installations to this version automatically.
- **max-duration**: Maximum session recording length, eg "60m". Default is "10m".
- **data-only-wifi**: Record video and metrics only when connected to wifi network.
- **video**: If true, Video recording settings "true", "false". Default is "true".
- **video-quality**: Video quality settings, "high", "medium" or "low". Default is "high".
- **screenshot-interval**: Seconds between video frames. Default "1" seconds.
- **record-on-background**: If true, data will be collected while the app on background.
- **icon-watermark**: Add a small watermark to app icon. Default is "false".
- **metrics**: Comma-separated list of metrics to record. View list on [TestFairy Docs](https://docs.testfairy.com/API/Upload_API.html).
- **advanced-options**: Additional settings (eg shake,anonymous).

For example:

```yaml
deploy:
  provider: testfairy
  api-key: "TESTFAIRY API KEY"
  app-file: bin/MainActivity_release.apk
  symbols-file: bin/proguard_mapping.txt
  keystore-file: /root/app.keystore
  storepass: swordfish
  alias: android
  testers-groups: qa-stuff,friends
  auto-update: true
  screenshot-interval: 2
  video: true
  video-quality: high
  icon-watermark: true
  data-only-wifi: true
  metrics: cpu,memory,network,phone-signal,logcat,gps,battery
  advanced-options: shake,anonymous
```
{: data-file=".travis.yml"}
