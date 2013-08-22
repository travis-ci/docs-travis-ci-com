---
title: Imagens de Status
layout: pt-BR
permalink: status-images/
---

### O Que Este Guia Cobre

Este guia cobre a funcionalidade de imagens de status da construção (build) do Travis CI. Imagens de status são parte da API HTTP que renderiza informação sobre o build (sucesso ou falhando) como uma imagem PNG. Os desenvolvedore são encorajados a adicioná-las ao site do projeto, arquivos README, etc, tanto para fazer um link com a página de integração contínua do projeto quanto para demonstrar o seu comprometimento com as boas práticas de desenvolvimento de software.

Nós recomendamos que você leia o [Guia de Início](/pt-BR/docs/user/getting-started/) e [Configuração de Build](/pt-BR/docs/user/build-configuration/) antes de ler este guia.

## URLs das Imagens de Status

Após adicionar o seu projeto ao Travis, você pode utilizar os botões de status para exibir o estado atual dos seus projetos no seu arquivo `README` do GitHub ou no site do seu projeto.

    https://travis-ci.org/[SEU_USUARIO_GITHUB]/[NOME_DO_SEU_PROJETO].png

O HTTPS é utilizado para que o GitHub não armazene a imagem no cache.

## Adicionando Imagens de Status em Arquivos README

Utilizando Textile, mostrar o botão de estado (incluindo um link para a página do seu projeto no Travis) é tão simples quanto adicionar o seguinte no seu `README`:
    "!https://travis-ci.org/[SEU_USUARIO_GITHUB]/[NOME_DO_SEU_PROJETO].png!":http://travis-ci.org/[SEU_USUARIO_GITHUB]/[NOME_DO_SEU_PROJETO]

Ou, caso esteja utilizando markdown:

    [![Build Status](https://travis-ci.org/[SEU_USUARIO_GITHUB]/[NOME_DO_SEU_PROJETO].png)](http://travis-ci.org/[SEU_USUARIO_GITHUB]/[NOME_DO_SEU_PROJETO])

Ou RDoc:

    {<img src="https://travis-ci.org/[SEU_USUARIO_GITHUB]/[NOME_DO_SEU_PROJETO].png" />}[http://travis-ci.org/[SEU_USUARIO_GITHUB]/[NOME_DO_SEU_PROJETO]]

O botão de status do Travis CI aparece assim: [![Build Status](https://travis-ci.org/travis-ci/travis-ci.png)](http://travis-ci.org/travis-ci/travis-ci)

## Estado do Build de Branches Específicos

É possível limitar o impacto deste botão em apenas alguns branches. Por exemplo, você pode não querer incluir branches de novas funcionalidades, que podem falhar mas que não significa que o projeto em si falhou.

Especifique um parâmetro `?branch=` na URI. Caso precise especificar vários, separe os branches com uma vírgula.
    https://travis-ci.org/[SEU_USUARIO_GITHUB]/[NOME_DO_SEU_PROJETO].png?branch=master,staging,production
