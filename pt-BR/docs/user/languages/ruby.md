---
title: Construindo um Projeto Ruby
layout: pt-BR
permalink: ruby/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos Ruby. Por favor leia o nosso [Guia de Início](/pt_BR/docs/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.

## Escolhendo as versões/implementações do Ruby para executar os testes

Os processos trabalhadores Ruby no travis-ci.org usam [RVM](https://rvm.io/) para fornecer diversas versões/implementações Ruby que seus projetos podem utilizar para executar os testes. Para especificá-los, use a chave `rvm:` no seu arquivo `.travis.yml`. Por exemplo:

    language: ruby
    rvm:
      - 1.9.3
      - jruby-18mode # JRuby in 1.8 mode
      - jruby-19mode # JRuby in 1.9 mode
      - rbx-18mode
      - rbx-19mode
      - 1.8.7

Um exemplo mais completo:

    language: ruby
    rvm:
      - 1.9.3
      - 1.9.2
      - jruby-18mode
      - jruby-19mode
      - rbx-18mode
      - rbx-19mode
      - ruby-head
      - jruby-head
      - 1.8.7
      - ree

Com o tempo, novas versões são liberadas e nós atualizamos tanto o RVM quanto o Ruby. Apelidos como `1.9.3` ou `jruby` são alterados para apontar para versões exatas, níveis de patch, etc.
Para uma lista completa e atualizada das versões de Ruby disponíveis, veja o nosso guia [Ambiente de Integração Contínua](/pt-BR/docs/user/ci-environment/).

### Rubinius: modos 1.8 e 1.9, atualizações periódicas

Os processos trabalhadores Ruby do travis-ci.org possuem duas instalações do Rubinius, nos modos 1.8 e 1.9, respectivamente. Seus apelidos RVM são

      - rbx-18mode
      - rbx-19mode

Ambos são construídos do [branch 2.0 de teste](https://github.com/rubinius/rubinius/tree/2.0.testing) que o time do Rubinius atualiza para nós quando sentem que estão estáveis o suficiente. Isto significa que tipicamente o Rubinius é atualizado a cada 1-3 semanas.

### JRuby: Suporte à extensões C está desabilitado

Note que as **extensões C estão desabilitadas para o JRuby** no travis-vi.org. O motivo é chamar a atenção dos desenvolvedores de que o projeto deles pode possuir dependências que não deveriam ser utilizadas no JRuby em produção. Usar extensões C no JRuby é tecnicamente possível mas não é uma boa ideia em termos de performance e estabilidade, e nós acreditamos que serviços de integração contínua com o Travis devem alertar sobre tal fato.

De modo que, caso queira executar integração contínua com JRuby, por favor certifique-se de que o seu Gemfile leva o JRuby em consideração. A maioria das extenções C mais populares também possuem implementações Java (json gem, nokogiri, eventmachine, bson gem) ou alternativas Java (como drivers JDBCpara MySQL, PostgreSQL, etc).

## Comando Padrão de Teste

Por padrão o Travis utilizará o [Bundler](http://gembundler.com/) para instalar as dependências do seu projeto e o `rake` para executar seus testes. Note que **você deve adicionar o rake no seu Gemfile** (adicioná-lo apenas no grupo `:test` deve ser o suficiente).

## Gerenciamento de Dependências

### Travis usa Bundler

O Travis usa o [Bundler](http://gembundler.com/) para instalar as dependências do seu projeto. É possível sobrescrever este comportamento e existem projetos que utilizam a funcionalidade de import do RVM gemset, mas a maioria dos projetos Ruby hospedados no Travis usam o Bundler.

### Exclua gems não-essenciais como ruby-debug do seu Gemfile

Nós pedimos que os mantedores de projetos Ruby evitem que o ruby-debug seja instalado no travis-ci.org. Considere o seguinte: um projeto que instale ruby-debug, realize testes em 6 versões/implementações diferentes do Ruby e receba 3 pushes por dia. Dado que o linecache, uma das dependências do ruby-debug, leva 2 minutos para instalar nas nossas máquians virtuais, isto resulta em

    3 * 6 * 2 = 36 minutos por dia por projeto

E, claro, ninguem realmente usa o ruby-debug em ambientes de integração contínua. Para excluir o ruby-debug e outras gems não essenciais para a sua suite de testes, mova-as para um grupo gem separado (por exemplo, :development) e [exclua-a usando *bundler_args* no seu .travis.yml](https://github.com/ruby-amqp/amqp/blob/master/.travis.yml#L2) da mesma forma que [amqp gem](https://github.com/ruby-amqp/amqp) faz.

O tempo é melhor gasto testando seu projeto em diversas versões/implementações de Ruby e em mais versões de bibliotecas que você depende do que compilando o linecache diversas vezes.

### Argumentos Customizados do Bundler e Localização do Gemfile

Você pode especificar um Gemfile com nome customizado:

    gemfile: gemfiles/Gemfile.ci

Caso não seja especificado, o processo trabalhador irá procurar por um arquivo chamado "Gemfile" na raiz do projeto.

Também é possível definir <a href="http://gembundler.com/man/bundle-install.1.html">argumentos extras</a> a serem passados ao `bundle install`:

    bundler_args: --binstubs

Você também pode definir um script para ser executado antes do 'bundle install':

    before_install: some_command

Por exemplo, para instalar e utilizar versão pré-release do bundler:

    before_install: gem install bundler --pre

### Testando com múltiplas versões de dependências (Ruby on Rails, EventMachine, etc)

Muitos projetos precisam ser testados com diversas versões do Rack, EventMachine, HAML, Sinatra, Ruby on Rails, etc. Isto é fácil com o Travis CI. Você precisa fazer o seguinte:

* Criar um diretório na raiz do seu repositório onde os arquivos gemfile serão armazenados (./gemfiles é um nome comumente usado)
* Adicionar um ou mais gemfiles a ele
* Instruir o Travis CI a utilizar estes gemfiles através da opção *gemfile* no seu .travis.yml

Por exemplo, a gem amqp é [testada nas versões 0.12.x e 1.0 do EventMachine](https://github.com/ruby-amqp/amqp/blob/master/.travis.yml):

    gemfile:
      - Gemfile
      - gemfiles/eventmachine-pre

O Paperclip é [testado com múltiplas versões do ActiveRecord](https://github.com/thoughtbot/paperclip/blob/master/.travis.yml):

    gemfile:
      - gemfiles/rails2.gemfile
      - gemfiles/rails3.gemfile
      - gemfiles/rails3_1.gemfile

Uma alternativa a este método é usar variáveis de ambiente e fazer o seu runner de testes utilizá-las. Por exemplo, o [Sinatra é testado em diversas versões do Tilt e Rack](https://github.com/sinatra/sinatra/blob/master/.travis.yml):

    env:
      - "rack=1.3.4"
      - "rack=master"
      - "tilt=1.3.3"
      - "tilt=master"

ChefSpec é [testando em diversas versões do Opscode Chef](https://github.com/acrmp/chefspec/blob/master/.travis.yml):

    env:
      - CHEF_VERSION=0.9.18
      - CHEF_VERSION=0.10.2
      - CHEF_VERSION=0.10.4

A mesma técnica é comumente utilizada para testar em diversos bancos de dados, engines de template, provedores de serviço, etc.


## Testando em Múltiplos JDKs (JRuby)

É possível testar os projetos em múltiplas versões de JDKs, especificamente

 * OpenJDK 7
 * Oracle JDK 7
 * OpenJDK 6

Para fazer isto, use a chave `:jdk` no seu `.travis.yml`. Por exemplo:

    jdk:
      - oraclejdk7
      - openjdk7

ou todos os 3:

    jdk:
      - openjdk7
      - oraclejdk7
      - openjdk6

Cada JDK que você utiliza para testes criará permutações com todas as outras configurações. Para evitar executar os testes para, por exemplo, CRuby 1.9.3 diversas vezes você deve adicionar algumas exclusões de matriz (descritas no [guia de configuração de build](/pt_BR/docs/user/build-configuration/)):

    language: ruby
    rvm:
      - 1.9.2
      - jruby-18mode
      - jruby-19mode
      - jruby-head
    jdk:
      - openjdk6
      - openjdk7
      - oraclejdk7
    matrix:
      exclude:
    - rvm: 1.9.2
      jdk: openjdk7
    - rvm: 1.9.2
      jdk: oraclejdk7


Para um exemplo, veja [travis-support](https://github.com/travis-ci/travis-support/blob/master/.travis.yml).


## Atualizando RubyGems

O travis-ci.org fornece as mesmas versões do rubygems RVM e várias versões/implementações do Ruby que vêm junto. Se a REE 2011.12 vem com a versão `1.8.9`, ela será `1.8.9` no travis-ci.org. Contudo, se o seu projeto ou alguma de suas dependências precisa de uma versão mais recente do rubygems, você pode atualizá-lo utilizando

    before_install:
      - gem update --system
      - gem --version