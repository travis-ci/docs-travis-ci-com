---
title: Travis Pro
layout: en
permalink: travis-pro/
---

## Travis Pro Frequently Asked Questions

<div id="toc"></div>

Note: These issues are related to [Travis Pro](http://travis-ci.com), our hosted
continuous integration solution for private repositories.

### How can I get support?

You can email us directly at <support@travis-ci.org>, you can use the little
feedback button on the right side when you're on Travis Pro (see screenshot
below, the ❤ is for support), or you can hop on our [Campfire chat
room](https://travisci.campfirenow.com/10e50) (we always have fresh coffee ready
for you!)

![The ❤ is for
support!](http://s3itch.paperplanes.de/Travis_CI_Pro_-_Hosted_CI_that_just_works-20120809-125329.png)

### How can I configure Travis Pro to use private GitHub repositories as dependencies?

By default Travis focuses its build efforts around a single repository. We set
up a private deploy key for every repository that's enabled to build on Travis
Pro and assign that to the repository. That means we can't simply pull in
dependent repositories, e.g. from your Gemfile or for your Composer setup. The
key can only be assigned to the single repository and not be reused throughout
all of GitHub.

If you need to pull in Git submodules or dependent repositories, that's still
easy to achieve, though. You can either specify the dependencies using GitHub's
https URL scheme, which can include username and password, e.g.
`https://user:password@github.com/organization/repo.git`. Ideally the user is a
separate user in your organization that only has read access to the required
repository.

As this doesn't work in all cases, e.g. with Composer, there's an alternative.
It still requires setting up a separate user with pull access to the relevant
repositories. But instead of specifying the username and passwords in for
instance your Gemfile, you add an SSH key specifically for this user and put
that key into your .travis.yml. Here are the steps to take:

* Create a new user on GitHub and add it to your organization, give it pull permission to the
  relevant repositories.
* Create an SSH key for the user: `ssh-keygen -f id_mustache_power`.
  Note: this must be a password-less key for Travis CI to be able to use it.
* Add the SSH key to the user on GitHub.
* Add a Base64-encoded version of the private key to your .travis.yml. On the
  Mac, you can run `base64 id_mustache_power | pbcopy` to copy the encoded
  version of the key to the clipboard.
* Add a new key to your main repositories' .travis.yml file: `source_key: `. The
  value of the key should be the encoded version of the SSH key in double
  quotes and on a single line.

Travis will automatically prefer the key specified in your .travis.yml over the
deploy key for a repository, so all repositories you're pulling in for the build
to succeed automatically use this key.

__Note__: This only works on [Travis Pro](http://travis-ci.com), the open source
version of [Travis CI](http://travis-ci.org) doesn't support private
repositories.

##### Technicalities

These steps are necessary due to the way Git and the underlying transport SSH
authenticate with a remote service. For example, when you specify more than one 
key that you want SSH to use, it will still use the first one that authenticates
successfully. After authentication, GitHub checks if this key is authorized to
access the repository requested. Given that you rely on SSH to use the second
key you have configured (e.g. by adding it to an ssh-agent), it will fail
because it will try the first one every time, successfully authenticate, but
fail to authorize access, failing the entire git clone operation.

### Can I use pull request testing on Travis Pro?

Yes, you can. It's enabled by default for all repositories set up on Travis. See
the [blog
post](http://about.travis-ci.org/blog/announcing-pull-request-support/)
accompanying the launch of pull requests for Travis.

### How can I encrypt files that include sensitive data?

Some customers have files in their repositories that contain sensitive data,
like passwords or API credentials, all of which are important for your build to
succeed. But it's data you don't want to give everyone access to. You still want
to be able to give the source code to folks on your team without giving them
access to this kind of data.

While we're working on a solution that allows you to encrypt sensitive data as
environment variables, there's a simple trick you can deploy on Travis Pro in
the meantime. [Luke Patterson](https://twitter.com/lukewpatterson) came up with
this little trick, thanks for sharing it!

It utilizes the private key we generate for each repository so we can clone the
code on our build machines. That key is kept on Travis' end only, so no external
party has access to it. What you do have access to is the public key on GitHub.
You can download that public key and make it part of your project to keep
it around. Due to the nature of asymmetric key cryptography, though, the file
needs to be encrypted with a symmetric key (e.g. using AES 256), and then the
secret used to encrypt that file is encrypted using the public key.

After data is encrypted locally you can store the files in Git and run a set of
commands to decrypt it on the continuous integration machine, using the SSH
private key that we already store on the machine.

Below are the steps required to encrypt and decrypt data.

* Download the key from GitHub and store it in a file. E.g. `id_travis.pub`.
  Unfortunately, you can't get the public key from the user interface, but you
  can fetch it via the API:
  `curl -u <username> https://api.github.com/repos/<username>/<repo>/keys`
  Look for a key named travis-ci.com in the JSON output and copy the string that
  contains the public key into a file `id_travis.pub`. Here's a handy one-liner
  that does it for you:
  `curl -u <username> https://api.github.com/repos/<username>/<repo>/keys | grep -B 4 travis-ci\\.com | grep '"key":' | perl -pe 's/^[ ]+"key": //; s/^"//; s/",$//' > id_travis.pub`
* Extract a public key certificate from the public key:
  `ssh-keygen -e -m PKCS8 -f id_travis.pub > id_travis.pub.pem`
* Encrypt a file using a passphrase generated from a SHA hash of /dev/urandom
output:

      password=`cat /dev/urandom | head -c 10000 | openssl sha1`
      openssl aes-256-cbc -k "$password" -in config.xml -out config.xml.enc -a

* Now you can encrypt the key, let's call it `secret`:
  `echo "$password" | openssl rsautl -encrypt -pubin -inkey id_travis.pub.pem -out secret`
* Add the encrypted file and the secret to your Git repository.
* For the build to decrypt the file, add a `before_script` section to your
  `.travis.yml` that runs the opposite command of the above:

      before_script:
        - secret=`openssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in secret`
        - openssl aes-256-cbc -k "$secret" -in config.xml.enc -d -a -out config.xml

It must be noted that this scenario is still not perfectly secure. While it
prevents project collaborators being able to access sensitive data on a
daily basis, a malicious collaborator could tamper with the
build scripts to output the sensitive data to your build log. The upshot is that
you'll know who's responsible for this from the commit history.

### Combine Encryption and Deploy Keys For Private Dependencies for Extra Strength

You can combine the encryption outlined above with build dependencies that are
private GitHub repositories. The approach outlined above, putting the deploy key
into your `.travis.yml` might not be a favorable solution for everyone.

What you can do instead is generate a custom deploy key using `ssh-keygen`,
assign it to a user, and then encrypt the private key using the encryption
scheme outlined above. Instead of encrypting a config.xml, you encrypt a
`id_private` key and store it in your repository together with the secret.

Then you replace the SSH key currently registered with the SSH agent running on
the virtual machine with this new key in your .travis.yml. Below are the
additional steps that need to be added to a `before_install` or `before_script`
step:

    before_install:
      - secret=`openssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in secret`
      - openssl aes-256-cbc -k $secret -in id_private.enc -d -a -out id_private
      - ssh-add -D
      - chmod 600 id_private
      - ssh-add ./id_private

This way, the deploy key is never exposed to parties you don't want it exposed
to. The same note as with the encryption scheme applies here too: when a
malicious party tampers with your build script, the key could still be exposed.

It also must be noted that subsequent accesses to the original processes, should
they be required by your build, won't be possible without assigning the
secondary deploy key to the original repository as well.
