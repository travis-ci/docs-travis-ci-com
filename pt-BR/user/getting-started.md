---
title: Guia de início
layout: pt-BR
permalink: getting-started/
---

### Visão Geral do Travis CI

O Travis CI é um serviço de integração contínua para a comunidade open source. Ele é integrado ao GitHub e oferece suporte de primeira classe para:

* [C](/pt-BR/user/languages/c)
* [C++](/pt-BR/user/languages/cpp)
* [Clojure](/pt-BR/user/languages/clojure)
* [Erlang](/pt-BR/user/languages/erlang)
* [Go](/pt-BR/user/languages/go)
* [Groovy](/pt-BR/user/languages/groovy)
* [Haskell](/pt-BR/user/languages/haskell)
* [Java](/pt-BR/user/languages/java)
* [JavaScript (com Node.js)](/pt-BR/user/languages/javascript-with-nodejs)
* [Objective-C](/pt-BR/user/languages/objective-c)
* [Perl](/pt-BR/user/languages/perl)
* [PHP](/pt-BR/user/languages/php)
* [Python](/pt-BR/user/languages/python)
* [Ruby](/pt-BR/user/languages/ruby)
* [Scala](/pt-BR/user/languages/scala)

Nosso ambiente de integração contínua proporciona múltiplos ambientes de execução (exemplo: versões de Node.js e PHP), bancos de dados, etc. Por isso, hospedar seu projeto no travis-ci.org significa poder facilmente testar sua biblioteca ou aplicação em vários ambientes diferentes, sem tê-los instalados localmente.

O travis-ci.org originalmente começou como um serviço para a comunidade Ruby no início de 2011, mas desde então adicionou suporte à muitas outras tecnologias.

### Primeiro passo: Login

