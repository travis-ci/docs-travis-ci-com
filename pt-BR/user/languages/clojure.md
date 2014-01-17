---
title: Construindo um Projeto Clojure
layout: pt-BR
permalink: clojure/
---

### O Que Este Guia Cobre

Este guia cobre tópicos específicos ao ambiente de build e configuração de projetos Clojure. Por favor leia o nosso [Guia de Início](/pt_BR/user/getting-started/) e o [guia de configuração de build](/pt_BR/docs/user/build-configuration/) antes.

## Ambiente de Integração Contínua para Projetos Clojure

As máquinas virtuais Travis oferecem

* OpenJDK 7, OpenJDK 6, Oracle JDK 7 de 32 bits
* Standalone [Leiningen](http://leiningen.org) 1.7.x.
* Standalone [Leiningen 2.0.0](https://github.com/technomancy/leiningen/wiki/Upgrading) (novos previews são disponibilizados alguns dias após a liberação).
* Maven 3

Projetos Clojure no travis-ci.org assumem que você usa [Leiningen](https://github.com/technomancy/leiningen).

## Gerenciamento de Dependências

Com Leiningen, a etapa de instalação de dependências (`lein deps`) geralmente não é necessária. Apenas certifique-se de que todas as suas dependências estão listadas no `project.clj` e `lein test` e outras tarefas as instalarão automaticamente se necessário.

### Etapa Alternativa de Instalação

Caso precise realizar outras tarefas antes de executar os testes, você deve definir `:hooks` no project.clj. Se por algum motivo não for possível utilizar hooks, é possível sobrescrever a etapa de instalação no seu `.travis.yml`. Por exemplo, caso use a biblioteca [clojure-protobuf](https://github.com/flatland/clojure-protobuf):

    install: lein protobuf install

Veja o [guia de configuração de build](/pt_BR/user/build-configuration/) para aprender mais.



## Script de Teste Padrão

Como projetos Clojure no travis-ci.org assumem o uso do [Leiningen](https://github.com/technomancy/leiningen), o comando padrão utilizado pelo Travis CI para executar a suite de testes é

    lein test


Projetos que achem esses passos suficientes podem utilizar um arquivo .travis.yml bastante minimalístico:

    language: clojure

### Usando o Midje no travis-ci.org

Caso o seu projeto utilize o [Midje](https://github.com/marick/Midje), certifique-se de que o [lein-midje](https://github.com/marick/Midje/wiki/Lein-midje) aparece no seu `project.clj` na lista de dependências de desenvolvimento e sobrescreva `script:` no `.travis.yml` para executar a tarefa Midje:

    script: lein midje

Note que para projetos que suportam apenas Clojure 1.3.0 e anteriores, pode ser necessário excluir `org.clojure/clojure` para o Midje no project.clj:

    :dev-dependencies [[midje "1.4.0" :exclusions [org.clojure/clojure]]
                       [lein-midje "1.0.10"]])

Para um exemplo real, veja [Knockbox](https://github.com/reiddraper/knockbox).


## Usando Leiningen 2.0 (Preview)

O Leiningen 2.0 (preview) é fornecido junto do 1.7. Para usá-lo especifique a chave `lein` no `.travis.yml`:

    lein: lein2

Caso necessite utilizar o binário `lein` nos comandos `before_script`, `install:`, `script:`, etc, use `lein2`:

    before_install:
      - lein2 bootstrap

O encadeamento de tarefas requer o uso da tarefa `do` no Leiningen 2.0 Preview 7:

    script: lein2 do javac, test


## Testando em Múltiplos JDKs

Para testar em múltiplos JDKs, use a chave `:jdk` no `.travis.yml`. Por exemplo, para testar no Oracle JDK 7 (que é mais novo que o OpenJDK 7 no Travis CI) e no OpenJDK 6:

    jdk:
      - oraclejdk7
      - openjdk6

Para testar no OpenJDK 7 e Oracle JDK 7:

    jdk:
      - openjdk7
      - oraclejdk7

O Travis CI provê o OpenJDK 7, OpenJDK 6 e Oracle JDK 7. O Sun JDK 6 não é fornecido porque foi marcada como EOL (End-Of-Life) em Novembro de 2012.

O JDK 7 possui compatibilidade com as versões anteriores, e nós achamos que é hora de todos os projetos começarem a serem testados no JDK 7 primeiro, e no JDK 6 apenas se os recursos permitirem.

### Exemplos

 * [Monger](https://github.com/michaelklishin/monger/blob/master/.travis.yml)
 * [Welle](https://github.com/michaelklishin/welle/blob/master/.travis.yml)
 * [Langohr](https://github.com/michaelklishin/langohr/blob/master/.travis.yml)
 * [Neocons](https://github.com/michaelklishin/neocons/blob/master/.travis.yml)


## Testando em Múltiplas Versões do Clojure

### Com Leiningen 1

Leiningen possui um excelente plugin chamado [lein-multi](https://github.com/maravillas/lein-multi) que permite facilmente que você realize testes em diversas versões do Clojure (por exemplo, 1.3, 1.4 e alphas/betas/snapshots das últimas versões de desenvolvimento). Como o leiningen pode executar os testes em qualquer versão do Clojure (não necessariamente na mesma versão que o Leiningen em si usa), não existe a necessidade de switchers de runtime (como RVM) para Clojure.

Para usar lein-multi no travis-ci.org, adicione-o em `:plugins` no project.clj (esta funcionalidade está disponível apenas a partir do Leiningen 1.7.0) e sobrescreva o `script:` para executar `lein multi test` ao invés do padrão `lein test`:

    language: clojure
    script: lein multi test

Para um exemplo real, veja [Monger](https://github.com/michaelklishin/monger).


### Com Leiningen 2

O Leiningen 2 tem uma funcionalidade que substitui o `lein-multi`: [Profiles](https://github.com/technomancy/leiningen/blob/master/doc/TUTORIAL.md). Para executar seus testes em diversos perfis (profiles), e múltiplos conjuntos de dependências ou versões de Clojure, use o ocmando `lein2 with-profile`:


    lein: lein2
    script: lein2 with-profile dev:1.4 test

onde `dev:1.4` é uma lista de perfis separadas por vírgulas onde se deve executar a tarefa `test`. Use `lein2 profiles` para listar os perfis do seu projeto e `lein2 help with-profile` para aprender mais sobre a tarefa `with-profiles`.

Para um exemplo real, veja [Neocons](https://github.com/michaelklishin/neocons).


## Exemplos

* [leiningen's .travis.yml](https://github.com/technomancy/leiningen/blob/stable/.travis.yml)
* [monger's .travis.yml](https://github.com/michaelklishin/monger/blob/master/.travis.yml)
* [welle's .travis.yml](https://github.com/michaelklishin/welle/blob/master/.travis.yml)
* [langohr's .travis.yml](https://github.com/michaelklishin/langohr/blob/master/.travis.yml)
* [neocons' .travis.yml](https://github.com/michaelklishin/neocons/blob/master/.travis.yml)
* [momentum's .travis.yml](https://github.com/momentumclj/momentum/blob/master/.travis.yml)
* [Knockbox's .travis.yml](https://github.com/reiddraper/knockbox/blob/master/.travis.yml)
* [Sumo's .travis.yml](https://github.com/reiddraper/sumo/blob/master/.travis.yml)
