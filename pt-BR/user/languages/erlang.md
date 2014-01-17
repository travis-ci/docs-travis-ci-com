---
title: Construindo um Projeto Erlang
layout: pt-BR
permalink: erlang/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos Erlang. Por favor leia o nosso [Guia de Início](/pt_BR/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.


## Escolhendo as Releases OTP para Executar os Testes

As máquinas virtuais do Travis fornecem versões de 64 bits do [Erlang OTP](http://www.erlang.org/download.html), de releases R14B04, R14B03 e R14B02 construídas utilizando [kerl](https://github.com/spawngrid/kerl/tree/). Para especificar as releases OTP que você quer utilizar para testar ao seu projeto, use a chave `otp_release`:

    language: erlang
    otp_release:
       - R16B
       - R15B03
       - R15B02
       - R15B01
       - R15B
       - R14B04
       - R14B03
       - R14B02

## Script Padrão de Teste

O Travis CI assume que o seu projeto é construído com o [Rebar](https://github.com/basho/rebar) e usa EUnit. O comando que o construtor Erlang usa por padrão é

    rebar compile && rebar skip_deps=true eunit

se o seu projeto tem os arquivos `rebar.config` ou `Rebar.config` na raiz do seu repositório. Se esse não for o caso, o construtor Erlang utilizará

    make test

## Gerenciamento de Dependências

Como o construtor Erlang no travis-ci.org assume o uso do [Rebar](https://github.com/basho/rebar), ele utiliza

    rebar get-deps

para instalar [as dependências do projeto como listadas no arquivo rebar.config](https://github.com/basho/riak/blob/master/rebar.config).


## Exemplos

* [elixir](https://github.com/elixir-lang/elixir/blob/master/.travis.yml)
* [mochiweb](https://github.com/mochi/mochiweb/blob/master/.travis.yml)
* [ibrowse](https://github.com/cmullaparthi/ibrowse/blob/master/.travis.yml)

## Tutoriais
* [(Inglês) Continuous Integration for Erlang With Travis-CI](http://blog.equanimity.nl/blog/2013/06/04/continuous-integration-for-erlang-with-travis-ci/)
* [(Holandês) Geautomatiseerd testen with Erlang en Travis-CI](http://blog.equanimity.nl/blog/2013/04/25/geautomatiseerd-testen-met-erlang/)
