---
title: Valida tus .travis.yml con travis-lint
layout: es
permalink: travis-lint/
---

### Que cubre esta guía

Esta guía cubre [travis-lint](https://github.com/travis-ci/travis-lint), una pequeña herramienta que valida tu fichero `.travis.yml` y asi descubrir algunos errores comunes. Si estas buscando información de como configurar tu proyecto en Travis CI dirijete a la guía [Comenzando](/es/docs/user/getting-started/).

## Valida .travis.yml Usando lint.travis-ci.org

[.travis.yml aplicación web de validación](http://lint.travis-ci.org) es la forma mas facil de validar tus ficheros `.travis.yml`.

## Validar .travis.yml con travis-lint (herramienta de línea de comandos)

Si tienes Ruby 1.8.7+ y RubyGems instalado, puedes usar [travis-lint](http://github.com/travis-ci/travis-lint) para validar el fichero `.travis.yml`. Obténlo:	
    gem install travis-lint

y ejecútalo:

    # dentro de un repositorio con un .travis.yml
    travis-lint

    # desde cualquier directorio
    travis-lint [path a tu .travis.yml]

`travis-lint` es joven pero mejorando día a día, incorporando más y más validaciones para los errores mas comunes, a medida que vamos aprendiendo de los errores ocurridos con los usuarios de travis-ci.org.
