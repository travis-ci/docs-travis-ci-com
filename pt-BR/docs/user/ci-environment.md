---
title: Sobre o Ambiente de Integração Contínua do Travis
layout: pt-BR
permalink: ci-environment/
---

### O Que Este Guia Cobre

Este guia explica quais pacotes, ferramentas e configurações estão disponíveis no ambiente de integração contínua do Travis (comumente chamado de "ambiente de IC").

## Visão Geral

O ambiente de CI do Travis executa as construções (builds) em máquinas virtuais que são armazenadas (snapshotted) antes de cada construção e restauradas ao seu término.

Este modo de operação possui a vantagem de que nenhum estado persiste entre as construções (builds), oferecendo um estado limpo e garantindo que seus testes executem em um ambiente construído do zero.

Para configurar o sistema para o seu build, você pode usar o comando `sudo` para instalar pacotes, alterar configurações, criar usuários, etc.

As construções tem acesso a uma variedade de serviços para armazenamento de dados e mensageria, e você pode instalar qualquer coisa necessária.

## Sistema Operacional do Ambiente de IC

As máquinas virtuais do Travis CI são baseadas no Ubuntu 12.04 LTS Server Edition 64 bit.

## Ambiente comum à todas as Imagens de VMs

### Git, etc
 * Uma versão (muito) nova do Git, do [PPA do Peter van der Does](https://launchpad.net/~pdoes/+archive/ppa)
 * Mercurial (pacotes oficiais do Ubuntu)
 * Subversion (pacotes oficiais do Ubuntu)

### Compiladores & Build toolchain

GCC 4.6.x, Clang 3.2.x, make, autotools, cmake, scons.

### Ferramentas de Rede

curl, wget, OpenSSL, rsync

### Go

Compilador/ferramenta de build do Go versões 1.0.3 e 1.1.1

### Ambientes de Execução

Cada trabalhador possui ao menos uma versão de 

* Ruby
* OpenJDK
* Python
* Node.js
* Compilador/ferramenta de build do Go

para acomodar projetos que possam precisar de algum desses ambientes de execução durante a construção.

Trabalhadores específicos da linguagem possuem múltiplos ambientes de execução da respectiva linguagem (por exemplo, trabalhadores Ruby possuem cerca de 10 versões/implementações de Ruby).

### Armazenamento de Dados

* MySQL 5.5.x
* PostgreSQL 9.1.x
* SQLite 3.7.x
* MongoDB 2.4.x
* Redis 2.6.x
* Riak 1.2.x
* Apache Cassandra 1.2.x
* Neo4J Community Edition 1.7.x
* ElasticSearch 0.90.x
* CouchDB 1.3.x

### Tecnologia de Mensageria

* [RabbitMQ](http://rabbitmq.com) 3.x
* [ZeroMQ](http://www.zeromq.org/) 2.1.x

### Ferramentas de Testes com Browser

* [xvfb](http://en.wikipedia.org/wiki/Xvfb) (X Virtual Framebuffer)
* [Phantom.js](http://www.phantomjs.org/) 1.9.1

### Variáveis de Ambiente

* `CI=true`
* `TRAVIS=true`
* `DEBIAN_FRONTEND=noninteractive`
* `HAS_JOSH_K_SEAL_OF_APPROVAL=true`
* `USER=travis` (**não dependa deste valor**)
* `HOME=/home/travis` (**não dependa deste valor**)
* `LANG=en_US.UTF-8`
* `LC_ALL=en_US.UTF-8`
* `RAILS_ENV=test`
* `RACK_ENV=test`
* `MERB_ENV=test`
* `JRUBY_OPTS="--server -Dcext.enabled=false -Xcompile.invokedynamic=false"`

Adicionalmente, o Travis define variáveis de ambiente que você pode usar no seu build, por exemplo, para colocar uma tag no build, ou para executar deploys após o build.

* `TRAVIS_BRANCH`: O nome da branch sendo construída.
* `TRAVIS_BUILD_DIR`: O caminho absoluto para onde o repositório sendo construído
 foi copiado na máquina virtual.
* `TRAVIS_BUILD_ID`: O id do build atual que o Travis usa internamente.
* `TRAVIS_BUILD_NUMBER`: O número do build atual (por exemplo, "4").
* `TRAVIS_COMMIT`: O commit do build que está sendo testado.
* `TRAVIS_COMMIT_RANGE`: O intervalo de commits que foi incluído no
  pull ou push request.
* `TRAVIS_JOB_ID`: O id do job atual que o Travis usa internamente.
* `TRAVIS_JOB_NUMBER`: O número do job atual (por exemplo, "4.1").
* `TRAVIS_PULL_REQUEST`: O número do pull request se o job atual é um pull request, "false" caso não seja.
* `TRAVIS_SECURE_ENV_VARS`: "true" caso variáveis seguras estejam sendo usadas. "false" caso contrário.
* `TRAVIS_REPO_SLUG`: O "slug" (no formato: `nome_do_proprietário/nome_do_repo`) do repositório
  sendo construído. (por exemplo, "travis-ci/travis-build").

Build de linguagens específicas expoem variáveis de ambiente adicionais representando a versão
sendo utilizada na construção. A linguagem que você está utilizando define se cada uma dela está definida ou não.

* `TRAVIS_RUBY_VERSION`
* `TRAVIS_JDK_VERSION`
* `TRAVIS_NODE_VERSION`
* `TRAVIS_PHP_VERSION`
* `TRAVIS_PYTHON_VERSION`

### Bibliotecas

* OpenSSL
* ImageMagick

### Configuração do apt

O apt é configurado para não solicitar confirmação (assume o -y por padrão) usando tanto a variável de ambiente `DEBIAN_FRONTEND` quanto o arquivo de configuração do apt. Isto significa que `apt-get install -qq` pode ser utilizado sem a flag -y.


## Imagens VM de JVM (Clojure, Groovy, Java, Scala)

### JDK

* Oracle JDK 7u6 (oraclejdk7)
* OpenJDK 7 (alias: openjdk7)
* OpenJDK 6 (openjdk6)

O OracleJDK 7 é o padrão pois nós utilizamos um patchlevel muito mais recente que o disponível para o
OpenJDK 7 dos repositórios do Ubuntu. Sun/Oracle JDK 6 não é fornecido pois eles já atingiram o "End of Life" em 2012.

### Versão do Maven

 Apache Maven 3.0.x padrão. O Maven está configurado para usar os mirrors Central e oss.sonatype.org em http://maven.travis-ci.org

### Versões do Leiningen

O travis-ci.org possui tanto a versão standalone ("uberjar") do Leiningen 1.7.x em `/usr/local/bin/lein` quanto o Leiningen 2.0 [preview2] em `/usr/local/bin/lein2`.

### Versão do SBT

travis-ci.org fornece o SBT 0.11.x.
O travis-ci.org provê qualquer versão do Simple Build Tool (SBT), graças
ao extremamente poderoso [sbt-extras](https://github.com/paulp/sbt-extras).
De forma a reduzir o tempo de construção, versões populares do sbt já
estão pré-instaladas (como por exemplo 0.12.1 ou 0.11.3), mas o comando `sbt`
é capaz de detectar e instalar dinamicamente a versão do sbt requerida 
pelos seus projetos Scala.

### Versão do Gradle

Gradle 1.6.

## Imagens VM do Erlang

### Releases Erlang/OTP

* R16B
* R15B03
* R15B02
* R15B01
* R15B
* R14B04
* R14B03
* R14B02

As versões Erlang/OTP são construídas utilizando [kerl](https://github.com/spawngrid/kerl).

### Rebar

O travis-ci.org fornece uma versão recente do Rebar. Caso um repositório
tenha o binário do rebar em `./rebar` (na raiz do repositório), ele será utilizado
ao invés da versão fornecida.

## Imagens VM do Node.js

### Versões do Node.js

* 0.10.x (última versão estável)
* 0.8.x
* 0.6.x
* 0.11.x (última versão de desenvolvimento, pode ser instável)
* 0.9.x (versão anterior de desenvolvimento, será descontinuada em breve)

Os ambientes de execução do Node são construídos usando [NVM](https://github.com/creationix/nvm).

### SCons

Scons 2.x.

## Imagens VM do Haskell

### Versões da Plataforma Haskell

[Haskell Platform](http://hackage.haskell.org/platform/contents.html) 2012.02 e GHC 7.4.

## Imagens VM do Perl

### Versões do Perl

* 5.19
* 5.18
* 5.16
* 5.14
* 5.12
* 5.10
* 5.8

instaladas via [Perlbrew](http://perlbrew.pl/). 

### cpanm

cpanm (App::cpanminus) versão 1.5007

## Imagens VM do PHP

### Versões do PHP

* 5.5
* 5.4 
* 5.3 

Os ambientes de execução PHP são construídos usando [php-build](https://github.com/CHH/php-build).

### XDebug

É suportado.

### Extensões

    [Módulos PHP]
    bcmath
    bz2
    Core
    ctype
    curl
    date
    dom
    ereg
    exif
    fileinfo
    filter
    ftp
    gd
    gettext
    hash
    iconv
    intl
    json
    libxml
    mbstring
    mcrypt
    mysql
    mysqli
    mysqlnd
    openssl
    pcntl
    pcre
    PDO
    pdo_mysql
    pdo_pgsql
    pdo_sqlite
    pgsql
    Phar
    posix
    readline
    Reflection
    session
    shmop
    SimpleXML
    soap
    sockets
    SPL
    sqlite3
    standard
    sysvsem
    sysvshm
    tidy
    tokenizer
    xdebug
    xml
    xmlreader
    xmlrpc
    xmlwriter
    xsl
    zip
    zlib

    [Módulos Zend]
    Xdebug

## Imagens VM do Python

### Versões do Python

* 2.5
* 2.6
* 2.7
* 3.2
* 3.3
* pypy

Cada Python possui um virtualenv separado que vem com `pip` e `distribute` e é ativado antes da execução da construção.

Python 2.4 e Jython *não são suportados* e não existem planos de suportá-los no futuro.

### Pacotes pip Pré-instalados

* nose
* py.test
* mock

## Imagens VM do Ruby (aka common)

### Versões/Implementações do Ruby

* 2.0.0
* 1.9.3 (padrão)
* 1.9.2
* jruby-18mode (1.7.4 no modo Ruby 1.8)
* jruby-19mode (1.7.4 no modo Ruby 1.9)
* rbx-18mode (apelido alternativo: rbx)
* rbx-19mode (no modo Ruby 1.9)
* ruby-head (atualizado a cada 3-4 semanas)
* jruby-head (atualizado a cada 3-4 semanas)
* 1.8.7
* ree (2012.02)

[Ruby 1.8.6 e 1.9.1 não são mais fornecidos no travis-ci.org](https://twitter.com/travisci/status/114926454122364928).

Rubies são construídos utilizando o [RVM](https://rvm.beginrescueend.com/) que é instalado por usuário e localizado do `~/.bashrc`.

### Versão do Bundler

Uma versão 1.3.x recente (geralmente a mais recente)

### Gems no gem set global

* bundler
* rake

## Como as Imagens das VMs são Atualizadas e Colocadas em Produção

Nós utilizamos o Vagrant para desenvolver, testar, construir, exportar e importar imagens da VM (conhecidas como "Vagrant boxes"). A geração das imagens é automatizada utilizando o [OpsCode Chef](http://www.opscode.com/chef/). As imagens das máquinas virtuais são primeiramente enviadas para a nossa rede interna e então colocadas em produção em cada máquina trabalhadora (worker) durante períodos menos movimentados do dia (perto de 03:00 GMT). As imagens para diferentes trabalhadores variam em tamanho mas no geral estão **entre 1.6 e 3.3 GB em tamanho**.

Isto significa que, para gerar uma imagem de uma nova versão do PHP (por exemplo), fazemos o seguinte:

* Atualização do nossos cookbooks relacionados ao PHP e possivelmente de ferramentas como o php-build.
* Teste dos cookbooks localmente
* Construção de uma nova imagem VM para PHP
* Envio da imagem para a nossa rede interna
* Desligamento do php1.worker.travis-ci.org para importar a imagem nova

Para novas versões de armazenamentos de dados ou tecnologias de mensageria, por exemplo, Riak:

* Atualização do nosso cookbook do Riak
* Teste do cookbook localmente
* Construção de uma nova imagem VM padrão, e então imagens VM específicas (Ruby, PHP, Node.js, etc) baseadas na imagem padrão
* Envio das novas imagens para a nossa rede interna
* Desligamento dos trabalhadores do travis-ci.org um a um para importar as novas imagens

O processo inteiro usualmente leva de uma a algumas horas (dependendo de quantas imagens precisam ser reconstruídas). Combinadas com o tempo para testes, novas versões de ambientes de execução e outros softwares amplamente utilizados geralmente são disponibilizados no travis-ci.org uma semana após o Core Team do Travis ser notificado sobre a nova versão.


## Chef Cookbooks (Receitas)

O ambiente de IC do Travis é configurado usando o [OpsCode Chef](http://www.opscode.com/chef/). Todos os [cookbooks (receitas) usados pelo travis-ci.org](https://github.com/travis-ci/travis-cookbooks/tree/master/ci_environment) são open source e podem ser encontrados pelo GitHub. O travis-ci.org usa o Ubuntu Linux 12.04 LTS de 64 bits, mas graças ao Chef, a migração para uma versão diferente do Ubuntu ou para outra distribuição Linux é muito mais fácil.

Os cookbooks do Chef são desenvolvidos utilizando o [Vagrant](http://vagrantup.com/) e [Sous Chef](https://github.com/michaelklishin/sous-chef), de forma que os contribuidores dos cookbooks são encorajados a utilizá-los.

Muitos dos cookbooks que o ambiente de IC do Travis usa foram retirados do [repositório oficial de cookbooks do OpsCode](https://github.com/opscode/cookbooks). Nós modificamos alguns deles para as necessidades da integração contínua e os sincronizamos periodicamente ou quando for necessário.
