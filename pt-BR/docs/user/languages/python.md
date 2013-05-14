---
title: Construindo um Projeto Python
layout: pt-BR
permalink: python/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos Python. Por favor leia o nosso [Guia de Início](/pt_BR/docs/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.

## Escolhendo as versões do Python para Executar os Testes

Os processos trabalhadores do travis-ci.org usam os repositórios padrão do Ubuntu/Debian mais [o PPA Dead Snakes](https://launchpad.net/~fkrull/+archive/deadsnakes) para fornecer diversas versões do Python que seus projetos podem utilizar. Para especificá-las, utilize a chave `python:` no seu arquivo `.travis.yml`. Por exemplo:

    language: python
    python:
      - "2.6"
      - "2.7"
      - "3.2"
      - "3.3"
    # comando para instalar dependências
    install: "pip install -r requirements.txt --use-mirrors"
    # comando para executar testes
    script: nosetests

Um exemplo mais completo:

    language: python
    python:
      - "2.5"
      - "2.6"
      - "2.7"
      - "3.2"
      - "3.3"
    # comando para instalar dependências
    install:
      - "pip install . --use-mirrors"
      - "pip install -r requirements.txt --use-mirrors"
    # comando para executar testes
    script: nosetests

Com o tempo, novas versões são liberadas e nós passamos a oferecer mais versões e/ou implementações do Python. Apelidos como `3.2` são alterados para apontar para versões exatas, níveis de patch, etc.
Para uma lista completa e atualizada das versões de Python disponíveis, veja o nosso guia [Ambiente de Integração Contínua](/pt-BR/docs/user/ci-environment/).

### O Travis CI usa virtualenvs Isolados

O [Ambiente de Integração Contínua](/pt-BR/docs/user/ci-environment/) utiliza instâncias virtualenv separadas para cada versão do Python. O Python do sistema não é utilizado e não deve-se depender dele. Caso precise instalar pacotes Python, o faça via pip e não via apt.

### Suporte PyPy

Nós oferecemos as versões estáveis mais recentes do PyPy via [PPA do Time PyPy](https://launchpad.net/~pypy/+archive/ppa). Para projetos puramente Python, ele funciona bem. Contudo, devido a problemas conhecidos com os cabeçalhos dos pacotes de desenvolvimento, bibliotecas nativas não instalarão no PyPy. Nós notificamos os mantedores de pacotes do PyPy bem como os desenvolvedores do core team sobre este problema e estamos aguardando que seja resolvido.

Para testar seu projeto utilizando PyPy, adicione "pypy" na lista de Pythons no seu `.travis.yml`:

    language: python
    python:
      - "2.5"
      - "2.6"
      - "2.7"
      - "3.2"
      - "3.3"
      # não possui headers, por favor peça em https://launchpad.net/~pypy/+archive/ppa
      # para os desenvolvedores corrigirem seu pacote pypy-dev.
      - "pypy"
    # comando para instalar dependências
    install:
      - pip install . --use-mirrors
      - pip install -r requirements.txt --use-mirrors
    # comando para executar testes
    script: nosetests 


## Versão Padrão do Python

Caso você não informe a chave `python` no seu `.travis.yml`, o Travis CI utilizará o Python 2.7.

## Especificando o Script de Teste

Projetos Python devem informar a chave `script` no seu `.travis.yml` para especificar o comando que executará os testes. Por exemplo, se o seu projeto é testado utilizando nosetests:

    # comando para executar os testes
    script: nosetests

se você precisa executar `make test`:

    script: make test

e assim por diante.

Caso a chave `script` não esteja presente no seu `.travis.yml`, o construtor Python imprimirá uma mensagem e o build falhará.

## Gerenciamento de Dependências

### Travis CI usa pip

Por padrão o Travis CI usa o `pip` para gerenciar as dependências do seu projeto. É possível (e comum) sobrescrever o comando de instalação de dependências conforme descrito no [guia de configuração de build](/pt_BR/docs/user/build-configuration/).

O comando padrão é

    pip install -r requirements.txt --use-mirrors

que é muito similar ao que o [Heroku build pack for Python](https://github.com/heroku/heroku-buildpack-python/) usa.

Nós recomendamos fortemente o uso de `--use-mirrors` caso você sobrescreva o comando de instalação de dependências, de forma a reduzir a carga no PyPI e de falhas na instalação.

### Pacotes Pré-Instalados

O Travis pré-instala alguns pacotes em cada virtualenv por padrão para facilitar a execução de testes:

- pytest
- nose
- mock

### Testando com Múltiplas Versões de Dependências (ex. Django ou Flask)

Caso necessite testar em diversas versões de, por exemplo Django, você pode instruir o Travis a realizar múltiplas versões com diferentes conjuntos de valores para variáveis de ambiente. Use a chave *env* no seu arquivo .travis.yml. Por exemplo:

    env:
      - DJANGO_VERSION=1.2.7
      - DJANGO_VERSION=1.3.1

e use os valores da variável ENV nos seus scripts de instalação de dependências, casos de teste ou parâmetros de scripts de testes. A seguir um exemplo do uso da variável de ambiente DB para instruir o pip a instalar uma determinada versão:

    install:
      - pip install -q Django==$DJANGO_VERSION
      - python setup.py -q install

A mesma técnica é frequentemente utilizada para testar projetos com diversos bancos de dados. Para um exemplo real, veja [getsentry/sentry](https://github.com/getsentry/sentry/blob/master/.travis.yml) e [jpvanhal/flask-split](https://github.com/jpvanhal/flask-split/blob/master/.travis.yml).

## Exemplos

* [facebook/tornado](https://github.com/facebook/tornado/blob/master/.travis.yml)
* [simplejson/simplejson](https://github.com/simplejson/simplejson/blob/master/.travis.yml)
* [fabric/fabric](http://github.com/fabric/fabric/blob/master/.travis.yml)
* [kennethreitz/requests](https://github.com/kennethreitz/requests/blob/master/.travis.yml)
* [dstufft/slumber](https://github.com/dstufft/slumber/blob/master/.travis.yml)
* [dreid/cotools](https://github.com/dreid/cotools/blob/master/.travis.yml)
* [MostAwesomeDude/klein](https://github.com/MostAwesomeDude/klein/blob/master/.travis.yml)
