---
title: Sobre o Ambiente OS X do Travis CI
layout: pt-BR
permalink: osx-ci-environment/
---

### O Que Este Guia Cobre

Este guia explica quais pacotes, ferramentas e configurações estão disponíveis no ambiente do Travis CI (frequentemente chamado de ambiente de integração contínua), bem como as máquinas virtuais usadas pelo travis-ci.org são atualizadas e colocadas em produção. Este último explica quando você deve esperar que novas versões do Ruby, PHP, Node.js, etc sejam fornecidas.


## Visão Geral

O Travis CI executa as construções em imagens de máquinas virtuais utilizadas em cada build e restauradas após o seu final. Esta abordagem oferece alguns benefícios:

* O sistema operacional do host não é afetado pela suite de testes
* Nenhum estado persiste entre as execuções (builds)
* O sudo sem senha está disponível (de forma que você pode instalar dependências com apt etc)
* As suites de testes podem criar bancos de dados, adicionar usuários/vhosts RabbitMQ etc

O ambiente disponível para a suite de testes é conhecida como *ambiente Travis CI*.

## Sistema operacional do ambiente Travis CI

travis-ci.org usa o Mac OS X 10.8.2

## Ambiente comum à todas as imagens de máquinas virtuais

### Homebrew

O Homebrew é instalado e atualizado cada vez que as imagens são atualizadas. É recomendável executar `brew update` antes de instalar qualquer coisa com o Homebrew.


### Compiladores & Ferramentas de Build

GCC 4.2.1, Clang 4.1, make, autotools.


### Ferramentas de Rede

curl, wget, OpenSSL, rsync

### Xcode

O Xcode 4.6.1 está instalado com os simuladores de iOS 6.0 e 6.1. As ferramentas de linha de comando também estão instaladas.


### Ambientes de Execução

Cada ambiente tem pelo menos uma versão de

* Ruby
* Java
* Python

de forma a acomodar projetos que podem necessitar de algum desses ambientes de execução durante o build.

### Variáveis de Ambiente

* `CI=true`
* `TRAVIS=true`
* `USER=travis` (**não dependa deste valor**)
* `HOME=/Users/travis` (**não dependa deste valor**)

Adicionalmente, o Travis define algumas variáveis de ambiente que você pode utilizar no seu build para, por exemplo, criar uma tag para o build ou executar passos após a construção.

* `TRAVIS_BRANCH`: O nome da branch sendo construída
* `TRAVIS_BUILD_DIR`: O caminho absoluto para o diretório onde o repositório sendo construído foi copiado.
* `TRAVIS_BUILD_ID`: O id do build atual, que o Travis utiliza internamente.
* `TRAVIS_BUILD_NUMBER`: O número atual do build (por exemplo, "4").
* `TRAVIS_COMMIT`: O commit que o build corrente está testando.
* `TRAVIS_COMMIT_RANGE`: O intervalo de commits que está incluído no push ou pull request.
* `TRAVIS_JOB_ID`: O id do job atual, usado internamente pelo Travis.
* `TRAVIS_JOB_NUMBER`: O número atual do job (por exemplo, "4.1").
* `TRAVIS_PULL_REQUEST`: O número do pull request caso o job em questão seja um pull request, "false" caso contrário.
* `TRAVIS_SECURE_ENV_VARS`: "true" caso variáveis de ambiente seguras estejam sendo utilizadas, "false" caso contrário.
* `TRAVIS_REPO_SLUG`: O nome (na forma: `nome_do_dono/nome_do_repo`) do repositório sendo construído. (por exemplo, "travis-ci/travis-build").


### Versão do Maven

Apache Maven 3 padrão.

### Versões/Implementações Ruby

* system (1.8.7) -- Você precisa usar `sudo` para instalar gems
* 1.9.3 (padrão)

Rubies são construídos usando o [RVM](http://rvm.io/) que é instalado por usuário e originado de `/etc/profile.d/rvm.sh`.

### Versão do Bundler

Uma versão 1.2.x recente (geralmente a mais recente)

### Gems no gem set global

* bundler
* rake

