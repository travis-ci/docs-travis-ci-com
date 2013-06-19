---
title: Sobre o Ambiente de Integração Contínua do Travis
layout: pt-BR
permalink: ci-environment/
---

### O Que Este Guia Cobre

Este guia explica quais pacotes, ferramentas e configurações estão disponíveis no ambiente de integração contínua do Travis (comumente chamado de "ambiente de IC"), bem como as máquinas virtuais utilizadas pelo travis-ci.org são atualizadas e colocadas em produção. Este último explica o quão você deve esperar até que novas versões do Ruby, PHP, Node.js, etc sejam fornecidas.

## Visão Geral

O ambiente de CI do Travis executa as construções (builds) em máquinas virtuais que são armazenadas (snapshotted) antes de cada construção e restauradas ao seu término. Isto oferece diversos benefícios:

* O sistema hospedeiro não é afetado pelas suites de testes
* Nenhum estado persiste entre as execuções
* O sudo sem senha está disponível (de forma que você pode instalar dependências utilizando apt)
* As suites de testes podem criar bancos de dados, adicionar vhosts/usuários RabbitMQ, etc

O ambiente disponível para as suites de testes é conhecido como o *Ambiente de IC Travis*. As máquinas virtuais (VMs) são iniciadas através de imagens de VM ("boxes") que estão disponíveis para o público. O fornecimento de imagens das VMs é extremamente automatizado, de forma que novas versões são oferecidas uma vez por semana, em média.

## Sistema Operacional do Ambiente de IC

O travis-ci.org usa a versão 32-bits do Ubuntu Linux 11.19 (served edition).

## Como as VMs do travis-ci.org são geradas

