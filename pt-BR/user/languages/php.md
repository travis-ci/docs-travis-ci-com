---
title: Construindo um Projeto PHP
layout: pt-BR
permalink: php/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos PHP. Por favor leia o nosso [Guia de Início](/pt_BR/docs/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.

## Escolhendo as versões do PHP para Executar os Testes

As máquinas virtuais do travis-ci.org fornecem diversas versões do PHP incluindo o XDebug e PHPUnit. O Travis utiliza o [phpenv](https://github.com/CHH/phpenv) para gerenciar as diversas versões de PHP instaladas nas máquinas virtuais. Um arquivo .travis.yml minimalístico ficaria assim:

    language: php
    php:
      - 5.5
      - 5.4

Isto fará com que o Travis execute seus testes com

    phpunit

por padrão, utilizando as últimas versões 5.4.x e 5.5.x. 5.4 e 5.5 são apelidos para "a mais recente versão x.y.z" de uma determinada linha. Note que "a mais recente" significa "as mais recentes fornecidas pelos mantedores do Travis", não necessariamente as últimas versões oficiais disponíveis no php.net. Para uma listagem completa das versões suportadas, veja [Ambiente de Integração Contínua](/pt-BR/docs/user/ci-environment/).

Note ainda que especificar versões exatas como 5.3.8 não é recomendado, visto que seu arquivo .travis.yml pode ficar desatualizado e quebrar o build quando nós atualizarmos as versões do PHP no Travis.

Para um exemplo, veja [travis-ci-php-example .travis.yml](https://github.com/travis-ci/travis-ci-php-example/blob/master/.travis.yml).

## Script Padrão de Teste

### PHPUnit

Por padrão o Travis executará seus testes utilizando

    phpunit

para cada versão do PHP que você especificar.

Caso o seu projeto utilize algo diferente do PHPUnit, você pode sobrescrever o comando padrão de testes para o que for necessário, conforme descrito no [guia de configuração de build](/pt_BR/docs/user/build-configuration/).

### Trabalhando com atoum

Ao invés do PHPUnit, você também pode utilizar o [atoum](https://github.com/atoum/atoum) para testar ses projetos. Por exemplo:

    before_script: wget http://downloads.atoum.org/nightly/mageekguy.atoum.phar
    script: php mageekguy.atoum.phar

## Gerenciamento de Dependências (a.k.a. vendoring)

Antes que o Travis possa executar sua suite de testes, pode ser necessário obter as dependências do seu projeto. Isto pode ser feito utilizando um script PHP, um shell script ou qualquer outra coisa que você precisar. Defina um ou mais comandos que você quer que o Travis use com a opção *before_script* do seu arquivo .travis.yml. Por exemplo:

    before_script: php vendor/vendors.php

ou, caso precise executar múltiplos comandos sequencialmente:

    before_script:
      - ./bin/ci/install_dependencies.sh
      - php vendor/vendors.php

As dependências instaladas serão apagadas entre os builds (utilizamos snapshots das máquinas virtuais que executam os testes). Por favor seja razoável em quanto tempo e banda de rede você utiliza para instalá-las.

### Testando com Múltiplas Versões de Dependências (ex. Symfony)

Caso você precise testar com diversas versões de, por exemplo Symfony, você pode instruir o Travis a realizar múltiplas execuções com um conjunto diferente de variáveis de ambiente. Use a chave *env* no seu arquivo .travis.yml. Por exemplo:

    env:
      - SYMFONY_VERSION="2.0.*" DB=mysql
      - SYMFONY_VERSION="dev-master" DB=mysql

e então utilize os valores da variável de ambiente ENV nos seus scripts de instalação de dependências, casos de teste ou parâmetros do script de testes.

Segue abaixo um exemplo sobre como utilizar a variável ENV para modificar as dependências utilizando o gerenciador de pacotes composer de forma a executar os testes em duas versões do Symfony.

    before_script:
       - composer require symfony/framework-bundle:${SYMFONY_VERSION}

Aqui usamos o valor da variável DB para selecionar o arquivo de configuração do phpunit:

    script: phpunit --configuration $DB.phpunit.xml

A mesma técnica é utilizada para testar o projeto em diversos bancos de dados.

Para exemplos reais, veja:

* [FOSRest](https://github.com/FriendsOfSymfony/FOSRest/blob/master/.travis.yml)
* [LiipHyphenatorBundle](https://github.com/liip/LiipHyphenatorBundle/blob/master/.travis.yml)
* [doctrine2](https://github.com/doctrine/doctrine2/blob/master/.travis.yml)

### Instalando pacotes PEAR

Caso suas dependências incluam pacotes PEAR, o ambiente PHP do Travis possui os comandos [Pyrus](http://pear2.php.net/) e [pear](http://pear.php.net/):

    pyrus install http://phptal.org/latest.tar.gz
    pear install pear/PHP_CodeSniffer

Após a instalação, você deve atualizar o seu path

    phpenv rehash

Então, caso você queira, por exemplo, utilizar o phpcs, é necessário executar:

    pyrus install pear/PHP_CodeSniffer
    phpenv rehash

Após isso você poderá utilizar o phpcs como um comando phpunit

### Instalando pacotes Composer

Também é possível instalar pacotes [Composer](http://packagist.org/) no ambiente PHP do Travis. O comando composer já vem pré-instalado, por isso utilize apenas:

    composer install

Para garantir que tudo funcione, utilize as URLs http(s) do [Packagist](http://packagist.org/), e não URLs git.

## Instalação do PHP

As opções de configuração padrão utilizadas para compilar as versões do PHP usadas no Travis podem ser vistas [aqui](https://github.com/travis-ci/travis-cookbooks/blob/master/ci_environment/phpbuild/templates/default/default_configure_options.erb). Este link lhe dará uma visão geral da instalação do PHP usada no Travis.

Note, contudo, as seguintes diferenças entre as versões de PHP disponíveis no Travis:

* Para versões do PHP não mantidas que nós oferecemos (5.2.x, 5.3.3), a extensão OpenSSL está desativada devido a [problemas de compilação com OpenSSL 1.0](http://about.travis-ci.org/blog/upcoming_ubuntu_11_10_migration/). As releases recentes das versões PHP 5.3.x e 5.4.x que nós fornecemos possuem suporte à extensão OpenSSL.
* Pyrus não está disponível para o PHP 5.2.x.
* SAPIs diferentes:

  * 5.2.x e 5.3.3 possuem php-cgi apenas.
  * 5.3.x (última versão no branch 5.3) possui php-fpm apenas (veja este [issue](https://bugs.php.net/bug.php?id=53271:)).
  * 5.4.x e 5.5.x possuem php-cgi *e* php-fpm.

## Configuração Personalizada do PHP

A maneira mais simples de customizar a configuração do PHP é usar `phpenv config-add` para adicionar um arquivo de configuração customizado com as suas diretrizes de configuração:

    before_script: phpenv config-add myconfig.ini

E no myconfig.ini:

    extension = "mongo.so"
    date.timezone = "Europe/Paris"
    default_socket_timeout = 120
    # outras configurações...

Você também pode utilizar este comando:

    echo 'date.timezone = "Europe/Paris"' >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

## Extensões do PHP

### Core extensions

Veja [default configure options](https://github.com/travis-ci/travis-cookbooks/blob/master/ci_environment/phpbuild/templates/default/default_configure_options.erb) para uma visão geral das core extensions ativas.

### Extensões PHP pré-instaladas

Existem algumas extensões comuns do PHP pré-instaladas com PECL no Travis:

* [apc.so](http://php.net/apc)
* [memcache.so](http://php.net/memcache)
* [memcached.so](http://php.net/memcached)
* [mongo.so](http://php.net/mongo)
* [amqp.so](http://php.net/amqp)
* [zmq.so](http://php.zero.mq/)
* [xdebug.so](http://xdebug.org)

Note que estas extensões não estão ativas por padrão, de modo que é necessário ativá-las adicionando uma linha  `extension="<extension>.so"` a um arquivo de configuração do PHP (para a versão corrente). A maneira mais fácil de fazer isto é utilizando o phpenv para adicionar um arquivo de configuração customizado que ative e configure a extensão:

    before_script: phpenv config-add myconfig.ini

E no myconfig.ini:

    extension="mongo.so"
    # outras configurações do mongo
    # ou configurações gerais...

Você também pode utilizar este comando:

    echo "extension = <extension>.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

### Instalando extensões adicionais do PHP

É possível instalar extensões PHP adicionais no ambiente Travis usando o [PECL](http://pecl.php.net/), mas elas precisam ser construídas utilizando a versão do PHP que está sendo utilizada para o teste. Este é um exemplo de como a extensão `memcache` pode ser instalada:

    pecl install <extension>

O PECL irá ativar a extensão automaticamente ao final da instalação. Caso queira configurar a sua extensão, use o comando `phpenv config-add` para adicionar um arquivo de configuração personalizado no seu before_script.

Também é possível realizar a instalação "manualmente", mas você terá que ativar a extensão manualmente após a instalação, utilizando `phpenv config-add` e um arquivo ini personalizado com esta linha de comando:

    echo "extension=<extension>.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

Veja também [full script using midgard2](https://github.com/bergie/midgardmvc_core/blob/master/tests/travis_midgard2.sh).

Caso necessite de uma versão específica de uma extensão pré-instalada, utilize a flag `-f`. Por exemplo:

    pecl install -f mongo-1.2.12


### Chef Cookbooks para PHP

Caso queira aprender os detalhes sobre como construir e fornecer múltiplas instalações do PHP, veja [php, phpenv and php-build Chef cookbooks](https://github.com/travis-ci/travis-cookbooks/tree/master/ci_environment).