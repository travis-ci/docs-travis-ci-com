---
title: Configurer une build
kind: content
---

Le fichier `.travis.yml` vous permet de configurer vos builds. Travis CI va chercher le fichier `.travis.yml` dans le tree git pointé par le commit donné par Github.

Une configuration donnée dans une branche ne va pas affecter la configuration du build d'une autre branche distincte. Notez que Travis CI va builder après <em>chaque</em> git push vers votre projet Github, quelque soit la branch, et même si le fichier `.travis.yml` n'est pas présent. Vous pouvez changer ce comportement avec des options de configuration.

Par défaut, le worker utilise les commandes suivantes pour builder un projet :

    $ rvm use 1.8.7
    $ git clone git://github.com/YOUR/PROJECT.git
    $ bundle install --path vendor/bundle
    $ bundle exec rake

Si votre projet n'utilise pas Bundler (pas de Gemfile présent), le worker va seulement appeler `rake`.

Le résultat de cette dernière commande – le script de build – indique si la build a passé ou non. Le code de sortie standard de "0" indique qu'il a passé, dans n'importe quel autre cas, c'est un échec.

À l'exception du `git clone`, chacune des commandes peut voir son comportement modifié grâce au fichier `.travis.yml`.

<h3>Choisir une version différente de Ruby</h3>

Pour spécifier la version de Ruby à utiliser, définissez l'option `rvm` :

    rvm: 1.9.2

<h3>Utiliser un Gemfile spécifique</h3>

Vous pouvez spécifier un Gemfile différent à utiliser :

    gemfile: gemfiles/Gemfile.ci

Si cette option n'est pas présente, le worker cherchera un fichier Gemfile à la racine du projet.

Vous pouvez aussi indiquer des <a href="http://gembundler.com/man/bundle-install.1.html">arguments</a> qui seront passés à `bundle install` :

    bundler_args: --binstubs

<h3>Définir des variables d'environnement</h3>

Pour définir une variable d'environnement, spécifiez :

    env: DB=postgres

Les variables d'environnement sont souvent utilisés pour configurer les scripts de build. Voyez un exemple de <a href="/fr/docs/user/database-setup/#multiple-database-systems">configuration avec plusieurs SGBD</a>. La variable `TRAVIS` est toujours présente lors du build :

    if ENV['TRAVIS']
      # cas particulier pour l'intégration continue
    end
    
<h3>La matrice de builds</h3>

Si vous combinez ces trois options de configuration, Travis CI va exécuter vos tests en croisant toutes les combinaisons selon une matrice à trois dimensions :

* `rvm` - les différentes versions de Ruby
* `gemfile` - les différents jeux de dépendances
* `env` - les variables d'environnement avec lesquelles vous pouvez configurer vos scripts

Voyez ci-dessous un exemple de configuration pour un projet qui va jusqu'à 32 builds différents.

Veuillez bien noter que Travis CI est un service open-source dont les ressources sont fournies par la communauté. Veuillez seulement spécifier les options dont vous avez <em>réellement besoin</em>.

    rvm:
      - 1.8.6
      - 1.8.7 # (par défaut)
      - 1.9.2
      - rbx
      - rbx-2.0
      - ree
      - jruby
      - ruby-head
    gemfile:
      - gemfiles/Gemfile.rails-2.3.x
      - gemfiles/Gemfile.rails-3.0.x
    env:
      - ISOLATED=true
      - ISOLATED=false

<h3>Définir un script de build spécifique</h3>

Vous pouvez spécifier la commande a exécuter à la place de `rake` :

    script: "bundle exec rake db:drop db:create db:migrate test"

Ce script peut être n'importe quel fichier exécutable, il n'a pas besoin de commencer par `bundle exec` (qui sert à inclure le bundle).

Vous pouvez aussi définir des scripts à exécuter avant et après le script principal :

    before_script: some_command
    after_script:  another_command

Vous pouvez également spécifier plusieurs scripts avec ces deux commandes.

Ces scripts sont souvent utilisés pour le setup des bases de données utilisés pour le test. Pour plus d'informations, <a href="/fr/docs/user/database-setup/">voyez la page Configurer une base de données</a>

<h3>Destinataires des notifications email et IRC</h3>

Vous pouvez modifier qui va recevoir les notifications de passage ou échec de build.

    notifications:
      recipients:
        - one@example.com
        - other@example.com

Vous pouvez aussi désactiver entièrement les notifications :

    notifications:
      disabled: true

Travis CI notifie par défaut :

* pour les repos d'un utilisateur : l'auteur du commit et le propriétaire de la repo
* pour les repos d'une organisation : l'auteur du commit et <em>tous</em> les membres de l'organisation

Vous pouvez aussi spécifier un channel IRC à notifier :

    notifications:
      irc: "irc.freenode.org#travis"

<h3>Build seulement certaines branches</h3>

Vous pouvez whitelister ou blacklister des branches :

    # blacklist
    branches:
      except:
        - legacy
        - experimental

    # whitelist
    branches:
      only:
        - master
        - stable

Si vous spécifier les deux, "except" sera ignoré.
