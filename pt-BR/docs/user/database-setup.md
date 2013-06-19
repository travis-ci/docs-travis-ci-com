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
* SQLite3
* MongoDB
* CouchDB
* Redis
* Riak
* Memcached

Todos os bancos de dados supracidatos usam, em sua maioria, as configurações padrão. Contudo, quando faz sentido, novos usuários são adicionados e configurações de segurança são relaxadas (porque para a integração contínua a facilidade de uso é importante). Um exemplo de tal adaptação é o PostgreSQL, que possui configurações de acesso padrão restritas.

## Configure seus Projetos para utilizar Bancos de Dados nos Testes

Aqui mostra-se como configurar o seu projeto para utilizar banco de dados nos testes. Assume-se que você já leu a documentação sobre a [Configuração de Build](/pt-BR/docs/user/build-configuration/).

### MySQL

O MySQL no Travis CI é acessível via 127.0.0.1 e requer autenticação. É possível conectar-se utilizando o usuário "root" com uma senha em branco.

Caso especifique um usuário em branco, lembre-se de que para alguns clientes isto significa "root", mas que para outros significa "usuário anônimo". Em dúvida, tente trocar para o usuário `root`.

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

O PostgreSQL é acessível via 127.0.0.1 e requer autenticação através do usuário "postgres" sem senha.

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

O MongoDB é acessível via 127.0.0.1, usa as configurações padrão e não necessita de autenticação ou criação de uma base de dados.

Caso necessite criar usuários para o seu banco de dados, você pode fazê-lo usando o `before_script` no seu arquivo `.travis.yml`:

    # .travis.yml
    before_script:
      - mongo mydb_test --eval 'db.addUser("travis", "test");'

#### Projetos baseados na JVM

Para projetos JVM que usam o driver oficial do MongoDB para Java, você precisará utilizar `127.0.0.1` ao invés de `localhost` para conectar, de forma a contornar um [problema conhecido com o driver Java do MongoDB](https://jira.mongodb.org/browse/JAVA-249) que afeta o Linux.

### CouchDB

O CouchDB é acessível via 127.0.0.1, usa as configurações padrão e não necessita de autenticação (ele é executado como admin).

Você deve criar o seu banco de dados como parte do processo de build:

    # .travis.yml
    before_script:
      - curl -X PUT localhost:5984/myapp_test

### Riak

O Riak utiliza as configurações padrão com uma exceção: é configurado para usar o [LevelDB storage backend](http://wiki.basho.com/LevelDB.html).

### Redis

O Redis usa as configurações padrão e é acessível no localhost.

### Neo4J

O servidor Neo4J Community Edition esta disponível mas não é iniciado por padrão. Você pode iniciá-lo usando o `before_install`:

    before_install:
      - which neo4j && sudo neo4j start
      - sleep 3

O servidor Neo4J usa as configurações padrão (localhost, porta 7474).


### Múltiplos Bancos de Dados

Caso os testes do seu projeto necessitem executar utilizando diversos bancos de dados, é possível configurar este comportamento no Travis CI de diversas maneiras.

#### Usando variáveis ENV

Neste caso você utiliza a variável "DB" para especificar o nome do banco de dados que quer utilizar. Localmente, você faria o seguinte:

    $ DB=postgres [comandos para executar os seus testes]

Para testar utilizando 3 bancos de dados no Travis CI, você pode utilizar a opção "env":

    # .travis.yml
    env:
      - DB=sqlite
      - DB=mysql
      - DB=postgres

Ao fazer isto, por favor leia e entenda tudo sobre a matriz de build descrita no guia de [Configuração de Build](/pt-BR/docs/user/build-configuration/).

#### Ruby

Uma abordagem que você pode serguir é colocar todas as configurações de bancos de dados em um arquivo YAML, como o ActiveRecord faz:

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