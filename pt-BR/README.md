# Sobre este repositório #

Esta é a tradução para português da documentação do Travis (http://about.travis-ci.org)

## Como contribuir

Faça fork do repositório, leia o resto deste arquivo e faça suas alterações. 
Quando você tiver terminado, mande um pull request. Obrigado!

## Como editar o site

Certifique-se que você possui o Ruby e RubyGems instalados. Em seguida instale o
[bundler](http://gembundler.com/):

    gem install bundler

Então instale as dependências:

    bundle install --binstubs

Para executar um servidor web local que irá rodar o site de documentação, use:

    ./bin/jekyll serve

e abra o endereço [localhost:4000](http://localhost:4000/) no seu navegador.

Para regenerar os arquivos HTML automaticamente quando você alterar os arquivos Markdown, use:

    ./bin/jekyll serve --watch

Observe que quoted entities podem ser escapadas ou não dependendo da versão do Ruby (1.8 vs. 1.9). Isso é normal.

## Jargão da tradução

Quando você estiver traduzindo o Travis, lembre-se:

* Job: trabalho
* Queue: fila
* Worker: processo
* Matrix: matriz
* Build: build

## Licença

Distribuído sob licença MIT, a mesma dos outros projetos Travis CI.
