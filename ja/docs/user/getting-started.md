---
title: はじめに
layout: ja
permalink: getting-started/
---

### Travis CIの概要

Travis CIはオープンソースコミュニティの為のホスティング型の継続的インテグレーションサービスです。 GitHubと連携し下記の言語をスムーズにサポートします。

* [C](/docs/user/languages/c)
* [C++](/docs/user/languages/cpp)
* [Clojure](/docs/user/languages/clojure)
* [Erlang](/docs/user/languages/erlang)
* [Go](/docs/user/languages/go)
* [Groovy](/docs/user/languages/groovy)
* [Haskell](/docs/user/languages/haskell)
* [Java](/docs/user/languages/java)
* [JavaScript (with Node.js)](/docs/user/languages/javascript-with-nodejs)
* [Objective-C](/docs/user/languages/objective-c)
* [Perl](/docs/user/languages/perl)
* [PHP](/docs/user/languages/php)
* [Python](/docs/user/languages/python)
* [Ruby](/docs/user/languages/ruby)
* [Scala](/docs/user/languages/scala)

我々のCI環境は複数のランタイムを提供します(例. Node.jsやさまざまなバージョンのPHP)、データストアも同様です。つまりあなたのプロジェクトを travis-ci.org 上でホスティングする事であなたのライブラリやプロジェクトを複数のランタイムやデータストアをローカル環境にインストールせずに、効率的にテストできます。

travis-ci.org 2011年の初めにRubyの為のサービスとしてスタートしました。そしてその後、さまざまなテクノロジのサポートが追加されました。

無料のコミュニティサービスではTravis CIはビルドの長さを約20分に制限しています。特に大きなコードベースはビルドに非常に長い時間かかる事がある為です。適切な長さの時間でワーカーを使うように注意を払ってください。

### Step one: サインイン