Para começar com o Travis CI, faça seu login com o GitHub OAuth. Vá até o [Travis CI](http://travis-ci.org) e clique no link de login no topo.

O GitHub vai pedir para você permitir acesso de leitura e escrita ao Travis. O Travis precisa de escrita para poder criar e configurar hooks de serviço para seus repositórios quando você pedir, mas ele não vai mexer em mais nada.

### Segundo passo: Ativar o hook de serviço do GitHub

Uma vez que você fez seu login, vá até seu [perfil](http://travis-ci.org/profile). Você verá uma lista dos seus repositórios. Use o botão para ativar ou desativar a integração do repositório com o Travis CI. Depois disso, visite a página de hooks de serviço do GitHub referente àquele repositório e cole seu nome de usuário e o token do Travis nas configurações do serviço, caso isto já não esteja pré-preenchido.

###  Terceiro passo: Crie o arquivo .travis.yml no seu repositório

Para o Travis poder construir seu projeto, você precisa falar um pouco mais sobre ele. Para fazer isso, crie um arquivo .travis.yml na raiz do seu repositório. Só iremos ver opções básicas do .travis.yml neste guia. A mais importante delas é a chave **language**. Ela diz ao Travis como ele deve construir o projeto de acordo com a linguagem dele, já que não se pode construir um projeto Ruby da mesma maneira que um projeto Clojure ou PHP.

Se o `.travis.yml` não estiver no repositório, foi criado com nome errado, ou não é um [YAML válido](http://yaml-online-parser.appspot.com/), o Travis CI irá ignorá-lo, assumindo que Ruby é a linguagem padrão e todas as configurações serão padrões.

Abaixo você pode ver alguns exemplos de **.travis.yml**:

#### C

    language: c
    compiler:
      - gcc
      - clang
    # Altere conforme necessário
    script: ./configure && make

Saiba mais sobre [opções do .travis.yml para projetos C](/pt-BR/user/languages/c/)


#### C++

    language: cpp
    compiler:
      - gcc
      - clang
    # Altere conforme necessário
    script: ./configure && make

Saiba mais sobre [opções do .travis.yml para projetos C++](/pt-BR/user/languages/cpp/)


#### Clojure

Para projetos usando Leiningen 1:

    language: clojure
    jdk:
      - oraclejdk7
      - openjdk7
      - openjdk6
	  
Para projetos usando Leiningen 2:

    language: clojure
    lein: lein2
    jdk:
      - openjdk7
      - openjdk6	

Saiba mais sobre as [opções .travis.yml para projetos Clojure](/pt-BR/user/languages/clojure/)

#### Erlang

    language: erlang
    otp_release:
      - R15B02
      - R15B01
      - R14B04
      - R14B03

Saiba mais sobre as [opções .travis.yml para projetos Erlang](/pt-BR/user/languages/erlang/)


#### Haskell

    language: haskell

Saiba mais sobre as [opções .travis.yml para projetos Haskell](/pt-BR/user/languages/haskell/)


#### Go

    language: go

Saiba mais sobre [opções do .travis.yml para projetos Go](/pt-BR/user/languages/go/)	


#### Groovy

    language: groovy
    jdk:
      - oraclejdk7
      - openjdk7
      - openjdk6
	  
Saiba mais sobre as [opções .travis.yml para projetos Groovy](/pt-BR/user/languages/groovy/)

#### Java

    language: java
    jdk:
      - oraclejdk7
      - openjdk7
      - openjdk6	

Saiba mais sobre as [opções .travis.yml para projetos Java](/pt-BR/user/languages/java/)

#### Node.js

     language: node_js
     node_js:
       - "0.10"
       - "0.8"
       - "0.6"

Saiba mais sobre as [opções .travis.yml para projetos Node.js](/pt-BR/user/languages/javascript-with-nodejs/)

#### Objective-C

     language: objective-c

Saiba mais sobre as [opções .travis.yml para projetos Objective-C](/pt-BR/user/languages/objective-c/)
	 
#### Perl

    language: perl
    perl:
      - "5.16"
      - "5.14"
      - "5.12"

Saiba mais sobre as [opções .travis.yml para projetos Perl](/pt-BR/user/languages/perl/)

#### PHP

    language: php
    php:
      - "5.5"
      - "5.4"
      - "5.3"

Saiba mais sobre as [opções .travis.yml para projetos PHP](/pt-BR/user/languages/php/)

#### Python

    language: python
    python:
      - "3.3"
      - "2.7"
      - "2.6"
    # comando para instalar dependências, ex. pip install -r requirements.txt --use-mirrors
    install: POR FAVOR ALTERE
    # comando para executar os testes, ex. python setup.py test
    script:  POR FAVOR ALTERE

Saiba mais sobre as [opções .travis.yml para projetos Python](/pt-BR/user/languages/python/)

#### Ruby

    language: ruby
    rvm:
      - "1.8.7"
      - "1.9.2"
      - "1.9.3"
      - jruby-18mode # JRuby no modo 1.8
      - jruby-19mode # JRuby no modo 1.9
      - rbx-18mode
      - rbx-19mode
    # descomente esta linha se seu projeto precisa rodar algo além de `rake`:
    # script: bundle exec rspec spec

Saiba mais sobre as [opções .travis.yml para projetos Ruby](/pt-BR/user/languages/ruby/)

#### Scala

     language: scala
     scala:
       - "2.9.2"
       - "2.8.2"
     jdk:
       - oraclejdk7
       - openjdk7
       - openjdk6

Saiba mais sobre as [opções .travis.yml para projetos Scala](/pt-BR/user/languages/scala/)

#### Valide seu .travis.yml

Recomendamos que você utilize o [travis-lint](http://github.com/travis-ci/travis-lint) (linha de comando) ou [.travis.yml Lint](http://lint.travis-ci.org) para validar seu arquivo `.travis.yml`.

`travis-lint` requer o Ruby 1.8.7+ e RubyGems instalados. Instale com:

    gem install travis-lint

e rode-o no seu `.travis.yml`:

    # dentro de um repositório com .travis.yml
    travis-lint

    # de qualquer diretório
    travis-lint [caminho para seu .travis.yml]

`travis-lint` vai checar coisas como:

* Se o arquivo `.travis.yml` é um [YAML válido](http://yaml-online-parser.appspot.com/)
* Se a chave `language` está presente
* Se as versões de runtime (Ruby, PHP, OTP, etc) especificadas são suportadas pelo [Ambiente Travis CI](/pt-BR/user/ci-environment/)
* Se você não está utilizando funcionalidades ou nomes de runtimes obsoletos

O `travis-lint` é seu amigo, use-o.

### Quarto passo: Ative seu primeiro build com um git push

Uma vez que o hook do GitHub está configurado, faça um push do seu commit que adiciona o .travis.yml ao seu repositório. Isso irá adicionar um build em uma das filas do [Travis CI](http://travis-ci.org) e seu build irá começar assim que um processo trabalhador para a sua linguagem estiver disponível. 

Para iniciar um build você pode fazer um commit e push no seu repositório, ou pode ir na página de hooks de serviço do GitHub e utilizar o botão "Test Hook" no serviço Travis. Observe que **você não pode ativar seu primeiro build usando este botão**. Ele precisa ser ativado por um push no seu repositório.

### Quinto passo: Ajustando a configuração do seu build

É possível que seu projeto necessite de uma customização no processo de build. Talvez você precise criar um banco de dados antes de rodar seus testes ou precise utilizar ferramentas de build diferentes das que o Travis usa por padrão. Não se preocupe: o Travis permite que você sobreescreva quase tudo. Veja a [Configuração de Build](/pt-BR/user/build-configuration/) para saber mais.

Após fazer alterações no `.travis.yml`, não se esqueça de verificar se ele é um [YAML válido](http://yaml-online-parser.appspot.com/) e rodar `travis-lint` para validá-lo.

### Sexto passo: Saiba mais

Um processo trabalhador do Travis (conhecido como worker) vem com um bom número de serviços que você pode precisar, incluindo MySQL, PostgreSQL, MongoDB, Redis, CouchDB, RabbitMQ, memcached e outros.

Leia [Configuração de Banco de Dados](/pt-BR/user/database-setup/) para aprender como configurar uma conexão com banco de dados para sua suíte de testes. Mais informações sobre nosso ambiente de testes podem ser encontradas em um [guia separado](/pt-BR/docs/user/ci-environment/).

### Sétimo passo: Estamos aqui para ajudar!

Para qualquer tipo de pergunta, sinta-se livre para entrar em nosso canal de IRC [#travis na rede chat.freenode.net](irc://chat.freenode.net/%23travis). Estamos aqui para ajudar! :)
