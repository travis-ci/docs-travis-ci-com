---
title: Chaves de criptografia
layout: pt-BR
permalink: encryption-keys/
---

O Travis gera um par de chaves RSA (privada e pública) que pode ser usada para criptografar informações que você deseja incluir no arquivo `.travis.yml` e ainda assim mantê-la privada. Atualmente, nós permitimos a criptografia de [variáveis de ambiente](/pt-BR/docs/user/build-configuration/#Secure-environment-variables) e configurações de notificações.

## Uso

A forma mais fácil de criptografar algo com a chave pública é utilizar o Travis CLI. 
Esta ferramenta foi escrita em Ruby e publicada como uma gem. Primeiro, você precisa instalá-la:

    gem install travis

Depois disso, é possível utilizar o comando `encrypt` para criptografar as informações (este exemplo assume que você está executando o comando no diretório do seu projeto. Caso contrário, adicione `-r owner/project`):

    travis encrypt "algo para criptografar"

Isto gerará uma saída similar a seguinte:

    secure: ".... dados criptografados ...."

Agora você pode colocá-la no seu arquivo `.travis.yml`. Você pode ler mais sobre [variáveis de ambiente seguras](/pt-BR/docs/user/build-configuration/#Variáveis-de-ambiente-seguras) ou [notificações](/pt-BR/docs/user/notifications).

## Obtendo a chave pública do seu repositório

Você pode obter a chave pública com a API do Travis, usando os endpoints `/repos/:dono/:nome/key` ou `/repos/:id/key`. Por exemplo:

    https://api.travis-ci.org/repos/travis-ci/travis-ci/key
