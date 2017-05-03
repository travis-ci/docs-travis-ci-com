---
title: Encrypting Files
layout: en
permalink: /user/encrypting-files/
---

**Please note that encrypted files are not available for [pull requests from forks](/user/pull-requests#Pull-Requests-and-Security-Restrictions).**

<div id="toc"></div>

## Prerequisites

Before following the examples in this guide, make sure you have already

- installed the Travis CI [Command Line Client](https://github.com/travis-ci/travis.rb#readme) by running `$ gem install travis`
- [logged in](https://github.com/travis-ci/travis.rb#login) to Travis CI
  using `$ travis login` or `$ travis login --pro`

See the Command Line Client [installation instructions](https://github.com/travis-ci/travis.rb#installation) for more information on system required versions of Ruby and operating systems.

## Automated Encryption

Assumptions:

- The repository is set up on Travis CI
- You have version **1.7.0** or later of the Travis CI Command Line Client installed and setup up (you are logged in)
- You have a local copy of the repository and a terminal open where your current working directory is said copy
- In the repository is a file, called super_secret.txt, that you need on Travis CI but you don't want to publish its content on GitHub.

The `travis encrypt-file` command will encrypt a file for you using a symmetric encryption (AES-256), and it will store the secret in a secure variable. It will output the command you can use in your build script to decrypt the file.

```bash
$ travis encrypt-file super_secret.txt
encrypting super_secret.txt for rkh/travis-encrypt-file-example
storing result as super_secret.txt.enc
storing secure env variables for decryption
```

Please add the following to your build script (before_install stage in your .travis.yml, for instance):

```bash
openssl aes-256-cbc -K $encrypted_0a6446eb3ae3_key -iv $encrypted_0a6446eb3ae3_key -in super_secret.txt.enc -out super_secret.txt -d
```

Pro Tip: You can add it automatically by running with --add.

Make sure to add super_secret.txt.enc to the git repository.
Make sure not to add super_secret.txt to the git repository.
Commit all changes to your .travis.yml.

You can also use `--add` to have it automatically add the decrypt command to your `.travis.yml`

```bash
$ travis encrypt-file super_secret.txt --add
encrypting super_secret.txt for rkh/travis-encrypt-file-example
storing result as super_secret.txt.enc
storing secure env variables for decryption

Make sure to add super_secret.txt.enc to the git repository.
Make sure not to add super_secret.txt to the git repository.
Commit all changes to your .travis.yml.
```

### Encrypting multiple files

The Command Line Client [overrides encrypted entries](https://github.com/travis-ci/travis.rb/issues/239) if you use it to encrypt multiple files.

If you need to encrypt multiple files, first create an archive of sensitive files, then decrypt and expand it during the build.

Suppose we have sensitive files `foo` and `bar`, run the following commands:

```bash
$ tar cvf secrets.tar foo bar
$ travis encrypt-file secrets.tar
$ vi .travis.yml
$ git add secrets.tar.enc .travis.yml
$ git commit -m 'use secret archive'
$ git push
```

And add the decryption step to your `.travis.yml`, adjusting `$*_key` and `$*_iv` according to your needs:

```yaml
before_install:
  - openssl aes-256-cbc -K $encrypted_5880cf525281_key -iv $encrypted_5880cf525281_iv -in secrets.tar.enc -out secrets.tar -d
  - tar xvf secrets.tar
```

### Caveat

There is a report of this function not working on a local Windows machine. Please use a Linux or OS X machine.

## Manual Encryption

Assumptions:

- The repository is set up on Travis CI
- You have the recent version of the Travis CI Command Line Client installed and setup up (you are logged in)
- You have a local copy of the repository and a terminal open where your current working directory is said copy
- In the repository is a file, called super_secret.txt, that you need on Travis CI but you don't want to publish its content on GitHub.

The file might be too large to encrypt it directly via the `travis encrypt` command. However, you can encrypt the file using a passphrase and then encrypt the passphrase. On Travis CI, you can use the passphrase to decrypt the file again.

The set up process looks like this:

1. **Come up with a password.** First, you need a password. We recommend generating a random password using a tool like pwgen or 1password. In our example we will use `ahduQu9ushou0Roh`.
2. **Encrypt the password and add it to your .travis.yml.** Here we can use the `encrypt` command: `travis encrypt super_secret_password=ahduQu9ushou0Roh --add` - note that if you set this up multiple times for multiple files, you will have to use different variable names so the passwords don't override each other.
3. **Encrypt the file locally.** Using a tool that you have installed locally and that is also installed on Travis CI (see below).
4. **Set up decryption command.** You should add the command for decrypting the file to the `before_install` section of your `.travis.yml` (see below).

Be sure to add `super_secret.txt` to your `.gitignore` list, and to commit both the encrypted file and your `.travis.yml` changes.

### Using GPG

Set up:

```bash
$ travis encrypt super_secret_password=ahduQu9ushou0Roh --add
$ gpg -c super_secret.txt
(will prompt you for the password twice, use the same value as for super_secret_password above)
```

Contents of the `.travis.yml` (besides whatever else you might have in there):

```yaml
env:
  global:
    secure: ... encoded secret ...
before_install:
  - echo $super_secret_password | gpg --passphrase-fd 0 super_secret.txt.gpg
```

The encrypted file is called `super_secret.txt.gpg` and has to be committed to the repository.

#### Using OpenSSL

Set up:

```bash
$ travis encrypt super_secret_password=ahduQu9ushou0Roh --add
$ openssl aes-256-cbc -k "ahduQu9ushou0Roh" -in super_secret.txt -out super_secret.txt.enc
(keep in mind to replace the password with the proper value)
```

Contents of the `.travis.yml` (besides whatever else you might have in there):

```yaml
env:
  global:
    secure: ... encoded secret ...
before_install:
  - openssl aes-256-cbc -k "$super_secret_password" -in super_secret.txt.enc -out super_secret.txt -d
```

The encrypted file is called `super_secret.txt.enc` and has to be committed to the repository.
