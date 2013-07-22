---
title: Bancos de Dados no Travis
layout: pt-BR
permalink: database-setup/
---

### O Que Este Guia Cobre

Este guia cobre os armazenamentos de dados oferecidos no [Ambiente de Integração Contínua do Travis](/pt-BR/docs/user/ci-environment/) e descreve quais usuários e configurações os projetos hospedados no travis-ci.org podem utilizar. A maioria do conteúdo é aplicável a qualquer tecnologia, apesar de existirem alguns aspectos sutis no comportamento de alguns drivers de bancos de dados que este guia tentará cobrir. Recomendamos que você leia com os guias [Guia de Início](/pt-BR/docs/user/getting-started/) e [Configuração de Build](/pt-BR/docs/user/build-configuration/) antes de ler este guia.

## Armazenamenos de Dados no Ambiente Travis CI

[O Ambiente de Integração Contínua do Travis](/pt-BR/docs/user/ci-environment/) possui diversos bancos de dados populares pré-instalados. Alguns dos serviços disponíveis são:

* MySQL
* PostgreSQL
* MongoDB
* CouchDB
* Redis
* Riak
* RabbitMQ
* Memcached
* Cassandra
* Neo4J
* ElasticSearch
* Kestrel
* SQLite3

Todos os bancos de dados supracidatos usam, em sua maioria, as configurações padrão. Contudo, quando faz sentido, novos usuários são adicionados e configurações de segurança são relaxadas (porque para a integração contínua a facilidade de uso é importante). Um exemplo de tal adaptação é o PostgreSQL, que possui configurações de acesso padrão restritas.

## Configure seus Projetos para utilizar Bancos de Dados nos Testes

Aqui mostra-se como configurar o seu projeto para utilizar banco de dados nos testes. Assume-se que você já leu a documentação sobre a [Configuração de Build](/pt-BR/docs/user/build-configuration/).

### Habilitando os Serviços

A maioria dos serviços não é iniciada no boot, a fim de disponibilizar mais RAM para as suites de testes do seu projeto.

Caso o seu projeto precise, por exemplo, do MongoDB, você deve adicionar o seguinte ao seu `.travis.yml`:

    services: mongodb

Caso necessite de diversos serviços, utilize o seguinte:

    services:
      - riak     # iniciará o riak
      - rabbitmq # iniciará o rabbitmq-server
      - memcache # iniciará o memcached

