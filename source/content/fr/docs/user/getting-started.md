---
title: Démarrer
kind: content
---

<h3>Assurez-vous que votre projet compile</h3>

Pour compiler sur Travis CI, votre dépôt Git doit contenir un fichier
Rakefile dont la tache par défault doit être le lancement des tests.
Rien de plus. Travis CI lancera tout d'abord `bundle install` si vous
avez un Gemfile, et ensuite `rake` par défaut. Le succès de la
compilation est déterminé par le code réponse de cette commande.


Vous pouvez <a href="/docs/user/build-configuration/">configurer</a> tous ces aspects, dont la <a href="/docs/user/database-setup/">connexion à la base de données</a> si cela est nécessaire.

<h3>Authentifiez-vous</h3>

Pour commencer à utiliser Travis CI, inscrivez-vous en utilisant Github OAuth. Allez sur <a href="http://travis-ci.org">Travis CI</a> et suivez le lien.

Github vous demandera d'accorder les droits de lecture et écriture. Travis CI requière les droits d'écriture pour mettre en place les services hooks pour votre dépôt, mais n'affectera aucune autre partie

<h3>Activez les service hooks</h3>

Une fois authentifié allez sur votre <a href="http://travis-ci.org/profile">page profile</a>. Vous retrouverez la liste de vot dépôt Github. Basculez sur on les dépôts que vous souhaitez lier à Travis CI.

Allez ensuite sur la page service hooks Github de ce projet et collez
votre username Github et votre token travis dans les paramètres du
service Travis.

<h3>Comment déclencher une compilation?</h3>

Pour démarrer une compilation vous pouvez soit faire un commit git et le pusher vers votre dépôt Github, soit aller sur la page GitHub des service hooks page et utiliser le bouton Travis "Test Hook".

Ceci ajoutera une tâche de compilation à la liste des tâches sur <a href="http://travis-ci.org">Travis CI</a>. Elle commencera dès qu'un worker sera disponible.

<h3>Paramétrer vos options de compilations</h3>

 pouvez configurer vos options de compilations en ajoutant un fichier `.travis.yml` à la racine de votre dépôt. Plus de détails sur la page <a href="/docs/user/build-configuration/">Paramètres de compilation</a>.

<h3>Base de données, infrastructure disponible et plus</h3>

Un worker Travis inclus une liste importante de services tels que MySQL, PostgreSQL, MongoDB, memcached et bien d'autres.

Consultez la page <a href="/docs/user/database-setup/">Configuration de la base de données</a> pour apprendre comment configurer les connections base de données de votre suite de tests.

<h3>Besoin d'aide?</h3>

Pour tout type d'information, n'hésitez pas à nous rejoindre sur le canal IRC <a href="irc://irc.freenode.net#travis">#travis sur irc.freenode.net</a>! La core team compte déjà plusieurs francophone. Nous sommes là pour vous aider :)
