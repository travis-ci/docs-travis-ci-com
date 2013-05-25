---
title: Valide seu arquivo .travis.yml com travis-lint
layout: pt-BR
permalink: travis-lint/
---

### O Que Este Guia Cobre

Este guia cobre o [travis-lint](https://github.com/travis-ci/travis-lint), uma pequena ferramenta que valida o seu arquivo `.travis.yml` de forma a ajudá-lo a descobrir problemas comuns. Caso esteja procurando informações sobre como adicionar o seu projeto no travis-ci.org, comece pelo [Guia de Início](/pt-BR/docs/user/getting-started/).


## Valide o .travis.yml com o lint.travis-ci.org

[A aplicação web de validação do .travis.yml](http://lint.travis-ci.org) é a maneira mais fácil de validar o seu arquivo `.travis.yml`.

## Valide o .travis.yml com o travis-lint (ferramenta de linha de comando)

Se você possuir o Ruby 1.8.7+ e o RubyGems instalado, poderá utilizar o [travis-lint](http://github.com/travis-ci/travis-lint) para validar o seu arquivo `.travis.yml`. Obtenha-o com

    gem install travis-lint

e execute-o no seu `.travis.yml`:

    # dentro do repositório com o .travis.yml
    travis-lint

    # de qualquer diretório
    travis-lint [caminho para o seu .travis.yml]

O `travis-lint` é novo mas vem evoluindo, e nós estamos adicionando diversas novas verificações para problemas comuns conforme aprendemos mais sobre tais problemas com os usuários do travis-ci.org.