O fornecimento de VMs é automatizado utilizando o [OpsCode Chef](http://www.opscode.com/chef/). As VMs nunca são atualizadas em funcionamento, nós sempre substituímos a imagem inteira. As imagens das máquinas virtuais são primeiramente enviadas para a nossa rede interna e então colocadas em produção em cada máquina trabalhadora (worker) durante períodos menos movimentados do dia. Em média, tentamos colocar em produção novas versões dos ambientes de execução (ex. Ruby ou PHP) e softwares como bancos de dados em até uma semana após a sua disponibilização para o público, dado que o Core Team do Travis está ciente ou foi notificado sobre a nova versão.

## Ambiente comum à todas as Imagens de VMs

### Built toolchain

GCC 4.5.x, make, autotools, etc.

### Ferramentas de Rede

curl, wget, OpenSSL, rsync

### Ambientes de Execução

Cada trabalhador possui ao menos uma versão de 

* Ruby
* OpenJDK
* Python
* Node.js

para acomodar projetos que possam precisar de algum desses ambientes de execução durante a construção.

Trabalhadores específicos da linguagem possuem múltiplos ambientes de execução da respectiva linguagem (por exemplo, trabalhadores Ruby possuem cerca de 10 versões/implementações de Ruby).

### Armazenamento de Dados

* MySQL 5.1.x
* PostgreSQL 8.4.x
* SQLite 3.7.x
* MongoDB 2.0.x
* Riak 1.1.x
* Redis 2.4.x
* CouchDB 1.0.x

### Tecnologia de Mensageria

* [RabbitMQ](http://rabbitmq.com) 2.7.x
* [ZeroMQ](http://www.zeromq.org/) 2.1.x

### Ferramentas de Testes com Browser

* [xvfb](http://en.wikipedia.org/wiki/Xvfb) (X Virtual Framebuffer)
* [Phantom.js](http://www.phantomjs.org/) 1.4.x

### Variáveis de Ambiente

* `DEBIAN_FRONTEND=noninteractive`
* `CI=true`
* `TRAVIS=true`
* `HAS_JOSH_K_SEAL_OF_APPROVAL=true`
* `USER=vagrant` (**sujeito à mudanças, não dependa deste valor**)
* `HOME=/home/vagrant` (**sujeito à mudanças, não dependa deste valor**)
* `LANG=en_US.UTF-8`
* `LC_ALL=en_US.UTF-8`

### Bibliotecas

* OpenSSL
* ImageMagick

### Configuração do apt

O apt é configurado para não solicitar confirmação (assume o -y por padrão) usando tanto a variável de ambiente `DEBIAN_FRONTEND` quanto o arquivo de configuração do apt. Isto significa que `apt-get install -qq` pode ser utilizado sem a flag -y.


## Imagens VM de JVM (Clojure, Groovy, Java, Scala)

### Versão do Maven

 Apache Maven 3.0.x padrão.

### Versões do Leiningen

O travis-ci.org possui tanto a versão standalone ("uberjar") do Leiningen 1.7.x em `/usr/local/bin/lein` quanto o Leiningen 2.0 [preview2] em `/usr/local/bin/lein2`.

### Versão do SBT

travis-ci.org fornece o SBT 0.11.x.

### Versão do Gradle

Atualmente 1.0 Milestone 8.

## Imagens VM do Erlang

### Releases Erlang/OTP

* R15B
* R14B04
* R14B03
* R14B02

As versões Erlang/OTP são construídas utilizando [kerl](https://github.com/spawngrid/kerl).

## Imagens VM do Node.js

### Versões do Node.js

* 0.4 (0.4.12)
* 0.6 (0.6.12)
* 0.7 (0.7.5)

Os ambientes de execução do Node são construídos usando [NVM](https://github.com/creationix/nvm).

### SCons

O Scons está disponível para [construir o joyent/node no travis-ci.org](http://travis-ci.org/#!/joyent/node). Outros projetos também podem utilizá-lo.


## Imagens VM do Haskell

### Versões da Plataforma Haskell

[Haskell Platform](http://hackage.haskell.org/platform/contents.html) 2011.04 (inclui GHC 7.0).


## Imagens VM do Perl

### Versões do Perl

* 5.14
* 5.12
* 5.10

instaladas via [Perlbrew](http://perlbrew.pl/). 

### cpanm

cpanm (App::cpanminus) versão 1.5007

## Imagens VM do PHP

### Versões do PHP

* 5.2 (5.2.17)
* 5.3 (5.3.10, 5.3.2)
* 5.4 (5.4.0)

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
* 3.1
* 3.2

Cada Python possui um virtualenv separado que vem com `pip` e `distribute` e é ativado antes da execução da construção.

### Pacotes pip Pré-instalados

* nose
* py.test
* mock

## Imagens VM do Ruby (aka common)

### Versões/Implementações do Ruby

* 1.8.7 (padrão)
* 1.9.2
* 1.9.3
* jruby-18mode (1.6.7; apelido alternativo: jruby)
* jruby-19mode (1.6.7 no modo Ruby 1.9)
* rbx-18mode (apelido alternativo: rbx)
* rbx-19mode (no modo Ruby 1.9)
* ree (2012.02)
* ruby-head (atualizado a cada 1-2 semanas)
* jruby-head (atualizado a cada 1-2 semanas)

[Ruby 1.8.6 e 1.9.1 não são mais fornecidos no travis-ci.org](https://twitter.com/travisci/status/114926454122364928).

Rubies são construídos utilizando o [RVM](https://rvm.beginrescueend.com/) que é instalado por usuário e localizado do `~/.bashrc`.

### Versão do Bundler

Uma versão 1.1.x recente (geralmente a mais recente)

### Gems no gem set global

* bundler
* rake

### Variáveis de Ambiente

* `RAILS_ENV=test`
* `RACK_ENV=test`
* `MERB_ENV=test`
* `JRUBY_OPTS="--server -Dcext.enabled=false"`

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

O ambiente de IC do Travis é configurado usando o [OpsCode Chef](http://www.opscode.com/chef/). Todos os [cookbooks (receitas) usados pelo travis-ci.org](https://github.com/travis-ci/travis-cookbooks/tree/master/ci_environment) são open source e podem ser encontrados pelo GitHub. O travis-ci.org usa o Ubuntu Linux 11.10 de 32 bits, mas graças ao Chef, a migração para uma versão diferente do Ubuntu ou para outra distribuição Linux é muito mais fácil.

Os cookbooks do Chef são desenvolvidos utilizando o [Vagrant](http://vagrantup.com/) e [Sous Chef](https://github.com/michaelklishin/sous-chef), de forma que os contribuidores dos cookbooks são encorajados a utilizá-los.

Muitos dos cookbooks que o ambiente de IC do Travis usa foram retirados do [repositório oficial de cookbooks do OpsCode](https://github.com/opscode/cookbooks). Nós modificamos alguns deles para as necessidades da integração contínua e os sincronizamos periodicamente ou quando for necessário.
