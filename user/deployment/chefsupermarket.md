---
title: Chef Supermarket deployment
layout: en

---

Travis CI can automatically deploy your cookbook to [Chef
Supermarket](https://supermarket.chef.io/) after a successful build.

To deploy to Chef Supermarket add your Chef Supermarket `user_id`, your
[encrypted](/user/encrypting-files) Chef Supermarket client key and the
[`cookbook_category`](https://docs.getchef.com/knife_cookbook_site.html#id12) to
your `.travis.yml`:

```yaml
deploy:
  provider: chef-supermarket
  user_id: "<your chef username>
  # the encrypted client key file is decrypted in the before_install stage of the build when you add it using the instructions above
  cookbook_category: "Others"
```
{: data-file=".travis.yml"}
