---
title: Construindo um Projeto Perl
layout: pt-BR
permalink: perl/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos Perl. Por favor leia o nosso [Guia de Início](/pt_BR/docs/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.

## Escolhendo as versões de Perl para Executar os Testes

Os processos workers no travis-ci.org usam o [Perlbrew](http://perlbrew.pl/) para oferecer diversas versões de Perl para os projetos. Para especificá-las, use a chave `perl:`no seu arquivo `.travis.yml`, por exemplo:

    language: perl
    perl:
      - "5.16"
      - "5.14"

Um exemplo mais extensivo:

    language: perl
    perl:
      - "5.16"
      - "5.14"
      - "5.12"
      - "5.10"

Com o tempo, novas versões são liberadas e nós atualizamos tanto o Perlbrew quanto o Perl. Apelidos como `5.14` são alterados para apontar para versões exatas, níveis de patch, etc.
Para uma lista completa e atualizada das versões de Perl disponíveis, veja o nosso guia [Ambiente de Integração Contínua](/pt-BR/docs/user/ci-environment/).

### Versões Anteriores à 5.10 não são Fornecidas

Versões do Perl anteriores à 5.10 não são e não serão fornecidas. Por favor não as inclua no seu `.travis.yml`.


## Versão Padrão do Perl

Se você não incluir a chave `perl` no seu `.travis.yml`, o Travis CI utilizará a versão 5.14.

## Script Padrão de Teste

### Module::Build

Se o seu repositório possuir um arquivo Build.PL na raiz, ele será utilizado para gerar o script de build:

    perl Build.PL && ./Build test

### EUMM

Se o seu repositório possuir um arquivo Makefile.PL na raiz, ele será utilizado:

    perl Makefile.PL && make test

Se nem os arquivos de build do Module::Build nem do EUMM forem encontrados, o Travis CI utilizará

    make test

É possível sobrescrever o comando de teste, conforme descrito no [guia de configuração de build](/pt_BR/docs/user/build-configuration/).


## Gerenciamento de Dependências

### O Travis CI usa cpanm

Por padrão o Travis CI usa o `cpanm` para gerenciar as dependências do seu projeto. É possível sobrescrever o comando de instalação de dependências conforme descrito no [guia de configuração de build](/pt_BR/docs/user/build-configuration/).

O comando padrão executado é

    cpanm --installdeps --notest .

### Ao Sobrescrever Comandos de Build, Não Utilize o sudo

Ao sobrescrever a chave `install:` para personalizar o comando de instalação (por exemplo, para executar o cpanm com a flag de verbose), não utilize o sudo. O ambiente do Travis CI tem o Perl insalado via Perlbrew em um diretório $HOME não privilegiado. Usar o sudo resultará na instalação das dependências em um local não esperado (para o construtor Perl do Travis CI) e elas não serão carregadas.


## Espelho Local CPAN

O Travis CI possui um espelho local do CPAN em [cpan.mirrors.travis-ci.org](http://cpan.mirrors.travis-ci.org/) e `PERL_CPANM_OPT` está configurado para utilizá-lo.


## Exemplos

* [leto/math--primality](https://github.com/leto/math--primality/blob/master/.travis.yml)
* [fxn/algorithm-combinatorics](https://github.com/fxn/algorithm-combinatorics/blob/master/.travis.yml)
* [fxn/net-fluidinfo](https://github.com/fxn/net-fluidinfo/blob/master/.travis.yml)
* [fxn/acme-pythonic](https://github.com/fxn/acme-pythonic/blob/master/.travis.yml)
* [judofyr/parallol](https://github.com/judofyr/parallol/blob/travis-ci/.travis.yml)
* [mjgardner/SVN-Tree](https://github.com/mjgardner/SVN-Tree/blob/master/.travis.yml)
* [mjgardner/svn-simple-hook](https://github.com/mjgardner/svn-simple-hook/blob/master/.travis.yml)
