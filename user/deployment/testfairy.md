---
title: TestFairy deployment
layout: en
permalink: /user/deployment/testfairy/
---

Travis CI can automatically deploy your Android/iOS Apps to [TestFairy](https://www.testfairy.com/).

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

{% highlight yaml %}
deploy:
  provider: testfairy
  api-key: "TESTFAIRY API KEY"
  app-file: Path to the app file (APK/IPA)
{% endhighlight %}

You can find your API key on [TestFairy settings page](https://app.testfairy.com/settings/). 
It is recommended that you encrypt your api-key.
Assuming you have the Travis CI command line client installed, you can run the following command in your report folder:

{% highlight console %}
$ travis encrypt "YOUR API KEY" --add deploy.api-key
{% endhighlight %}

## For Android

You required to specify you keystore certificate.

{% highlight yaml %}
deploy:
  provider: testfairy
  api-key: "TESTFAIRY API KEY"
  app-file: Path to the app file (APK/IPA)
  keystore-file: Path to your keystore-file
  storepass: storepass
  alias: alias
{% endhighlight %}

Use [Travis encrypting files](http://docs.travis-ci.com/user/encrypting-files/) to protect your keystore file.


### Symbols file

Attach your symbols mapping file so TestFairy will de-obfuscate or symbolicate crash reports automatically. Point
*symbols-file* to your *proguard_mapping.txt* file (or similar) or to a zipped *.dSYM file*.

{% highlight yaml %}
deploy:
  provider: testfairy
  ..
  symbols-file: Path to the symbols file
{% endhighlight %}


### Invite testers automatically

Testers can be invited upon build upload. Specify a comma-seperated list of testers groups to invite. Use *notify* to 
send changelog and invitations via email. 

{% highlight yaml %}
deploy:
  provider: testfairy
  ..
  notify: false
  testers-groups: qa-stuff,friends
{% endhighlight %}

### More Options 

* **auto-update**: Upgrade previous installations to this version automatically.
* **max-duration**: Maximum session recording length, eg "60m". Default is "10m".
* **data-only-wifi**: Record video and metrics only when connected to wifi network.
* **video**: If true, Video recording settings "true", "false". Default is "true".
* **video-quality**: Video quality settings, "high", "medium" or "low". Default is "high".
* **screenshot-interval**: Seconds between video frames. Default "1" seconds.
* **record-on-background**: If true, data will be collected while the app on background.
* **icon-watermark**: Add a small watermark to app icon. Default is "false".
* **metrics**: Comma-separated list of metrics to record. View list on [TestFairy Docs](http://docs.testfairy.com/Upload_API.html).
* **advanced-options**: Additional settings (eg shake,anonymous).

For example: 

{% highlight yaml %}
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
{% endhighlight %}