Isto permite que nós forneçamos apelidos para cada serviço e normalizemos as diferenças de nomenclaturas, como RabbitMQ por exemplo. Note que esta funcionalidade está 
disponível apenas para serviços que nós oferecemos no nosso [Ambiente de Integração Contínua](http://about.travis-ci.org/pt-BR/docs/user/ci-environment/).
Caso você faça o download do Apache Jackrabbit, por exemplo, e inicie-o manualmente na etapa `before_install`, você deverá continuar fazendo da mesma maneira.

### MySQL

O MySQL no Travis CI é **iniciado no boot**, está acessível via 127.0.0.1 e requer autenticação. É possível conectar-se utilizando o usuário "root" com uma senha em branco.

É preciso criar o banco de dados `myapp_test`. Execute o seguinte como parte do seu script de build:

    # .travis.yml
    before_script:
      - mysql -e 'create database myapp_test;'

#### Exemplo de config/database.yml

`config/database.yml` exemplo para projetos Ruby usando ActiveRecord:

    mysql:
      adapter: mysql2
      database: myapp_test
      username: root
      encoding: utf8


### PostgreSQL

O PostgreSQL é **iniciado no boot**, está acessível via 127.0.0.1 e requer autenticação através do usuário "postgres" sem senha.

É preciso criar o banco de dados como parte do processo de build:

    # .travis.yml
    before_script:
      - psql -c 'create database myapp_test;' -U postgres

#### Exemplo de config/database.yml

`config/database.yml` exemplo para projetos Ruby usando ActiveRecord:

    postgres:
      adapter: postgresql
      database: myapp_test
      username: postgres



### SQLite3

Provavelmente é a solução mais fácil e simples para bancos de dados relacionais. Caso não necessite testar como o seu código se comporta com outros bancos de dados, o SQLite em memória pode ser a melhor opção.

#### Projetos Ruby

Para projetos ruby, certifique-se de que você possui os bindings sqlite3 no seu bundle:

    # Gemfile
    # para CRuby, Rubinius, inclusive Windows e RubyInstaller
    gem "sqlite3", :platform => [:ruby, :mswin, :mingw]

    # para JRuby
    gem "jdbc-sqlite3", :platform => :jruby

`config/database.yml` exemplo para projetos que utilizam ActiveRecord:

    test:
      adapter: sqlite3
      database: ":memory:"
      timeout: 500

Caso o seu projeto seja uma biblioteca ou plugin, você precisará gerenciar a conexão com o banco de dados você mesmo nos testes. Por exemplo, conectando com ActiveRecord:

    ActiveRecord::Base.establish_connection :adapter => 'sqlite3',
                                            :database => ':memory:'

### MongoDB

O MongoDB **não é iniciado no boot**. Para fazer com que o Travis CI inicie-o para você, adicione

    services:
      - mongodb

ao seu `.travis.yml`.

O MongoDB é acessível via 127.0.0.1, usa as configurações padrão e não necessita de autenticação ou criação de uma base de dados.

Caso necessite criar usuários para o seu banco de dados, você pode fazê-lo usando o `before_script` no seu arquivo `.travis.yml`:

    # .travis.yml
    before_script:
      - mongo mydb_test --eval 'db.addUser("travis", "test");'

#### Projetos baseados na JVM

Para projetos JVM que usam o driver oficial do MongoDB para Java, você precisará utilizar `127.0.0.1` ao invés de `localhost` para conectar, de forma a contornar um [problema conhecido com o driver Java do MongoDB](https://jira.mongodb.org/browse/JAVA-249) que afeta o Linux.
Note que este problema foi corrigido na versão 2.8.0 do cliente Java para MongoDB, de forma que ele apenas afeta projetos usando versões mais antigas.

### CouchDB

O CouchDB **não é iniciado no boot**. Para fazer com que o Travis CI inicie-o para você, adicione

    services:
      - couchdb

ao seu `.travis.yml`.

O CouchDB é acessível via 127.0.0.1, usa as configurações padrão e não necessita de autenticação (ele é executado como admin).

Você deve criar o seu banco de dados como parte do processo de build:

    # .travis.yml
    before_script:
      - curl -X PUT localhost:5984/myapp_test

### RabbitMQ

O RabbitMQ **não é iniciado no boot**. Para fazer com que o Travis CI inicie-o para você, adicione

    services:
      - rabbitmq

ao seu `.travis.yml`.

O RabbitMQ usa as configurações padrão, de forma que pode-se utilizar o vhost padrão (`/`), nome de usuário (`guest`) e senha (`guest`).
Você pode configurar mais vhosts e papéis utilizando o `before_script`, caso necessário (por exemplo, para testar a autenticação).

### Riak

O Riak **não é iniciado no boot**. Para fazer com que o Travis CI inicie-o para você, adicione

    services:
      - riak

ao seu `.travis.yml`.

O Riak utiliza as configurações padrão com uma exceção: é configurado para usar o [LevelDB storage backend](http://wiki.basho.com/LevelDB.html). A Riak Search está ativada.

### Memcached

O Memcached **não é iniciado no boot**. Para fazer com que o Travis CI inicie-o para você, adicione

    services:
      - memcached

ao seu `.travis.yml`.

O Memcached usa as configurações padrão e é acessível via localhost.

### Redis

O Redis **não é iniciado no boot**. Para fazer com que o Travis CI inicie-o para você, adicione

    services:
      - redis-server

ao seu `.travis.yml`.

O Redis usa as configurações padrão e é acessível no localhost.

### Cassandra

O Cassandra **não é iniciado no boot**. Para fazer com que o Travis CI inicie-o para você, adicione

    services:
      - cassandra

ao seu `.travis.yml`.

O Cassandra é fornecido via [Datastax Community Edition](http://www.datastax.com/products/community) e usa as configurações padrão (acessível no 127.0.0.1).

### Neo4J

O Neo4J Server (Community Edition) **não é iniciado no boot**. Para fazer com que o Travis CI inicie-o para você, adicione

    services:
      - neo4j

ao seu `.travis.yml`.

O servidor Neo4J usa as configurações padrão (localhost, porta 7474).

### ElasticSearch

O ElasticSearch **não é iniciado no boot**. Para fazer com que o Travis CI inicie-o para você, adicione

    services:
      - elasticsearch

ao seu `.travis.yml`.

O ElasticSearch é fornecido via pacote oficial do Debian e usa as configurações padrão (acessível no 127.0.0.1).

### Kestrel

O Kestrel **não é iniciado no boot**. Para fazer com que o Travis CI inicie-o para você, adicione

    services:
      - kestrel

ao seu `.travis.yml`.


### Múltiplos Bancos de Dados

Caso os testes do seu projeto necessitem executar diversas vezes, utilizando diversos bancos de dados, é possível configurar este comportamento no Travis CI usando
uma técnica com variáveis de ambiente. Esta técnica é apenas uma convenção e requer o `before_script` ou `before_install` para funcionar.



#### Usando variáveis ENV e etapas before_script

Neste caso você utiliza a variável "DB" para especificar o nome do banco de dados que quer utilizar. Localmente, você faria o seguinte:

    $ DB=postgres [comandos para executar os seus testes]

No Travis CI você quer criar uma matriz com três construções (builds), cada uma tendo a variável de ambiente `DB` exportada com um valor diferente. Para isto, você deve utilizar a opção "env":

    # .travis.yml
    env:
      - DB=sqlite
      - DB=mysql
      - DB=postgres

Com isso, você pode utilizr estes valores na etapa `before_install` (ou `before_script`) para configurar cada banco de dados. Por exemplo:

    before_script:
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'DROP DATABASE IF EXISTS doctrine_tests;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'DROP DATABASE IF EXISTS doctrine_tests_tmp;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'create database doctrine_tests;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'create database doctrine_tests_tmp;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'mysql' ]; then mysql -e 'create database IF NOT EXISTS doctrine_tests_tmp;create database IF NOT EXISTS doctrine_tests;'; fi"

Ao fazer isto, por favor leia e entenda tudo sobre a matriz de build descrita no guia de [Configuração de Build](/pt-BR/docs/user/build-configuration/).

Nota: ** O Travis CI não oferece nenhum suporte especial à estas variáveis**, ele simplesmente cria três construções com valores exportados diferentes.
A sua suite de testes ou as etapas `before_install`/`before_script` que devem fazer uso destes valores.

Para um exemplo real, veja [doctrine/doctrine2 .travis.yml](https://github.com/doctrine/doctrine2/blob/master/.travis.yml).

#### Uma Abordagem Específica para Ruby

Uma abordagem que você pode seguir é colocar todas as configurações de bancos de dados em um arquivo YAML, como o ActiveRecord faz:

    # test/database.yml
    sqlite:
      adapter: sqlite3
      database: ":memory:"
      timeout: 500
    mysql:
      adapter: mysql2
      database: myapp_test
      username:
      encoding: utf8
    postgres:
      adapter: postgresql
      database: myapp_test
      username: postgres

Na sua suite de testes, leia esses dados em um hash de configurações:

    configs = YAML.load_file('test/database.yml')
    ActiveRecord::Base.configurations = configs

    db_name = ENV['DB'] || 'sqlite'
    ActiveRecord::Base.establish_connection(db_name)
    ActiveRecord::Base.default_timezone = :utc


### Conclusão

O [Ambiente de Integração Contínua do Travis](/pt-BR/docs/user/ci-environment/) provê diversos bancos de dados open source que os projetos podem utilizar. Na maioria dos casos, esses bancos usam as configurações padrão. Quando este não é o caso, o propósito desta customização geralmente é minimizar o trabalho a ser realizado pelos desenvolvedores para utilizá-lo. Frequentemente, isto significa relaxar as configurações de segurança. o que é aceitável para um ambiente de integração contínua.