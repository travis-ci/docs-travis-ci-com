---
title: Construindo um Projeto Scala
layout: pt-BR
permalink: scala/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos Scala. Por favor leia o nosso [Guia de Início](/pt_BR/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.

## Visão Geral

O ambiente do Travis CI oferece o OpenJDK 7, OpenJDK 6, Oracle JDK 7, Gradle 1.4, Maven 3, Ant e SBT (..., 0.10, 0.11, 0.12,...) através do script sbt-extras. Graças a habilidade do SBT em executar ações em múltiplas versões do Scala, é possível testar seus projetos com Scala 2.8.x, 2.9.x e 2.10.x. Para especificar as versões do Scala que você quer utilizar para testar seu projeto, use a chave `scala`:
 
    language: scala
    scala:
       - 2.8.2
       - 2.9.2

## Projetos Usando SBT

### Comando Padrão de Teste

Caso o seu projeto tenha um diretório `project` ou um arquivo `build.sbt` na raiz do repositório, o construtor Scala do Travis utilizará o SBT para construí-lo. Por padrão, ele utilizará

    sbt ++$TRAVIS_SCALA_VERSION test

para executar a suite de teste. 
to run your test suite. Este comportamento pode ser sobrescrito conforme descrito no [guia de configuração de build](/pt_BR/user/build-configuration/).

### Gerenciamento de Dependências

Como o construtor Scala do Travis assume o uso do gerenciador de dependências SBT, ele obterá as dependências de projeto antes de executar os testes sem nenhum esforço de sua parte.

## Projetos Usando Gradle

### Comando Padrão de Teste

Se o seu projeto possui o arquivo `build.gradle` na raiz do repositório, o construtor Scala do Travis utilizará o Gradle para construí-lo. Por padrão, ele utilizará

    gradle check

para executar a suite de teste.

### Gerenciamento de Dependências

Ele obterá naturalmente as dependências do projeto antes de executar os testes, sem nenhum esforço de sua parte.

## Projetos Usando Maven

### Comando Padrão de Teste

Caso não encontre arquivos Gradle ou SBT, o construtor Scala do Travis usará o Maven para construí-lo. Por padrão ele utilizará
 
    mvn test

para executar sua suite de testes.

### Gerenciamento de Dependências

Ele obterá naturalmente as dependências do projeto antes de executar os testes, sem nenhum esforço de sua parte.

## Testando em Múltiplos JDKs

Para testar em múltiplos JDKs, use a chave `:jdk` no `.travis.yml`. Por exemplo, para testar no Oracle JDK 7 (que é mais novo que o OpenJDK 7 no Travis CI) e no OpenJDK 6:

    jdk:
      - oraclejdk7
      - openjdk6

Para testar no OpenJDK 7 e Oracle JDK 7:

    jdk:
      - openjdk7
      - oraclejdk7

O Travis CI provê o OpenJDK 7, OpenJDK 6 e Oracle JDK 7. O Sun JDK 6 não é fornecido porque foi marcada como EOL (End-Of-Life) em Novembro de 2012.

O JDK 7 possui compatibilidade com as versões anteriores, e nós achamos que é hora de todos os projetos começarem a serem testados no JDK 7 primeiro, e no JDK 6 apenas se os recursos permitirem.

## Exemplos

* [twitter/scalding](https://github.com/twitter/scalding/blob/master/.travis.yml)
* [novus/salat](https://github.com/novus/salat/blob/master/.travis.yml)
* [scalaz/scalaz](https://github.com/scalaz/scalaz/blob/master/.travis.yml)
