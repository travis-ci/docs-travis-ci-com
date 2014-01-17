---
title: Construindo um Projeto Objective-C
layout: pt-BR
permalink: objective-c/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos Objective-C. Por favor leia o nosso [Guia de Início](/pt_BR/docs/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.

## Ambiente de Integração Contínua para Projetos Objective-C

As máquinas virtuais OS X do Travis executam atualmente 10.8 e possuem o Homebrew instalado.

## Gerenciamento de Dependências

Se você possuir um `Podfile` no seu repositório, o Travis CI executará automaticamente o `pod install` durante a fase install.

Caso use outro sistema de gerenciamento de dependências, sobrescreva a chave `install:` no seu `.travis.yml`:

    install: make get-deps

Veja o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) para aprender mais.

## Script de Teste Padrão

O Travis CI assume que o seu projeto pode ser construído utilizando `xcodebuild`. Como o `xcodebuild` retorna o mesmo código (exit code) tanto para testes que passam quanto para os que falham, nós utilizamos uma versão do [objc-build-scripts](https://github.com/jspahrsummers/objc-build-scripts) criado por [Justin Spahr-Summers](https://github.com/jspahrsummers) nas nossas máquinas virtuais. O comando padrão utilizado para executar os testes é

    ~/travis-utils/osx-cibuild.sh

O conteúdo deste script pode ser visto [neste Gist](https://gist.github.com/henrikhodne/73151fccea7af3201f63).

Projetos que achem esses passos suficientes podem utilizar um arquivo .travis.yml bastante minimalístico:

    language: objective-c

É possível sobrescrever este comportamento, conforme descrito no [guia de configuração de build](/pt_BR/docs/user/build-configuration/). Por exemplo, para executar o build 
utilizando o make sem argumentos, sobrescreva a chave `script:` no `.travis.yml` para:

    script: make

## Exemplos

