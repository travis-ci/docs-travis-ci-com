---
title: Configurando o seu build no Travis CI com o .travis.yml
layout: pt-BR
permalink: build-configuration/
---

<div id="toc"></div>

### O Que Este Guia Cobre

Este guia aborda o ambiente de build e tópicos de configuração comuns a todos os projetos hospedados no travis-ci.org, independente de tecnologia. Recomendamos que você inicie com o [Guia de Início](/pt-BR/docs/user/getting-started/) e leia este guia inteiro antes de passar para as [notificações de build](/pt-BR/docs/user/notifications/) e os [guias específicos das linguagens](/docs)

## O arquivo .travis.yml: o que é e como é usado

O Travis CI usa um arquivo `.travis.yml` na raiz do seu repositório para aprender sobre o seu projeto e sobre como você quer que seus builds sejam executados. O `.travis.yml` pode ser minimalístico ou possuir muitas customizações. Alguns exemplos do tipo de informação que o arquivo `.travis.yml` pode ter:

* A linguagem de programação que o seu projeto usa
* Quais comandos ou scripts devem ser executados antes de cada build (por exemplo, para instalar as dependências do projeto)
* Qual comando é utilizado para executar a suite de testes
* Emails, salas do campfire e IRC para notificar sobre falhas nos builds

e assim por diante.

No mínimo, o Travis CI precisa saber qual construtor deve utilizar no seu projeto: Ruby, Clojure, PHP ou algo diferente. Para o resto, existem padrões razoáveis.

## Ciclo de Vida da Construção (Build)

Por padrão, os processos construtores (workers) executarão o build da seguinte maneira:

* Troca do ambiente de execução da linguagem (por exemplo, para Ruby 1.9.3 ou PHP 5.4)
* Clonar o repositório do projeto no GitHub
* Executar os scripts *before_install* (se existir)
* Entrar no diretório clonado e executar o comando de instalação das dependências (padrão específico para a linguagem do projeto)
* Executar os scripts *before_script* (se existir)
* Executar o script de teste (padrão específico para a linguagem do projeto). Ele deve retornar 0 em caso de sucesso e qualquer outro código em caso de falha.
* Executar os scripts *after_sucess/after_failure* (se existir)
* Executar os scripts *after_script* (se existir)

A saída de qualquer um desses comandos (exceto after_success, after_failure u after_scripts) indica se a construção (build) falhou ou passou. O **código de saída com "0" significa que o build passou; qualquer valor diferente é tratado como falha.**

O resultado do teste é exportado para `TRAVIS_TEST_RESULT`, que você pode usar em comandos executados no `after_script`.

Salvo os passos de clonar o repositório do projeto e entrar neste diretório, todos os passos anteriores podem ser ajustados no `.travis.yml`.

### O Travis CI Não Preserva Estado Entre Builds

O Travis CI usa snapshots de máquinas virtuais para garantir que nenhum estado seja deixado entre as construções. Caso você modifique o ambiente de integração contínua escrevendo algo em um banco de dados, criando arquivos ou instalando um pacote via apt, isto não afetará as construções subsequentes.

## Definição de comandos de build personalizados

### Visão Geral

O Travis CI executa todos os comandos via SSH em máquinas virtuais isoladas. Comandos que modificam o estado da sessão SSH são persistentes durante a construção.
Por exemplo, se você entra em um diretório (com `cd`), todos os comandos seguintes serão executados deste diretório. Isto pode ser utilizado para o bem (ex. construir seguidamente diversos subprojetos) ou pode afetar ferramentas como `rake` ou `mvn` que podem estar buscando por arquivos no diretório corrente.


### script

É possível especificar o comando principal de construção (build) a executar, ao invés de se utilizar o padrão

    script: "make it-rain"

O script pode ser qualquer executável; ele não precisa ser o `make`. O único requisito para o script é que ele **deve retornar 0 em caso de sucesso e qualquer outro valor em caso de falha na construção**. Ele também deve imprimir toda informação que seja importante no console, de forma que os resultados possam ser observados (em tempo real!) no website.

Caso queira executar um script local ao seu repositório, faça:

    script: ./script/ci/run_build.sh

