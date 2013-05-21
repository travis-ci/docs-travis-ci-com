---
title: Démarrer
layout: fr
permalink: getting-started/
---

### Aperçu de Travis CI

Travis CI est un service d'intégration continue pour la communauté open-source. Il est intégré à GitHub et propose un support de première classe pour:

* [Clojure](/fr/docs/user/languages/clojure)
* [Erlang](/fr/docs/user/languages/erlang)
* [Groovy](/fr/docs/user/languages/groovy)
* [Haskell](/fr/docs/user/languages/haskell)
* [Java](/fr/docs/user/languages/java)
* [JavaScript (avec Node.js)](/fr/docs/user/languages/javascript-with-nodejs)
* [Perl](/fr/docs/user/languages/perl)
* [PHP](/fr/docs/user/languages/php)
* [Python](/fr/docs/user/languages/python)
* [Ruby](/fr/docs/user/languages/ruby)
* [Scala](/fr/docs/user/languages/scala)

Notre environnement d'intégration continue offre plusieurs runtimes (par ex. Node.js ou des versions PHP), stockages de données, etc.
Heberger votre projet sur travis-ci.org signifie donc que vous pouvez tester sans effort  votre librairie ou application avec différents environnements d'exécution et stockages de données sans même à avoir à les installer localement. 

travis-ci.org est né début 2011 en tant que service pour la communauté Ruby et a intégré depuis un support pour de nombreuses autres technologies.

### Etape n°1: S'authentifier

