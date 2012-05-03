---
title: Comenzando
layout: es
permalink: getting-started/
---

### Travis CI Overview

Travis CI es un sistema de integración continua para la comunidad OpenSource. Está integrado con Github y ofrece soporte de primera clase para:

* [Clojure](/docs/user/languages/clojure)
* [Erlang](/docs/user/languages/erlang)
* [Groovy](/docs/user/languages/groovy)
* [Haskell](/docs/user/languages/haskell)
* [Java](/docs/user/languages/java)
* [JavaScript (with Node.js)](/docs/user/languages/javascript-with-nodejs)
* [Perl](/docs/user/languages/perl)
* [PHP](/docs/user/languages/php)
* [Python](/docs/user/languages/python)
* [Ruby](/docs/user/languages/ruby)
* [Scala](/docs/user/languages/scala)

Nuestro entorno de integración continua provee de múltiples runtimes (e.j Node.js o diferentes versiones de PHP), bases de datos y mas. Por ello usar travis significa que puedes de una manera fácil testear tu proyecto en diferentes runtimes o bases de datos sin  tenerlas todas ellas instaladas en tu maquina local.

travis-ci.org originalmente comenzó como un servicio para la comunidad Ruby a inicios de 2011, y desde entonces se ha añadido el soporte para muchas mas tecnologías.

### Paso uno: Registrarse

