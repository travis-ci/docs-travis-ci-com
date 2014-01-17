---
title: Construire un projet PHP
layout: fr
permalink: php/
---

## Ce que couvre ce guide

Ce guide couvre l'environnement de compilation et des sujets de configuration
spécifiques pour des projets PHP. Assurez-vous de lire en premier notre [guide de
démarrage](/fr/user/getting-started/) et le [guide général de configuration
de compilation](/fr/user/build-configuration/).


## Choisir les versions de PHP à tester

Les workers PHP sur travis-ci.org fournissent PHP 5.2, 5.3, 5.4, y compris
XDebug ainsi que PHPUnit. Un fichier minimaliste .travis.yml ressemblerait à
ceci:

    language: php
    php:
      - 5.3
      - 5.4

Travis lancera vos tests en utilisant ceci 

    phpunit

par défaut avec les dernières releases 5.3.x et 5.4.x. 5.3 et 5.4 sont des alias
pour "les plus récentes releases x.y.z" de la ligne. Notez que "plus récente"
signifie "tel que prévu par les mainteneurs de Travis", pas nécessairement la
toute dernière version officelle de la release php.net. Pour une liste complète
des versions supportées, voir [À propos de Travis CI
Environment](/fr/user/ci-environment/).

A noter également que la spécification exacte des versions comme 5.3.8 est
déconseillée, car votre fichier .travis.yml peut devenir obsolète et casser
votre build quand nous mettrons à jour les versions de PHP sur Travis.

Par exemple, voir [travis-ci-php-example
.travis.yml](https://github.com/travis-ci/travis-ci-php-example/blob/master/.travis.yml).


## Script de test par défaut

Par défaut Travis lancera vos tests en utilisant

    phpunit

pour chaque version PHP que vous spécifiez.

Si votre projet utilise autre chose que PHPUnit, [vous pouvez remplacer notre
commande de test par défaut](/fr/user/build-configuration) par ce que vous
voulez.


### Travaillez avec Atoum

Au lieu de PHPUnit, vous pouvez aussi utiliser
[Atoum](https://github.com/atoum/atoum) pour tester vos projets. Par
exemple:

    before_script: wget http://downloads.atoum.org/nightly/mageekguy.atoum.phar
    script: php mageekguy.atoum.phar



## Gestion des dépendances (alias vendoring)

Avant que Travis ne lance votre suite de tests, il peut être nécessaire de
récupérer les dépendances de votre projet. Cela peut être réalisé en utilisant
un script PHP, un script Shell ou autre chose dont vous avez besoin. Définir
une ou plusieurs commandes que vous voulez que Travis CI utilise avec l'option
*before_script* dans votre .travis.yml, par exemple:

    before_script: php vendor/vendors.php

ou, si vous avez besoin de lancez plusieurs commandes séquentielles:

    before_script:
      - ./bin/ci/install_dependencies.sh
      - php vendor/vendors.php

Même si les dépendances installées seront éffacées entre les builds (Les VMs sur
lesquelles nous lançons les tests sont snaphotted), merci d'être raisonable sur
la quantité de bande passante et de temps qu'il faut pour les installer.


### Plusieurs versions des dépendances (e.g. Symfony)

Si vous avez besoin de tester plusieurs versions de, disons, Symfony, vous
pouvez demandez à Travis de faire de multiples passages avec différents
ensembles ou valeurs de variables d'environnement. Utilisez la clef *env* dans
votre fichier .travis.yml, par exemple:

    env:
      - SYMFONY_VERSION=v2.0.5
      - SYMFONY_VERSION=origin/master

et ensuite utilisez les valeurs des variables ENV dans vos scripts
d'installation de dépendances, les cas de test ou les scripts de test des
paramètres de valeurs. Ici nous utilisons la valeur de la variable DB pour
récuperer le fichier de configuration de PHPUnit:

    script: phpunit --configuration $DB.phpunit.xml

La même technique est souvent utilisée pour tester des projets avec de multiples
bases de données.

Pour voir de vrais exemples, voir [FOSUserBundle](https://github.com/FriendsOfSymfony/FOSUserBundle/blob/master/.travis.yml), [FOSRest](https://github.com/FriendsOfSymfony/FOSRest/blob/master/.travis.yml)
and [doctrine2](https://github.com/pborreli/doctrine2/blob/master/.travis.yml).



### Installation des paquets PEAR

Si vos dépendances inclus des paquets PEAR, l'environnement PHP Travis possède
la [commande Pyrus](http://pear2.php.net/):

    pyrus install http://phptal.org/latest.tar.gz

Après l'installation vous devez rafraichir votre path

    phpenv rehash

Ainsi, par exemple lorsque vous voulez utiliser phpcs, vous devez executer:

    pyrus install pear/PHP_CodeSniffer
    phpenv rehash

Maintenant vous pouvez utiliser phpcs aussi simplement que la commande phpunit

    phpcs


### Installation des paquets Composer

Vous pouvez aussi installer des paquets [Composer](http://packagist.org/) dans
l'environnement PHP Travis. Utilisez les éléments suivants:

    wget http://getcomposer.org/composer.phar 
    php composer.phar install


### Installation des extensions PHP

Il est possible d'installer des extensions PHP personnalisées dans
l'environnement Travis, mais elles doivent être construites avec la même version
de PHP testée. Voici par exemple comment l'extension `memcache` peut être
installée:

    wget http://pecl.php.net/get/memcache-2.2.6.tgz
    tar -xzf memcache-2.2.6.tgz
    sh -c "cd memcache-2.2.6 && phpize && ./configure --enable-memcache && make && sudo make install"
    echo "extension=memcache.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`

Voir aussi [midgard2 utilisant pleinement before_script](https://github.com/bergie/midgardmvc_core/blob/master/tests/travis_midgard.sh) ainsi que l'installation du [driver php mongo](https://gist.github.com/2351174).


### Livres de cuisine du chef pour PHP

Si vous voulez apprendre tous les détails de la façon dont nous construisons les
installations et les multiples prestations PHP, voir notre [php, phpenv et le
livre de cuisine php-build du chef](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base).