Pour commencer à utiliser Travis CI, inscrivez-vous en utilisant GitHub OAuth. Allez sur [Travis CI](http://travis-ci.org) et suivez le lien.

GitHub vous demandera d'accorder les droits de lecture et écriture. Travis CI requière les droits d'écriture pour mettre en place les services hooks pour votre dépôt, mais n'affectera aucune autre partie

### Etape n°2: Activer les service hooks

Une fois authentifié, allez sur votre [profil](http://travis-ci.org/profile). Vous retrouverez la liste de vos dépôt GitHub. Basculez sur "on" les dépôts que vous souhaitez lier à Travis CI. Allez ensuite sur la page service hooks GitHub de ce projet et entrez votre nom d'utilisateur GitHub et votre token Travis dans les paramètres du service Travis si ce n'est pas pré-rempli.

Si votre dépôt appartient à une organisation ou si basculer le bouton n'a pas suffit à mettre en place le hook, [faites le manuellement](/fr/docs/user/how-to-setup-and-trigger-the-hook-manually/) sur GitHub, cela ne prend pas plus que quelques minutes.

### Etape n°3: Intégrer un fichier .travis.yml au dépôt

Pour que Travis puisse compiler votre projet, vous avez besoin de lui expliquer un minimum comment procéder. Pour ce faire, ajouter un fichier .travis.yml à la racine de votre dépot. Dans ce guide nous ne couvrirons que les options les plus basiques. La plus importante est la key **language**. Elle indique à Travis quel builder utiliser : les projets Ruby utilisent en général pour leur build des outils différents que ceux utilisés pour les projets Clojure ou PHP ; Travis doit donc savoir comment il doit procéder.

Si `.travis.yml` n'est pas dans le dépôt, contient une coquille ou n'est pas un [YAML valide](http://yaml-online-parser.appspot.com/), travis-ci.org l'ignorera, utilisera Ruby comme langage et les valeurs par défaut.

Voici des exemples basiques de **.travis.yml** :

#### Clojure

Pour des projets utilisant Leiningen 1:

    language: clojure

Pour des projets utilisant Leiningen 2:

    language: clojure
    lein: lein2

Apprenez-en plus sur les options de [.travis.yml pour les projets Clojure](/fr/docs/user/languages/clojure/)

#### Erlang

    language: erlang
    otp_release:
      - R15B
      - R14B02
      - R14B03
      - R14B04

Apprenez-en plus sur les options de [.travis.yml pour les projets  Erlang](/fr/docs/user/languages/erlang/)


#### Haskell

    language: haskell

Apprenez-en plus sur les options de [.travis.yml pour les projets Haskell](/fr/docs/user/languages/haskell/)


#### Groovy

    language: groovy

Apprenez-en plus sur les options de [.travis.yml pour les projets Groovy](/fr/docs/user/languages/groovy/)

#### Java

    language: java

Apprenez-en plus sur les options de [.travis.yml pour les projets Java](/fr/docs/user/languages/java/)

#### Node.js

     language: node_js
     node_js:
       - 0.4
       - 0.6
       - 0.7 # la version en development 0.8 peut être instable

Apprenez-en plus sur les options de [.travis.yml pour Node.js](/fr/docs/user/languages/javascript-with-nodejs/)

#### Perl

    language: perl
    perl:
      - "5.14"
      - "5.12"

Apprenez-en plus sur les options de [.travis.yml pour les projets  Perl](/fr/docs/user/languages/perl/)

#### PHP

    language: php
    php:
      - 5.3
      - 5.4

Apprenez-en plus sur les options de [.travis.yml pour les projets PHP](/fr/docs/user/languages/php/)

#### Python

    language: python
    python:
      - 2.6
      - 2.7
      - 3.2
    # command to install dependencies, e.g. pip install -r requirements.txt --use-mirrors
    install: PLEASE CHANGE ME
    # command to run tests, e.g. python setup.py test
    script:  PLEASE CHANGE ME

Apprenez-en plus sur les options de [.travis.yml pour les projets Python](/fr/docs/user/languages/python/)

#### Ruby

    language: ruby
    rvm:
      - 1.8.7
      - 1.9.2
      - 1.9.3
      - jruby-18mode # JRuby in 1.8 mode
      - jruby-19mode # JRuby in 1.9 mode
      - rbx-18mode
      - rbx-19mode
    # uncomment this line if your project needs to run something other than `rake`:
    # script: bundle exec rspec spec

Apprenez-en plus sur les options de [.travis.yml pour les projets Ruby](/fr/docs/user/languages/ruby/)

#### Scala

     language: scala
     scala:
       - 2.8.2
       - 2.9.1

Apprenez-en plus sur les options de [.travis.yml options for Scala projects](/fr/docs/user/languages/scala/)

#### Validez votre .travis.yml

Nous vous recommendons l'utilisation de [travis-lint](http://github.com/travis-ci/travis-lint) (outil en ligne de commande) ou de [.travis.yml validation Web app](http://lint.travis-ci.org) pour valider votre fichier `.travis.yml`.

`travis-lint` requière l'installation de Ruby 1.8.7+ et RubyGems. Vous pouvez l'obtenir via la commande suivante :

    gem install travis-lint

et l'executer sur votre `.travis.yml`:

    # dans un dépôt avec .travis.yml
    travis-lint

    # ou depuis n'importe quel dossier
    travis-lint [path to your .travis.yml]

`travis-lint` vérifiera des choses comme :

* le fichier `.travis.yml` est-il un [YAML valide](http://yaml-online-parser.appspot.com/) ?
* la key `language` est-elle présente ?
* les versions de runtime (Ruby, PHP, OTP, etc.) spécifiés sont-elles supportées dans l'[Environnement Travis CI](/fr/docs/user/ci-environment/) ?
* les features et les alias de runtime qui vous utilisez ne sont-ils pas dépréciés ?

et ainsi de suite. `travis-lint` est votre ami, utilisez-le.

### Etape n°4: Déclancher sa première constuction avec un push.

Un fois que le Hook GitHub est mis en place, pushez votre commit contenant .travis.yml. Cela devrait ajouté une build à l'une des files sur [Travis CI](http://travis-ci.org) et votre build démarrera aussitôt qu'un worker pour votre langage sera disponible.

Pour démarrer une build, vous pouvez soit commiter soit pusher quelquechose sur votre dépôt, ou alors vous pouvez aller sur votre page service hooks sur GitHub et cliquer le bouton "Test Hook". Attention : **vous ne pouvez pas utiliser le bouton Test Hook pour votre première build**, elle doit être déclanchée par un push.

### Etape n°5 : Customiser la configuration de la build

Il y a de fortes chances pour que votre projet demande une certaine configuration pour sa build : peut-être avez-vous besoin de créer und base de données avant d'executer vos tests ou d'utiliser d'autres outils que ceux proposés par Travis par défaut. Pas de soucis : Travis vous laisse la possibilité de modifer (presque) tout ça. Reportez-vous à [la configuration de la build](/fr/docs/user/build-configuration/) pour en savoir plus.

Après avoir fait vos changements à  `.travis.yml`, n'oubliez pas de vérifier qu'il reste un [YAML valide](http://yaml-online-parser.appspot.com/) et faites-le valider avec `travis-lint`.

### Etape n°6 : En apprendre plus

Un worker Travis possède bon nombre de services dont vous pouvez avoir besoin parmis lesquels MySQL, PostgreSQL, MongoDB, CouchDB, RabbitMQ, memcached et d'autres.

Lisez [Configurer une base de données](/fr/docs/user/database-setup/) pour apprendre à configurer une connection de base de données pour votre suite de tests. Vous pourrez trouver plus d'informations sur notre environement de test dans [un autre guide](/fr/docs/user/ci-environment/).

### Etape n°7 : Nous sommes là pour vous aider !

Quelque soit votre question, n'hésitez pas à rejoindre notre canal IRC [#travis sur chat.freenode.net](irc://chat.freenode.net/%23travis). On sera là pour vous aider ;). Bien que la lingua franca du canal soit l'anglais, vous pourrez aussi y trouver quelques francophones pour vous aider !
