---
title: Construindo um Projeto Groovy
layout: pt-BR
permalink: groovy/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos Groovy. Por favor leia o nosso [Guia de Início](/pt_BR/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.

## Visão Geral

O ambiente do Travis CI oferece o OpenJDK 7, OpenJDK 6, Oracle JDK 7u4, Gradle 1.4, Maven 3 e Ant. O construtor de projetos Groovy possui boas configurações padrão para projetos que usem Gradle, Maven ou Ant, então provavelmente você não precisará configurar nada além de 

    language: groovy

no seu arquivo `.travis.yml`.

O suporte para múltiplos JDKs será oferecido no futuro.

## Projetos Usando Gradle

### Comando Padrão de Teste

Se o seu projeto possui o arquivo `build.gradle` na raiz do repositório, o construtor Groovy do Travis utilizará o Gradle para construí-lo. Por padrão, ele utilizará

    gradle check

para executar a suite de teste. Este comportamento pode ser sobrescrito conforme descrito no [guia de configuração de build](/pt_BR/user/build-configuration/).

### Gerenciamento de Dependências

Antes de executar os testes, o construtor Groovy executará

    gradle assemble

para instalar as dependências do seu projeto com Gradle.

## Projetos Usando Maven

### Comando Padrão de Teste

Se o seu projeto possuir o arquivo `pom.xml` na raiz do repositório e não possuir o `build.gradle`, o construtor Groovy do Travis usará o Maven 3 para construí-lo. Por padrão ele utilizará

    mvn test

para executar a suite de testes. Este comportamento pode ser sobrescrito conforme descrito no [guia de configuração de build](/pt_BR/user/build-configuration/).

### Gerenciamento de Dependências

Antes de executar os testes, o construtor Groovy executará

    mvn install -DskipTests=true

para instalar as dependências do seu projeto com Maven.

## Projetos Usando Ant

### Comando Padrão de Teste

Caso o Travis não encontre arquivos Maven ou Gradle, o construtor Groovy utilizará o Ant para construir o seu projeto. Por padrão será utilizado

    ant test

para executar a suite de testes. Este comportamento pode ser sobrescrito conforme descrito no [guia de configuração de build](/pt_BR/user/build-configuration/).


### Gerenciamento de Dependências

Como não existe uma forma padrão de instalar dependências em um projeto com Ant, o construtor Groovy do Travis CI não possui configurações padrão para ele. Você deve especificar o comando a executar utilizando a chave  `install:` no seu `.travis.yml`. Por exemplo:

    language: groovy
    install: ant deps


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
