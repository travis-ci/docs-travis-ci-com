---
title: Acelerando o build
layout: pt-BR
permalink: speeding-up-the-build/
---

O Travis CI implementa algumas otimizações que podem ajudar a acelerar o seu build,
como sistema de arquivos em memória para os arquivos de banco de dados. Contudo, existe uma série
de coisas que podem ser feitas para melhorar ainda mais o tempo de construção.

## Paralelizando seus builds entre máquinas virtuais

Para acelerar uma suite de testes, você pode separá-la em diversas partes usando
a funcionalidade  de [matriz de build do Travis](/pt-BR/user/build-configuration/#A-Matriz-de-Build-(Constru%C3%A7%C3%A3o)).

Digamos que você quer separar seus testes unitários e testes de integração em dois jobs diferentes de construção.
Eles executarão em paralelo e utilizarão completamente a capacidade de construção disponível para a sua conta.

Um exemplo de como utilizar esta funcionalidade no seu .travis.yml:

    env:
      - TEST_SUITE=units
      - TEST_SUITE=integration

Mude, então, o seu comando script para usar a nova variável de ambiente para 
determinar qual script executar.

    script: "bundle exec rake test:$TEST_SUITE"

O Travis determinará a matriz de construção baseada nas variáveis de ambiente
e agendará a execução de dois builds.

O interessante desta configuração é que a suite de testes unitários normalmente
terminará primeiro que a suite de testes de integração, fornecendo um retorno
visual mais rápido sobre a cobertura de testes básicos.

Dependendo do tamanho e da complexidade da sua suite de testes, você pode separá-la ainda mais.
Você pode separar diferentes preocupações de testes de integração em diferentes subpastas e executá-las
em estágios separados de uma matriz de construção.
    env:
      - TESTFOLDER=integration/user
      - TESTFOLDER=integration/shopping_cart
      - TESTFOLDER=integration/payments
      - TESTFOLDER=units

Então você pode ajustar o comando script para executar o rspec para cada subpasta:

    script: "bundle exec rspec $TESTFOLDER"

Por exemplo, o projeto Rails usa a funcionalidade de matriz de build para criar jobs separados
para cada um dos bancos de dados utilizados nos testes, e também para separar os testes por
áreas. Um conjunto de testes é executado apenas para o railties, outro para actionpack, actionmailer,
activesupport, e muitos outros conjuntos para testar o activerecord com diversos bancos de dados.
Veja o [arquivo .travis.yml deles](https://github.com/rails/rails/blob/master/.travis.yml) para mais exemplos.

## Paralelizando seu build em uma VM

As máquinas virtuais do Travis CI executam em 1.5 núcleos virtuais. Isto não exatamente concorrência, que 
permite que você paralelize muito, mas pode fornecer um bom ganho dependendo do seu uso.

A paralelização da suite de testes na VM depende da linguagem e do executor de testes (test runner) que você
utiliza, de modo que você precisa pesquisar as suas opções. No Travis CI nós utilizamos principalmente
Ruby e RSpec, o que significa que podemos utilizar a gem [parallel_tests](https://github.com/grosser/parallel_tests).
Caso utilize Java, você pode utilizar uma funcionalidade existente [para executar testes em paralelo
usando JUnit](http://incodewetrustinc.blogspot.com/2009/07/run-your-junit-tests-in-parallel-with.html).

Para dar uma ideia do ganho possível, através da execução em paralelo dos testes do `travis-core`,
o tempo de execução diminuiu de cerca de 26 minutos para 19 minutos em 4 jobs.

## Armazenando as dependências

A instalação de dependências de um projeto pode levar um bom tempo para projetos maiores.
De forma a diminuir este tempo, você pode tentar armazenar as dependências no S3. Caso utilize Ruby
com Bundler veja [o ótimo projeto WAD](https://github.com/Fingertips/WAD). Para outras linguagens, 
você pode utilizar ferramentas do S3 para fazer upload e download das dependências.
