---
title: Configurando as Notificações de Build
layout: pt-BR
permalink: notifications/
---

<div id="toc"></div>

## Notificações

O Travis CI pode lhe notificar sobre os resultados das construções através de email, IRC e/ou webhooks.

Por padrão ele enviará emails para

* o autor do commit
* o dono do repositório (para repositórios normais)

E por padrão enviará emails quando, em um dado branch:

* um build for quebrado ou se mantiver quebrado
* um build quebrado tiver sido corrigido

Você pode alterar este comportamento com as opções listadas a seguir.

## Notificações por Email

É possível especificar os destinatários que serão notificados sobre os resultados das construções (builds) da seguinte forma:

    notifications:
      email:
        - um@exemplo.com
        - outro@exemplo.com

Também é possível desativar inteiramente as notificações por email:

    notifications:
      email: false

Além disso, você também pode especificar em quais situações deseja ser notificado:

    notifications:
      email:
        recipients:
          - um@exemplo.com
          - outro@exemplo.com
        on_success: [always|never|change] # padrão: change
        on_failure: [always|never|change] # padrão: always

`always` e `never` significam que você quer notificações de email sempre e nunca, respectivamente. `change` significa que você será notificado quando o estado do build mudar em um dado branch.

## Notificações via IRC

Também é possível especificar notificações a serem enviadas para um canal IRC:

    notifications:
      irc: "chat.freenode.net#travis"

Ou múltiplos canais:

    notifications:
      irc:
        - "chat.freenode.net#travis"
        - "chat.freenode.net#algum-outro-canal"

Assim como em outros tipos de notificações, você pode especificar quando as notificações IRC serão realizadas:

    notifications:
      irc:
        channels:
          - "chat.freenode.net#travis"
          - "chat.freenode.net#algum-outro-canal"
        on_success: [always|never|change] # padrão: always
        on_failure: [always|never|change] # padrão: always

Você pode customizar a mensagem que será enviada ao(s) canal(is) utilizando um modelo:

    notifications:
      irc:
        channels:
          - "chat.freenode.net#travis"
          - "chat.freenode.net#algum-outro-canal"
        template:
          - "%{repository} (%{commit}) : %{message} %{foo} "
          - "Detalhes da construção: %{build_url}"

As seguintes variáveis podem ser utilizadas:

* *repository*: A URL do seu repositório no GitHub
* *build_number*: O número do build
* *branch*: O nome da branch do build
* *commit*: O SHA reduzido do commit
* *author*: O nome do autor do commit
* *message*: A mensagem do travis para o build
* *compare_url*: A URL para visualização das alterações do commit
* *build_url*: A URL com os detalhes do build

O modelo padrão é:

    notifications:
      irc:
        template:
          - "%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message}"
          - "Change view : %{compare_url}"
          - "Build details : %{build_url}"

Caso prefira que o robô de notificações utilize notices ao invés de mensagens, a opção `use_notice` pode ser utilizada:

    notifications:
      irc:
        channels:
          - "chat.freenode.net#travis"
          - "chat.freenode.net#algum-outro-canal"
        on_success: [always|never|change] # padrão: always
        on_failure: [always|never|change] # padrão: always
        use_notice: true

e caso prefira que o robô não entre no canal antes de enviar as mensagens, e saia em seguida, use a opção `skip_join`:

    notifications:
      irc:
        channels:
          - "chat.freenode.net#travis"
          - "chat.freenode.net#algum-outro-canal"
        on_success: [always|never|change] # padrão: always
        on_failure: [always|never|change] # padrão: always
        use_notice: true
        skip_join: true

Caso ative a opção `skip_join`, lembre-se de remover a configuração `NO_EXTERNAL_MSGS` (n) do(s) canal(is) que o robô deve notificar.

## Notificações  via Campfire

As notificações também podem ser enviadas para salas de chat do Campfire, usando a seguinte configuração:

    notifications:
      campfire: [subdomínio]:[token da api]@[id da sala]

* *subdomínio*: é o seu subdomínio campfire (i.e. 'seu-subdominio' caso você acesse 'https://seu-subdominio.campfirenow.com')
* *token da api*: é o token do usuário a ser utilizado para postar as notificações.
* *id da sala*: é o id da sala, não o nome.

Da mesma forma que as notificações via IRC, é possível personalizá-las:

    notifications:
      campfire:
        rooms:
          - [[subdomínio]:[token da api]@[id da sala]
        template:
          - "%{repository} (%{commit}) : %{message} %{foo} "
          - "Detalhes do Build: %{build_url}"

Outras opções, como `on_success` e `on_failure` funcionam da mesma forma que as notificações via IRC.

## Flowdock notification

Notifications can be sent to your Flowdock Team Inbox using the following format:

    notifications:
      flowdock: [api token]


* *api token*: is your API Token for the Team Inbox you wish to notify. You may pass multiple tokens as a comma separated string or an array.

## Notificações via HipChat

Notificações podem ser enviadas para salas de chat do HitChat, usando a seguinte configuração:

    notifications:
      hipchat: [token da api]@[nome da sala]


* *token da api*: é o token do usuário a ser utilizado para postar as notificações.
* *nome da sala*: nome da sala onde as notificações serão enviadas.

As notificações via HipChat também suportam modelos, de forma que você pode customizar a aparência das notificações, ex: reduzí-las a uma única linha:

    notifications:
      hipchat:
        rooms:
          - [token da api]@[nome da sala]
        template:
          - '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message}'

Caso queira enviar notificações HTML, é necessário adicionar a opção `format: html` (note que isto desabilita algumas funcionalidades, como @mentions e linking automático):

    notifications:
      hipchat:
        rooms:
          - [token da api]@[nome da sala]
        template:
          - '%{repository}#%{build_number} (%{branch} - %{commit} : %{author}): %{message} (<a href="%{build_url}">Details</a>/<a href="%{compare_url}">Change view</a>)'
        format: html

## Notificações via Webhook

Você pode definir webhooks a serem notificados sobre os resultados dos build da mesma maneira:

    notifications:
      webhooks: http://seu-dominio.com/notifications

Ou múltiplos canais:

    notifications:
      webhooks:
        - http://seu-dominio.com/notifications
        - http://outro-dominio.com/notifications

Assim como nas outras notificações, é possível especificar quando o webhook será acionado:

    notifications:
      webhooks:
        urls:
          - http://hooks.meudominio.com/travisci
          - http://hooks.meudominio.com/events
        on_success: [always|never|change] # padrão: always
        on_failure: [always|never|change] # padrão: always
        on_start: [true|false] # padrão: false

Veja um exemplo das informações que serão enviadas às URLs do seu webhook via POST: [gist.github.com/1225015](https://gist.github.com/1225015)

### Autorização

Quando o Travis faz a requisição POST, um cabeçalho chamado 'Authorization' é incluído. O seu valor é o hash SHA2 do seu usuário GitHub, o nome do repositório, e o seu token no Travis.
No Python, utilize

    from hashlib import sha256
    sha256('nome-do-usuario/repositório' + TOKEN_DO_TRAVIS).hexdigest()

para garantir que o Travis é quem está realizando requisições no seu webhook.
