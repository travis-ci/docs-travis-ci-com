---
title: Vérifier votre .travis.yml avec travis-lint
layout: fr
permalink: travis-lint/
---

### Ce que couvre ce guide

Ce guide est à propos de [travis-lint](https://github.com/travis-ci/travis-lint), un outil simple qui vérifie votre fichier `.travis.yml` et vous aider a y déceler les erreurs les plus courantes. Si vous cherchez à vous documenter pour mettre votre projet sur travis-ci.org, commencer par lire le guide de [Démarrage](/fr/user/getting-started/).

## Vérifiez votre .travis.yml en utilisant lint.travis-ci.org

[L'application web de validation de .travis.yml](http://lint.travis-ci.org) est l'outil le plus simple pour tester votre fichier `.travis.yml`.

## Vérifiez votre .travis.yml avec travis-lint (outil en ligne de commande)

Si vous avez Ruby 1.8.7+ et RubyGems installés, vous pouvez utiliser [travis-lint](http://github.com/travis-ci/travis-lint) pour vérifier votre fichier `.travis.yml`. Vous l'obtenez en entrant

    gem install travis-lint

and exécutez le avec `.travis.yml`:

    # dans un dépôt contenant .travis.yml
    travis-lint

    # depuis n'importe quel répertoire
    travis-lint [chemin jusqu'à votre .travis.yml]

`travis-lint` est encore jeune mais s'améliore ! Nous intégrons réguliérement de nouvelles vérifications au fur et à mesure que nous recevons des feedbacks des utilisateurs.
