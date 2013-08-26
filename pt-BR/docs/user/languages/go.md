---
title: Construindo um Projeto Go
layout: pt-BR
permalink: go/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos Go. Por favor leia o nosso [Guia de Início](/pt_BR/docs/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.

## Ambiente de Integração Contínua para Projetos Go

As máquinas virtuais do Travis são de 64 bits e oferecem

 * qualquer versão do Go (via gvm)
 * core GNU build toolchain (autotools, make), cmake, scons

Projetos Go no travis-ci.org assumem o uso do Make ou da ferramenta de build do Go.

## Especificando a versão de Go a utilizar

O Travis CI usa o gvm, então você pode utilizar qualquer versão disponível do Go, ou utilizar `tip` para obter a versão mais recente.

    language: go
    
    go:
      - 1.0
      - 1.1
      - tip

## Gerenciamento de Dependências

Por não haver uma [convenção dominante na comunidade sobre gerenciamento de dependências](https://groups.google.com/forum/?fromgroups#!topic/golang-nuts/t01qsI40ms4), o Travis CI usa

    go get -d -v ./... && go build -v ./...

para construir projetos Go e suas dependências.

Caso necessite realizar tarefas antes de executar os testes, sobrescreva a chave `install:` no seu `.travis.yml`:

    install: make get-deps

Também é possível especificar uma lista de operações, por exemplo, para `go get` dependências remotas: 

    install:
      - go get github.com/bmizerany/assert
      - go get github.com/mrb/hob

Veja o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) para aprender mais.



## Script Padrão de Teste

Projetos Go no travis-ci.org assumem o uso do Make ou da ferramenta de build do Go. Caso exista um Makefile na raiz do repositório, o comando padrão que o Travis CI utilizará para executar a suite de testes é

    make

Caso não exista nenhum Makefile, 

    go test -v ./...

será utilizado.

Projetos que achem esses passos suficientes podem utilizar um arquivo .travis.yml bastante minimalístico:

    language: go

É possível sobrescrever este comportamento, conforme descrito no [guia de configuração de build](/pt_BR/docs/user/build-configuration/). Por exemplo, para omitir a flag `-v`, sobrescreva a chave `script:` em `.travis.yml` deste modo:

    script: go test ./...

Para construir utilizando o Scons sem parâmetros, utilize:

    script: scons


## Exemplos

 * [peterbourgon/diskv](https://github.com/peterbourgon/diskv/blob/master/.travis.yml)
 * [Go AMQP client](https://github.com/streadway/amqp/blob/master/.travis.yml)
 * [mrb/hob](https://github.com/mrb/hob/blob/master/.travis.yml)
 * [globocom/tsuru](https://github.com/globocom/tsuru/blob/master/.travis.yml)