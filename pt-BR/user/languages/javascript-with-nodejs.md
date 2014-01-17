---
title: Construindo um Projeto Node.js
layout: pt-BR
permalink: javascript-with-nodejs/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos Java. Por favor leia o nosso [Guia de Início](/pt_BR/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.

## Escolhendo as versões do Node para usar nos testes

Historicamente os projetos Node.js eram construindo usando os processos workers do Ruby, mas em Novembro de 2011 o suporte ao Node.js foi promovido à primeira classe: execução dos testes em múltiplas versões do Node.js em um conjunto separado de máquinas virtuais. Recomendamos que você as use para testar o seu projeto Node.js. Adicione o seguinte ao seu .travis.yml:

    language: node_js
    node_js:
      - "0.11"
      - "0.10"
      - "0.8"
      - "0.6"

Isto fará o Travis executar os testes nas últimas releases (fornecidas pelos mantedores do Travis, não necessariamente as últimas disponíveis) das branches 0.6.x, 0.8.x, 0.10.x e 0.11.x.

0.10 é um apelido para "a mais recente release 0.10.x" e assim por diante. Note que usar versões exatas (por exemplo, 0.10.2) é altamente desencorajado porque quando as versões mudarem, o seu arquivo .travis.yml ficará velho e as coisas quebrarão.

Para um exemplo, veja [hook.io-amqp-listener .travis.yml](https://github.com/scottyapp/hook.io-amqp-listener/blob/master/.travis.yml).

## Versões Fornecidas do Node.js

* 0.10.x (última versão estável)
* 0.8.x
* 0.6.x
* 0.11.x (última versão de desenvolvimento, pode ser instável)
* 0.9.x (antiga versão de desenvolvimento, será marcada como deprecated logo)

Para uma lista completa e atualizada das versões do Node fornecidas, veja o nosso [Guia de Ambiente de Integração Contínua](/pt_BR/user/ci-environment/).

## Comando Padrão de Teste

Para projetos usando NPM, Travis CI executará

    npm test

para executar a suite de teste.

### Usando Vows

Você pode dizer ao npm como executar a sua suite de testes adicionando uma linha no package.json. Por exemplo, para testar utilizando Vows:

    "scripts": {
      "test": "vows --spec"
    },


### Usando Expresso

Para testar utilizando Expresso:

    "scripts": {
      "test": "expresso test/*"
    },

Manter a configuração do script de teste no package.json faz com que seja fácil para outras pessoas colaborarem com o seu projeto, pois tudo que precisam lembrar é da convenção `npm test`.

## Gerenciamento de Dependências

### Travis usa NPM

O Travis usa o [NPM](http://npmjs.org/) para instalar as dependências do seu projeto. É possível alterar este comportamento, e existem projetos que usam ferramentas diferentes, mas a maioria dos projetos Node.js hospedados no Travis usam NPM, que acompanha o Node a partir a versão 0.6.0.

Por padrão o Travis CI executará

    npm install

para instalar as dependências. Note que a instalação de dependências no ambiente do Travis CI sempre acontece do começo (não existem pacotes NPM instalados no início do seu build).

## Meteor Apps

Você pode construir o seu **Meteor Apps** no Travis e testar utilizando [`laika`](http://arunoda.github.io/laika/). 
Simplesmente adicione o seguinte ao arquivo `.travis.yml` na raiz do seu projeto.

    language: node_js
    node_js:
      - "0.10"
    before_install:
      - "curl -L http://git.io/3l-rRA | /bin/sh"
    services:
      - mongodb
    env: 
      - LAIKA_OPTIONS="-t 5000"
      
Código fonte relacionado pode ser encontrado [aqui](https://github.com/arunoda/travis-ci-laika)

## Meteor Packages

Também é possível construir o seu **Meteor Packages** no Travis extendendo a configuração do NodeJS.

Por exemplo, você pode utilizar o seguinte ao seu arquivo `.travis.yml`.

    language: node_js
    node_js:
      - "0.10"
    before_install:
      - "curl -L http://git.io/ejPSng | /bin/sh"

O script `before_install` garantirá que as dependências necessárias estão instaladas.

O código fonte relacionado pode ser encontrado no repositório [travis-ci-meteor-packages](https://github.com/arunoda/travis-ci-meteor-packages).