Para comenzar con Travis CI debes registrarte, puedes hacerlo usando tu cuenta de GitHub. Ve a [Travis CI](http://travis-ci.org) y haz clic en el enlace "Iniciar sesión con GitHub" en la parte superior.

Github te pedirá que des permiso de lectura y escritura. Travis CI necesita permiso de escritura para configurar automáticamente el Hook de servicio para tus repositorios según lo solicites. Pero no tocará nada mas.

### Paso Dos: Activar el Hook de Servicio de GitHub

Una vez que has accedido ve a tu [perfil](http://travis-ci.org/profile). Verás una lista de tus repositorios. Haz clic en los interruptores (on/off) por cada uno de los repositorios que quieres testear en travis. Una vez hecho eso visita la pagina de "Hooks de servicio" para ese proyecto y rellena los datos de usuario y el Token de travis si aun no están pre-rellenados.

Si tu repositorio pertenece a una organización o si al activar el interruptor no se activo el Hook, por favor [configúralo manualmente](/docs/user/how-to-setup-and-trigger-the-hook-manually/) en GitHub, tomará solo unos pocos minutos.

### Paso Tres: Añadir .travis.yml a tu repositorio

Para que Travis pueda construir tu proyecto, es necesario indicar al sistema algunos parámetros relativos al mismo. Para ello, añade `.travis.yml` a la raíz de tu repositorio. Sólo cubriremos las opciones mas básicas de `.travis.yml` en esta guía. La opción mas importante es la clave **language**. Esta le dice a Travis que lenguaje utilizar para construir tu proyecto: Ruby normalmente usa distintas herramientas y practicas para construir lo que pueden diferir completamente de un proyecto Clojure o PHP, por lo que Travis necesita saber que hacer.

Si el fichero `.travis.yml` no está en el repositorio, existe un error en el nombre o no es un [ YAML válido](http://yaml-online-parser.appspot.com/), travis-ci.org lo ignorará, asumiendo Ruby como el lenguaje por defecto y los valores por defecto para las demás opciones.

Algunos ejemplos del fichero **.travis.yml** para distintos lenguajes:

#### Clojure

Para proyectos que usen Leiningen 1:

    language: clojure

Para proyectos que usen Leiningen 2:

    language: clojure
    lein: lein2

Lee mas acerca de las [opciones en .travis.yml para proyectos Clojure](/docs/user/languages/clojure/)

#### Erlang

    language: erlang
    otp_release:
      - R15B
      - R14B02
      - R14B03
      - R14B04

Lee mas acerca de las [opciones en .travis.yml para proyectos Erlang](/docs/user/languages/erlang/)


#### Haskell

    language: haskell

Lee mas acerca de las [opciones en .travis.yml para proyectos Haskell](/docs/user/languages/haskell/)


#### Groovy

    language: groovy

Lee mas acerca de las [opciones en .travis.yml para proyectos Groovy](/docs/user/languages/groovy/)

#### Java

    language: java

Lee mas acerca de las [opciones en .travis.yml para proyectos Java](/docs/user/languages/java/)

#### Node.js

     language: node_js
     node_js:
       - 0.4
       - 0.6
       - 0.7 # versión de desarrollo de la 0.8, puede ser inestable

Lee mas acerca de las [opciones en .travis.yml para proyectos Node.js](/docs/user/languages/javascript-with-nodejs/)

#### Perl

    language: perl
    perl:
      - "5.14"
      - "5.12"

Lee mas acerca de las [opciones en .travis.yml para proyectos Perl](/docs/user/languages/perl/)

#### PHP

    language: php
    php:
      - 5.3
      - 5.4

Lee mas acerca de las [opciones en .travis.yml para proyectos PHP](/docs/user/languages/php/)

#### Python

    language: python
    python:
      - 2.6
      - 2.7
      - 3.2
    # comando para instalar las dependencias, eje. pip install -r requirements.txt --use-mirrors
    install: PLEASE CHANGE ME
    # comando para lanzar los test, eje. python setup.py test
    script:  PLEASE CHANGE ME

Lee mas acerca de las [opciones en .travis.yml para proyectos Python](/docs/user/languages/python/)

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
    # descomentar la siguiente línea en caso de que tu proyecto necesite algo mas que  `rake`:
    # script: bundle exec rspec spec

Lee mas acerca de las [opciones en .travis.yml para proyectos Ruby](/docs/user/languages/ruby/)

#### Scala

     language: scala
     scala:
       - 2.8.2
       - 2.9.1

Lee mas acerca de las [opciones en .travis.yml para proyectos Scala](/docs/user/languages/scala/)

#### Valida tu .travis.yml

Recomendamos usar [travis-lint](http://github.com/travis-ci/travis-lint) (herramienta de linea de comando) o [.travis.yml Web app de validación ](http://lint.travis-ci.org) para validar tu fichero `.travis.yml`.

`travis-lint` requiere Ruby 1.8.7+ y RubyGems instalado. Obtenlo:

    gem install travis-lint

y ejecútalo en tu `.travis.yml`:

    # dentro de un repositorio con .travis-yml
    travis-lint

    # desdec cualquier directorio
    travis-lint [ruta al .travis.yml]

`travis-lint` validará cosas como:

* Que el fichero `.travis.yml` es un [YAML válido](http://yaml-online-parser.appspot.com/)
* Que la clave `language` existe
* Que la versión del runtime especificado (Ruby, PHP, OTP, etc) está soportado en el [Entorno de Travis CI](/docs/user/ci-environment/)
* Que no estas usando runtimes o características obsoletas.

y algunas mas. `travis-lint` es tu amigo, ¡úsalo!.

### Paso Cuatro: Lanzar tu primera construcción haciendo Git Push

Una vez configurado el Hook de Github, puedes hacer push a tu commit añadiendo el .travis.yml a tu repositorio. Esto hará que tu proyecto se añada a la cola en [Travis CI](http://travis-ci.org) y la contrucción de tu proyecto comenzará tan pronto como el worker de tu lenguaje esté disponible.

Para ejecutar la construcción de tu proyecto puedes hacerlo de 2 maneras, puedes hacer un push a tu repositorio o bien, ir a los hooks de servicio en Github y usar el botón "Test Hook" para travis. Es importante destacar que **no es posible lanzar la primera construcción con el botón Test Hook de Github**. Es necesario que se haga un push en este caso. 

### Paso cinco: Ajustado la configuración

Lo mas probable es que tu proyecto requiera de alguna personalización para el proceso de construcción: es posible que necesites crear la base de datos antes de correr tus tests, o que necesites de alguna herramienta diferente a la que travis te da por defecto. Pero no te preocupes "Travis te permite sobre escribir practicamente todo". Mira en [Configuración de la construcción](/docs/user/build-configuration/) para ver como.

Despues de hacer los cambios pertinentes en `.travis.yml`, no te olvides verificar que sea un [YAML válido](http://yaml-online-parser.appspot.com/) usa el `travis-lint` para validarlo.

### Paso Seis: Aprende más

Los Workers de travis vienen con una gran cantidad de servicios de los que posiblemente tengas alguna dependencia incluyendo MySQL, PostgreSQL, MongoDB, Redis, CouchDB, RabbitMQ, memcached y otros.

Mira [Configuración de Base de datos](/docs/user/database-setup/) para aprender como configurar la conexión a tu suite de tests. Puedes encontrar más información acerca de nuestro entorno de test en [una guía separada](/docs/user/ci-environment/).

### Paso 7: Estamos aquí para ayudar!

Para cualquier duda sientete libre de conectarte a nuestro canal de IRC [#travis en irc.freenode.net](irc://irc.freenode.net#travis). Estamos para ayudarte :)
