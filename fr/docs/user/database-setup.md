---
title: Les bases de données des workers de Travis
layout: fr
permalink: database-setup/
---

Chaque worker de Travis CI contient des logiciels préinstallés qui sont souvent utilisés par la communauté open source. Parmis les services installés on compte:

* des bases de données – MySQL, PostgreSQL, SQLite3, MongoDB
* des systèmes de gestion de BDD – Redis, Riak, memcached
* un système de messagerie – RabbitMQ
* node.js, ImageMagick

Vous trouverez la liste complètes des logiciels intallés, ainsi que les moteurs et les versions Ruby, dans le [fichier de configuration du worker][config]. Ce fichier indique quelles [recettes du cookbook][cookbook] sont utilisées pour la construction d'une instance d'un worker.

Certains, comme node.js et memcached, sont soit disponibles dans le PATH ou exécutés sur un port par défaut. Ils ne nécessitent donc aucune spécification. D'autres, comme les BDD, peuvent nécessiter une autentification.

On vous explique ici comment configurer votre projet afin qu'il utilise des BDD pour ses tests. On considérera que vous avez déjà lu la documentation concernant la [configuration d'une build][config build].

### SQLite3

C'est sans doute la solution la plus facile et la plus simple pour votre base de données relationnelle. S'il vous est égal de savoir comment votre code fonctionne avec d'autres BDD, SQLite est sûrement la meilleure solution, et la plus rapide.

Pour les projets Ruby, soyez sûrs d'inclure le gem sqlite3 dans votre bundle : 

    # Gemfile
    gem 'sqlite3'

Si votre projet est une application Rails, vous aurez juste besoin de ce qui suit pour l'installation :

    # config/database.yml in Rails
    test:
      adapter: sqlite3
      database: ":memory:"
      timeout: 500

Toutefois, si votre projet est une librairie ou un plugin, vous devrez vous-même établir la connexion dans les tests. Par example, en les connectant à ActiveRecord :

    ActiveRecord::Base.establish_connection :adapter => 'sqlite3',
                                            :database => ':memory:'

### MySQL

MySQL pour Travis ne nécessite aucune autentification. Entrez un champ *username* vide et n'entrez aucun champ *password* :

    mysql:
      adapter: mysql2
      database: myapp_test
      username: 
      encoding: utf8

Vous devrez tout d'abord créer la BDD `myapp_test`. Exécutez ceci dans votre script de build :

    # .travis.yml
    before_script:
      - "mysql -e 'create database myapp_test;'"

### PostgreSQL

PostgreSQL nécessite une autentification avec un utilisateur "postgres" mais aucun mot de passe :

    postgres:
      adapter: postgresql
      database: myapp_test
      username: postgres

Vous devrez créer la BDD dans votre build :

    # .travis.yml
    before_script:
      - "psql -c 'create database myapp_test;' -U postgres"

### MongoDB

MongoDB ne nécessite aucune identification ou création de BDD dans votre script :

    require 'mongo'
    Mongo::Connection.new('localhost').db('myapp')

Si toutefois vous vous devez créer des utilisateurs pour votre BDD, vous pouvez procéder ainsi :

    # .travis.yml
    before_script:
      - mongo myapp --eval 'db.addUser("travis", "test");'

    # then, in ruby:
    uri = "mongodb://travis:test@localhost:27017/myapp"
    Mongo::Connection.from_uri(uri)

### Plusieurs systèmes de base de données

Si les tests de votre projet ont besoin d'être testés avec plusieurs bases de données, il existe plusieurs manière de configurer Travis CI pour y arriver. Une des approches revient à mettre toutes les bases de données dans un fichier yaml :

    # test/database.yml
    sqlite:
      adapter: sqlite3
      database: ":memory:"
      timeout: 500
    mysql:
      adapter: mysql2
      database: myapp_test
      username: 
      encoding: utf8
    postgres:
      adapter: postgresql
      database: myapp_test
      username: postgres

Ensuite, dans votre suite de tests, importez ce fichier dans un hash de configuration : 

    configs = YAML.load_file('test/database.yml')
    ActiveRecord::Base.configurations = configs

    db_name = ENV['DB'] || 'sqlite'
    ActiveRecord::Base.establish_connection(db_name)
    ActiveRecord::Base.default_timezone = :utc

Maintenant vous pouvez utilisez la variable d'environnement "DB" pour spécifier le nom de la configuration de BDD que vous voulez utiliser. En local, cela revient à faire :

    $ DB=postgres bundle exec rake

Sur Travis CI, vous pouvez tester les 3 BDD. Pour ce faire, vous utiliserez l'option "env":

    # .travis.yml
    env:
      - DB=sqlite
      - DB=mysql
      - DB=postgres

En faisant cela, il est préférable d'avoir lu et compris tout ce qui concerne les matrices de build décrit dans  [Configurer une build][config build].

Et enfin, assurez-vous que vous ne créer pas de BDD mysql ou postgres dans votre script comme expliqué dans les parties précédentes.

[cookbook]: https://github.com/travis-ci/travis-cookbooks
[config]: https://github.com/travis-ci/travis-worker/blob/master/config/worker.production.yml
[config build]: /fr/docs/user/build-configuration/
