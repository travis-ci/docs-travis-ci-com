---
title: Construindo um Projeto C++
layout: pt-BR
permalink: cpp/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos C++. Por favor leia o nosso [Guia de Início](/pt_BR/docs/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.


## Ambiente de Integração Contínua para Projetos C++

As máquinas virtuais do Travis são de 32 bits e oferecem

 * gcc 4.6
 * clang 3.1
 * core GNU build toolchain (autotools, make), cmake, scons

Projetos C++ no travis.ci.org assumem que você utiliza Autotools e Make.

Como um serviço gratuito para a comunidade, o Travis CI limita a duração do build em cerca de 20 minutos. Como alguns projetos C++ grandes podem demorar muito para concluir seu build,
por favor cuide para não tomar muito tempo dos processos workers. Se o seu projeto demora mais que 10-15 minutos, contacte-nos na lista de discussão
antes de adicionar seu projeto ao Travis.


## Gerenciamento de Dependências

Por não haver uma convenção dominante na comunidade sobre gerenciamento de dependências, o Travis CI não realiza a instalação de dependências para projetos C++.

Caso necessite realizar tarefas antes de executar os testes, sobrescreva a chave `install:` no seu `.travis.yml`:

    install: make get-deps

Veja o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) para aprender mais.



## Script Padrão de Teste

Como projetos C no travis-ci.org assumem o uso de Autotools e Make, naturalmente, os comandos padrão utilizados pelo Travis CI para 
executar a suite de testes do seu projeto é

    ./configure && make && make test

Projetos que achem esses passos suficientes podem utilizar um arquivo .travis.yml bastante minimalístico:

    language: cpp

É possível sobrescrever este comportamente, conforme descrito no [guia de configuração de build](/pt_BR/docs/user/build-configuration/). Por exemplo, para executar o build
utilizando o Scons sem argumentos, sobrescreva a chave `script:` no `.travis.yml` para:

    script: scons


## Escolhendo os compiladores a utilizar

É possível testar os projetos utilizando GCC ou Clang, bem como os dois. Para fazê-lo, especifique o compilador utilizando a chave `compiler:` 
no `.travis.yml`. Por exemplo, para executar o build com Clang:

    compiler: clang

ou ambos GCC e Clang:

    compiler:
      - clang
      - gcc

Testar utilizando dois compiladores irá criar (ao menos) 2 colunas na matriz de build. Para cada coluna, o builder do Travis CI exportará a variável de ambiente `CXX` apontando para `g++` ou `clang++` e a variável de ambiente `CC` para `gcc` ou `clang`.


## Exemplos

 * [Rubinius](https://github.com/rubinius/rubinius/blob/master/.travis.yml)
