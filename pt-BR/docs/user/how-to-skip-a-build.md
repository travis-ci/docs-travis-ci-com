---
title: Como pular um build
layout: pt-BR
permalink: how-to-skip-a-build/
---

### O Que Este Guia Cobre

Este guia explica como fazer com que o travis-ci.org ignore (pule) uma construção, por exemplo, quando você está trabalhando na documentação ou com stylesheets. Nós recomendamos que você leia o [Guia de Início](/pt-BR/docs/user/getting-started/) e o [Guia de Configuração de Build](/pt-BR/docs/user/build-configuration/) antes de prosseguir.

## Nem Todos os Commits Precisam de Construções na IC

As vezes você apenas altera um arquivo README, alguma documentação ou outras coisas que não afetam a aplicação em si. Nestes casos, você gostaria de saber como evitar que o seu push inicie o processo de construção no Travis CI.

É fácil - apenas adicione a seguinte mensagem ao seu commit:

    [ci skip]

Pushs que possuam `[ci skip]` em qualquer uma das mensagens de commit serão ignorados. O `[ci skip]` não precisa aparecer na primeira linha, de modo que é possível utilizar este recurso sem poluir o histórico do seu projeto.

## Exemplo

Veja a seguir um exemplo:

![ci skip example](https://img.skitch.com/20111013-pu5e4gijiw4416m4y4uc29fxwa.jpg)