Neste caso, o script deve ser executável (por exemplo, usando `chmod +x`) e deve conter uma linha de shebang válida (`/usr/bin/env sh`, `/usr/bin/env ruby`, `/usr/bin/env python` etc).


### before_script, after_script

Também é possível definir scripts a serem executados antes e depois do script principal:

    before_script: algum_comando
    after_script:  outro_comando

As duas opções suportam múltiplos scripts:

    before_script:
      - comando_before_1
      - comando_before_2
    after_script:
      - comando_after_1
      - comando_after_2

Esses scripts podem ser utilizados, por exemplo, para configurar bancos de dados ou outras tarefas de configuração do build. Para mais informação sobre a configuração de bancos de dados, veja o guia de [Configuração de Banco de Dados](/pt-BR/docs/user/database-setup/).

### install

Caso o seu projeto não utilize ferramentas de gerenciamento de dependências padrão, é possível sobrescrever o comando de instalação de dependências usando a opção `install`:

    install: ant install-deps

Como os outros script, o comando `install` pode ser qualquer coisa, desde que retorne 0 quando o comando for executado corretamente.

### before_install

Também é possível definir scripts a serem utilizados antes e após o script de instalação de dependências:

    before_install: algum_comando

Tanto a opção `before_install` quanto `after_install` suportam o uso de múltiplos scripts:

    before_install:
      - comando_before_1
      - comando_before_2

`before_install` é comumente utlizado para atualizar os repositórios git de submódulos e realizar tarefas semelhantes que devem ser executadas antes da instalação de dependências.	  

### Dependências Nativas

Caso o seu projeto tenha dependências nativas (por exemplo, libxml ou libffi) ou precise de ferramentas que o [Ambiente de CI Travis](/pt-BR/docs/user/ci-environment/) não forneça, você pode instalá-las via apt, e até mesmo utilizar repositórios de terceiros e PPAs. Para mais informações, veja as respectivas seções mais a frente neste guia.


### Atualizando Submódulos Git

Caso o seu projeto utilize submódulos Git, use a seguinte técnica para cloná-los antes da instalação de dependências:

    before_install:
      - git submodule update --init --recursive

Isto incluirá submódulos aninhados (submódulos de submódulos), caso existam.


### Use URLs Públicas Para Submódulos

Caso o seu projeto utilize submódulos Git, certifique-se de utilizar as URLs Git públicas. Por exemplo, ao invés de

    git@github.com:someuser/somelibrary.git

use

    git://github.com/someuser/somelibrary.git

Caso contrário, os construtores do Travis CI não conseguirão clonar o seu projeto pois não possuem a sua chave privada SSH.

## Escolha as versões do ambiente de execução (Ruby, PHP, Node.js, etc)

Um dos principais recursos do Travis é a facilidade em executar a sua suite de testes em múltiplos ambientes de execução e versões. Como o Travis não sabe quais ambientes e versões o seu projeto suporta, essas informações precisam ser especificados no seu arquivo `.travis.yml`. As opções utilizadas variam entre as linguagens. A lista a seguir são alguns exemplos básicos do **.travis.yml** para diversas linguagens:

### Clojure

Atualmente os projetos Clojure podem ser testados no Oracle JDK 7, OpenJDK 7 e OpenJDK 6. A principal ferramenta de build do Clojure, Leiningen, suporta a execução dos testes em diversas versões de Clojure:

* No Leiningen 1.x, via [lein-multi plugin](https://github.com/maravillas/lein-multi)
* No futuro Leiningen 2.0, via Leiningen Profiles

Caso você tenha interesse em testar em múltiplas versões de Clojure, apenas utilize estas funcionalidades do Leiningen que tudo funcionará sem nenhum suporte especial do Travis.

Aprenda mais no nosso [Guia de Projetos Clojure](/pt-BR/docs/user/languages/clojure/).

### Erlang

Projetos Erlando especificam as versões a utilizar nos testes através da chave `otp_release`:

    otp_release:
      - R14B03
      - R14B04
      - R15B01

Aprenda mais no [Guia de Projetos Erlang](/pt-BR/docs/user/languages/erlang/).

### Groovy

Atualmente os projetos Groovy podem ser testados no Oracle JDK 7, OpenJDK 7 e OpenJDK 6. Suporte para múltiplos JDKs será adicionado futuramente.

Aprenda mais no nosso [Guia para Projetos Groovy](/pt-BR/docs/user/languages/groovy/).

### Java

Atualmente os projetos Groovy podem ser testados no Oracle JDK 7, OpenJDK 7 e OpenJDK 6. Suporte para múltiplos JDKs será adicionado futuramente.

Aprenda mais no nosso [Guia para Projetos Java](/pt-BR/docs/user/languages/java/).


### Node.js

Projetos Node.js especificam as versões a serem utilizadas nos testes usando a chave `node_js`:

     node_js:
       - "0.4"
       - "0.6"

Aprenda mais no nosso [Guia para Projetos Node.js](/docs/user/languages/javascript-with-nodejs/).

### Perl

Projetos Perl especificam as versões a serem utilizadas nos testes usando a chave `perl`:

    perl:
      - "5.14"
      - "5.12"

Aprenda mais no nosso [Guia para Projetos Perl](/pt-BR/docs/user/languages/perl/).

### PHP

Projetos PHP especificam as versões a serem utilizadas nos testes usando a chave `php`:

    php:
      - "5.4"
      - "5.3"

Aprenda mais no nosso [Guia para Projetos PHP](/pt-BR/docs/user/languages/php/).

### Python

Projetos Python especificam as versões a serem utilizadas nos testes usando a chave `python`:

    python:
      - "2.7"
      - "2.6"
      - "3.2"

Aprenda mais no nosso [Guia para Projetos Python](/pt-BR/docs/user/languages/python/).

### Ruby

Projetos Ruby especificam as versões a serem utilizadas nos testes usando a chave `rvm`:

    rvm:
      - "1.9.3"
      - "1.9.2"
      - jruby-19mode
      - rbx-19mode
      - jruby-18mode
      - "1.8.7"

Aprenda mais no nosso [Guia para Projetos Ruby](/pt-BR/docs/user/languages/ruby/).

### Scala

Projetos Scala especificam as versões a serem utilizadas nos testes usando a chave `scala`:

    scala:
      - "2.9.2"
      - "2.8.2"

O Travis CI depende do suporte do SBT para executar os testes em múltiplas versões do Scala.

Aprenda mais no nosso [Guia para Projetos Scala](/pt-BR/docs/user/languages/scala/).

## Definição de variáveis de ambiente

Para definir uma variável de ambiente:

    env: DB=postgres

Variáveis de ambiente são úteis para configurar scripts de build. Veja um exemplo no [Guia de Configuração de Banco de Dados](/pt-BR/docs/user/database-setup/#multiple-database-systems). A variável de ambiente `TRAVIS` sempre é definida durante os builds. Use-a para determinar se a sua suite de testes está executando no ambiente de integração contínua.

É possível especificar mais de uma variável de ambiente por item na lista `env`:

    rvm:
      - 1.9.3
      - rbx-18mode
    env:
      - FOO=foo BAR=bar
      - FOO=bar BAR=foo

Com esta configuração, **4 builds individuais** serão executados:

1. Ruby 1.9.3 com `FOO=foo` e `BAR=bar`
2. Ruby 1.9.3 com `FOO=bar` e `BAR=foo`
3. Rubinius no modo 1.8 com `FOO=foo` e `BAR=bar`
4. Rubinius no modo 1.8 com `FOO=bar` e `BAR=foo`

Note que os valores das variáveis de ambiente podem necessitar de escape. Por exemplo, caso elas tenham asterisco (`*`):

    env:
      - PACKAGE_VERSION="1.0.*"

## Instalando Pacotes Usando apt

Caso as suas dependências precisem de bibliotecas nativas, **você pode utilizar o sudo (sem senha) para instalá-las** com

    before_install:
     - sudo apt-get update -qq
     - sudo apt-get install -qq [packages list]

O motivo pelo qual o travis-ci.org pode utilizar o sudo sem senha é que as máquinas virtuais utilizadas para executar a suite de testes são restauradas ao seu estado original intocado após cada execução de build.

Note que a disponibilidade do sudo sem senha não significa que você precisa utilizar o sudo para a maioria das outras operações. Também não significa que os construtores do Travis CI executam operações como root.

### Usando PPAs de Terceiros

Caso precise de uma dependência nativa que não está disponível nos repositórios oficiais do Ubuntu, é possível que existam [PPAs de terceiros](https://launchpad.net/ubuntu/+ppas) (personal package archives) que você pode utilizar: eles devem fornecer pacotes para o Ubuntu 12.04 de 32 bits.

Veja mais sobre PPAs [neste artigo](http://www.makeuseof.com/tag/ubuntu-ppa-technology-explained/). Procure por [PPAs disponíveis no Launchpad](https://launchpad.net/ubuntu/+ppas).


## Timeout do Build

Como é muito comum ver suites de testes ou scripts pararem de responder ("travarem"), o Travis CI possui limites de tempo. Caso um script ou suite de testes demore muito a executar, o build será encerrado e você verá uma mensagem sobre o ocorrido no seu log de build.

Com os nossos tempos máximos de espera (timeouts) atuais, uma construção será terminada caso ainda esteja executando após 50 minutos (70 no travis-ci.com), ou se não existir qualquer registro nos logs em 10 minutos.

Alguns motivos comuns para uma suite de testes travar:

* Esperando por entrada no teclado ou algum tipo de interação humana
* Problemas de concorrência (deadlocks, livelocks, etc)
* Instalação de extensões nativas que podem demorar muito tempo para compilar

## Especificando os branches a construir

### O .travis.yml e múltiplos branches

O Travis irá sempre procurar pelo arquivo `.travis.yml` contido no branch especificado pelo commit git que o GitHub nos passa. A configuração em um branch não afetará a construção de outro branch. Além disso, o Travis CI executará o build após *qualquer* git push para o seu projeto GitHub, a menos que você o instrua a [pular um build](/pt-BR/docs/user/how-to-skip-a-build/). Você pode limitar este comportamente com opções de configuração.

### Adicionando branches na lista negra / branca

Você pode adicionar branches na lista negra (blacklist) ou lista branca (whilelist):

    # blacklist
    branches:
      except:
        - legacy
        - experimental

    # whitelist
    branches:
      only:
        - master
        - stable

Caso especifique ambos, o "except" será ignorado. Observe que atualmente (por motivos históricos), o `.travis.yml` deve estar presente *em todos os branches ativos* do seu projeto.

Note que o branch `gh-pages` não será construído, a menos que você adicione-o na lista branca (`branches.only`).

### Usando expressões regulares ###

É possível usar expressões regulares para adicionar branches nas listas negra/branca:

    branches:
      only:
        - master
        - /^deploy-.*$/

Qualquer nome entre `/` na lista de branches é tratado como uma expressão regular e pode conter todos os tipos de quantificadores, âncoras e classes de caracteres [suportados](http://www.ruby-doc.org/core-1.9.3/Regexp.html) pelo Ruby.

Opções que geralmente são especificadas após a última `/` (ex. `i` para comparação insensível à caixa alta/baixa) não são suportadas no momento.

## A Matriz de Build (Construção)

Quando você combina as três configurações principais acima, o Travis CI executará seus testes utilizando uma matriz de todas as combinações possíveis. As três dimensões da matriz são:

* Ambientes de execução a utilizar nos testes
* Variáveis de ambiente que você pode definir nos seus scripts de build
* Exclusões, inclusões e falhas permitidas

Segue abaixo uma configuração de exemplo para uma matriz de build bem grande, que gera **56 construções individuais**.

Por favor considere que o Travis CI é um serviço open source, e que nós dependemos de máquinas (workers) fornecidos pela comunidade. Por isso, especifique uma matriz de um tamanho que *você realmente precise*.

    rvm:
      - 1.8.7 # (padrão atual)
      - 1.9.2
      - 1.9.3
      - rbx-18mode
      - jruby
      - ruby-head
      - ree
    gemfile:
      - gemfiles/Gemfile.rails-2.3.x
      - gemfiles/Gemfile.rails-3.0.x
      - gemfiles/Gemfile.rails-3.1.x
      - gemfiles/Gemfile.rails-edge
    env:
      - ISOLATED=true
      - ISOLATED=false

Também é possível definir exclusões para a matriz de build:

    matrix:
      exclude:
        - rvm: 1.8.7
          gemfile: gemfiles/Gemfile.rails-2.3.x
          env: ISOLATED=true
        - rvm: jruby
          gemfile: gemfiles/Gemfile.rails-2.3.x
          env: ISOLATED=true

Apenas ocorrências exatas serão excluídas.

Também é possível incluir registros na matriz:

    matrix:
      include:
        - rvm: ruby-head
          gemfile: gemfiles/Gemfile.rails-3.2.x
          env: ISOLATED=false

Isto é útil caso, por exemplo, você queira apenas testar a última versão de uma dependência junto da última versão do ambiente de execução.

### Variáveis de ambiente

Algumas vezes você pode querer utilizar variáveis de ambiente que são globais para a matriz, isto é, que são inseridas em cada linha da matriz. Podem ser chaves, tokens, URIs ou outro dado que seja necessário em cada build. Nestes casos, ao invés de adicionar tais chaves em cada linha do `env` na matriz, você pode utilizar as chaves `global` e `matrix` para diferenciar entre os dois casos. Por exemplo:

    env:
      global:
        - CAMPFIRE_TOKEN=abc123
        - TIMEOUT=1000
      matrix:
        - USE_NETWORK=true
        - USE_NETWORK=false

Esta configuração gerará uma matriz com as seguintes linhas env:

    USE_NETWORK=true CAMPFIRE_TOKEN=abc123 TIMEOUT=1000
    USE_NETWORK=false CAMPFIRE_TOKEN=abc123 TIMEOUT=1000

### Variáveis de ambiente seguras

No exemplo anterior uma das variáveis de ambiente utilizada foi um token. Contudo, não é recomendado colocar seus tokens privados em um arquivo disponível publicamente. O Travis suporta a criptografia de variáveis de ambiente para lidar com este caso, mantendo a sua configuração pública enquanto mantem algumas partes privadas. Uma configuração com variáveis de ambiente seguras fica como a seguir:

    env:
      global:
        - secure: <string criptografada aqui>
        - TIMEOUT=1000
      matrix:
        - USE_NETWORK=true
        - USE_NETWORK=false
        - secure: <você também pode colocar variáveis criptografadas dentro da matriz>

Você pode criptografar variáveis de ambiente com a chave pública anexada ao seu repositório. A forma mais simples de fazer isto é usar a gem travis:

    gem install travis
    cd my_project
    travis encrypt MY_SECRET_ENV=super_segredo

Note que as variáveis de ambiente seguras não estão disponíveis para pull requests. Isto ocorre devido ao risco de segurança de expor tal informação em um código submetido. Qualquer pessoa pode submeter um pull request, e se uma variável descriptografada estiver disponível, ela poderia ser facilmente exibida.

Você também pode adicioná-la no seu `.travis.yml`:

    travis encrypt MY_SECRET_ENV=super_secret --add env.matrix

Para tornar o uso de variáveis de ambiente seguras mais fácil, nós expomos informações sobre sua disponibilidade e sobre o tipo do build:

* `TRAVIS_SECURE_ENV_VARS` é definido como "true" ou "false" dependendo da disponibilidade das variáveis de ambiente
* `TRAVIS_PULL_REQUEST`: Contém o número do pull request se a execução atual for de um pull request, e "false" se não for um pull request.

Note ainda que as chaves usadas para criptografar e descriptografar são amarradas ao repositório. Se você fizer o fork de um repositório e adicioná-lo ao travis, ele possuirá um par de chaves diferente do original.

### Linhas Que Podem Falhar

É possível definir linhas na matriz de build que podem falhar sem que isto faça com que a construção inteira seja marcada como uma falha. Isto é útil para você adicionar builds experimentais e preparatórios que possam testar versões ou configurações que ainda não possuem um suporte oficial do seu projeto.

As falhas permitidas devem ser uma lista de pares chave/valor representando os registros na sua matriz de build.

Você pode definir as falhas permitidas na matriz de build da seguinte forma:

    matrix:
      allow_failures:
        - rvm: 1.9.3