Travis CIを始めるにはGitHub OAuthを通じてサインインします。[Travis CI](http://travis-ci.org)にアクセスし画面上部のサインインリンクをクリックしてください。

GitHubはあなたに読み込みと書き込みの権限を要求します。Travis CIはあなたのリポジトリにサービスフックを設定する際に書き込みアクセスを必要とします。それ以外では何もしません

### Step two: GitHubサービスフックの有効化

サインイン出来たらあなたの[プロフィールページ](https://travis-ci.org/profile)にアクセスします。あなたのリポジトリのリストが表示され、それぞれのリポジトリのオン・オフスイッチを切り替えてTravis CIを有効にします。次にGitHubのプロジェクトのサービスフックページにアクセスし、GitHubのユーザ名とTravisトークンがフィルインされていなければペーストしてください。

リポジトリが組織に所属している場合、切り替えスイッチはフックを設定しません。GitHubでの[手動設定方法](/docs/user/how-to-setup-and-trigger-the-hook-manually/)をご覧ください。設定には数分しかかかりません。

###  Step three: .travis.ymlファイルをあなたのリポジトリへの追加

あなたのプロジェクトをTravisでビルドするには、システムにそれを通知する必要があります。.travis.ymlをあなたリポジトリのルートに追加してください。このガイドでは.travis.ymlの基本的なオプションのみを解説します。最も重要な事は **language** キーの設定です。このキーはTravisがどのビルダを使うかを指定します。通常のRubyプロジェクトはClojureやPHPとは違うビルドツールを使うので、Travisは何をすべきかを知る必要があります。

`.travis.yml`がリポジトリに存在しない場合や、スペルミスしていたり、有効なYAMLファイルでない場合、travis-ci.orgはそれを無視して言語をRubyであるとみなします。

基本的な **.travis.yml** の例は次の通りです。:


#### C

    language: c
    compiler:
      - gcc
      - clang
    # Change this to your needs
    script: ./configure && make

Learn more about [.travis.yml options for C projects](/docs/user/languages/c/)


#### C++

    language: cpp
    compiler:
      - gcc
      - clang
    # Change this to your needs
    script: ./configure && make

Learn more about [.travis.yml options for C++ projects](/docs/user/languages/cpp/)


#### Clojure

For projects using Leiningen 1:

    language: clojure
    jdk:
      - oraclejdk7
      - openjdk7
      - openjdk6

For projects using Leiningen 2:

    language: clojure
    lein: lein2
    jdk:
      - openjdk7
      - openjdk6


Learn more about [.travis.yml options for Clojure projects](/docs/user/languages/clojure/)

#### Erlang

    language: erlang
    otp_release:
      - R15B02
      - R15B01
      - R14B04
      - R14B03

Learn more about [.travis.yml options for Erlang projects](/docs/user/languages/erlang/)


#### Haskell

    language: haskell

Learn more about [.travis.yml options for Haskell projects](/docs/user/languages/haskell/)


#### Go

    language: go

Learn more about [.travis.yml options for Go projects](/docs/user/languages/go/)



#### Groovy

    language: groovy
    jdk:
      - oraclejdk7
      - openjdk7
      - openjdk6


Learn more about [.travis.yml options for Groovy projects](/docs/user/languages/groovy/)

#### Java

    language: java
    jdk:
      - oraclejdk7
      - openjdk7
      - openjdk6


Learn more about [.travis.yml options for Java projects](/docs/user/languages/java/)

#### Node.js

     language: node_js
     node_js:
       - "0.10"
       - "0.8"
       - "0.6"

Learn more about [.travis.yml options for Node.js projects](/docs/user/languages/javascript-with-nodejs/)

#### Objective-C

     language: objective-c

Learn more about [.travis.yml options for Objective-C projects](/docs/user/languages/objective-c/)

#### Perl

    language: perl
    perl:
      - "5.16"
      - "5.14"
      - "5.12"

Learn more about [.travis.yml options for Perl projects](/docs/user/languages/perl/)

#### PHP

    language: php
    php:
      - "5.5"
      - "5.4"
      - "5.3"

Learn more about [.travis.yml options for PHP projects](/docs/user/languages/php/)

#### Python

    language: python
    python:
      - "3.3"
      - "2.7"
      - "2.6"
    # command to install dependencies, e.g. pip install -r requirements.txt --use-mirrors
    install: PLEASE CHANGE ME
    # command to run tests, e.g. python setup.py test
    script:  PLEASE CHANGE ME

Learn more about [.travis.yml options for Python projects](/docs/user/languages/python/)

#### Ruby

    language: ruby
    rvm:
      - "1.8.7"
      - "1.9.2"
      - "1.9.3"
      - jruby-18mode # JRuby in 1.8 mode
      - jruby-19mode # JRuby in 1.9 mode
      - rbx-18mode
      - rbx-19mode
    # uncomment this line if your project needs to run something other than `rake`:
    # script: bundle exec rspec spec

Learn more about [.travis.yml options for Ruby projects](/docs/user/languages/ruby/)

#### Scala

     language: scala
     scala:
       - "2.9.2"
       - "2.8.2"
     jdk:
       - oraclejdk7
       - openjdk7
       - openjdk6


Learn more about [.travis.yml options for Scala projects](/docs/user/languages/scala/)

#### あなたの.travis.ymlの検証


[travis-lint](http://github.com/travis-ci/travis-lint) (command-line tool) か [.travis.yml validation Web app](http://lint.travis-ci.org) を使ってあなたの`.travis.yml`ファイルを検証することを推奨します。

`travis-lint` はRuby 1.8.7+とRubyGemsが必要です。次のように導入します。

    gem install travis-lint

そしてあなたの`.travis.yml`に対して実行します。:

    # .travis.ymlのあるリポジトリ内
    travis-lint

    # その他のディレクトリから
    travis-lint [path to your .travis.yml]

`travis-lint`次のような事を調べます。

* `.travis.yml`ファイルが[有効なYAML](http://yaml-online-parser.appspot.com/)であること。
* `language`キーが存在すること。
* [Travis CI Environment](/docs/user/ci-environment/)が対応するランタイムのバージョンが(Ruby, PHP, OTP, etc) 指定されていること。
*　非推奨の機能やランタイムを使っていないこと。

いずれにせよ`travis-lint`はあなたの味方です。ぜひ使ってください。

### Step four: Git Pushで最初のビルドをトリガーする

GitHubフックが設定し、.travis.ymlを追加するコミットをリポジトリにプッシュしてください。これによりビルドが[Travis CI](http://travis-ci.org)上のキューに追加され、あなたのビルドはあなたの言語のワーカーが利用可能になり次第、開始されます、

ビルドを開始するにはリポジトリにコミットをプッシュするか、GitHubのサービスフックページの”Test Hook"ボタンを利用できます。しかし最初のビルドはTest Hookボタンでトリガーできない事に注意してください。最初のビルドはリポジトリへのプッシュでしかトリガーできません、

### Step five: ビルド設定の調整

あなたプロジェクトがビルド方法をカスタマイズする必要がある場合には機会があります。Travisが使うデフォルトとは異なるビルドツールを使ったり、テスト実行の前にデータベースを作成したい場合などがあるでしょうが心配は無用です。Travisはほとんどどんな事でもオーバーライドできます。詳しくは[Build Configuration](/docs/user/build-configuration/)を見てください。

`.travis.yml`に変更を加えた後は、[有効なYAML](http://yaml-online-parser.appspot.com/)であるかを`travis-lint`で検査するのを忘れないでください。

### Step six: さらに詳しく

Travisワーカーはあなたが必要な様々なサービスが使えます。 MySQL, PostgreSQL, MongoDB, Redis, CouchDB, RabbitMQ, memcached などです。

データベースを設定するには、[Database setup](/docs/user/database-setup/)を見てください。さらに詳しいテスト環境の情報は[in a separate guide](/docs/user/ci-environment/)にあります。

### Step seven: 助けが必要な時は

どんな質問がある場合でも、IRC channel [#travis on chat.freenode.net](irc://chat.freenode.net/%23travis)にお越しください。私たちはあなたを助けます。 :)
