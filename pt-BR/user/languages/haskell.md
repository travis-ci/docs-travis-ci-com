---
title: Construindo um Projeto Haskell
layout: pt-BR
permalink: haskell/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos Haskell. Por favor leia o nosso [Guia de Início](/pt_BR/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.

## Visão Geral

Os processos trabalhadores Haskell do travis-ci.org usam a plataforma Haskell 2012.2.0.0 e GHC 7.4.1. Para uma lista atualizada de ferramentas oferecidas, veja o nosso [guia de ambiente de Integração Contínua](/pt_BR/user/ci-environment/). Comandos de build (instalação de dependências, execução de testes) usam o `cabal` por padrão. É possível sobrescrever o comportamento padrão e utilizar o `make` ou qualquer outra ferramenta de build e de gerenciamento de dependências.


## Script de Teste Padrão

O Script padrão para testes que o construtor Haskell do Travis CI usa é

    cabal configure --enable-tests && cabal build && cabal test

É possível sobrescrever o comando de teste conforme descrito no [guia de configuração de build](/pt_BR/user/build-configuration/). Por exemplo:

    script:
      - cabal configure --enable-tests -fFOO && cabal build && cabal test


## Gerenciamento de Dependências

### Travis CI usa cabal

Por padrão o Travis CI usa `cabal` para gerenciar as dependências do seu projeto.

O comando padrão executado é

    cabal install --only-dependencies --enable-tests

É possível sobrescrever o comando de instalação de dependências conforme descrito no [guia de configuração de build](/pt_BR/user/build-configuration/). Por exemplo:

    install:
      - cabal install QuickCheck


## Exemplos

* [spockz/TravisHSTest](https://github.com/spockz/TravisHSTest/blob/master/.travis.yml)
* [ZeusWPI/12Urenloop](https://github.com/ZeusWPI/12Urenloop/blob/master/.travis.yml)
