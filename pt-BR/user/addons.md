---
title: Addons de Build
layout: pt-BR
permalink: addons/
---

<div id="toc"></div>

## Addons

O Travis CI permite que você configure algumas ferramentas de build usando o seu arquivo .travis.yml.

### Sauce Connect

O [Sauce Connect][sauce-connect] cria um proxy seguro do tráfico entre as máquinas virtuais do Sauce Labs e os nossos servidores locais. O Connect usa as portas 443 e 80 para comunicação com a nuvem do Sauce. Caso esteja utilizando o Sauce Labs para os seus testes Selenium, isto torna mais fácil conectar com os nossos webservers.

[sauce-connect]: https://saucelabs.com/connect

Primeiramente, [cadastre-se][sauce-sign-up] no Sauce Labs caso ainda não o tenha feito (é [gratuito][open-sauce] para projetos Open Source), e obtenha sua chave de acesso da sua [página da conta][sauce-account]. Em seguida, adicione o seguinte ao seu arquivo .travis.yml:

    addons:
      sauce_connect:
        username: "O seu nome de usuário do Sauce Labs"
        access_key: "Sua chave de acesso do Sauce Labs"

[sauce-sign-up]: https://saucelabs.com/signup/plan/free
[sauce-account]: https://saucelabs.com/account
[open-sauce]: https://saucelabs.com/signup/plan/OSS

Caso não queira que sua chave de acesso fique publicamente disponível no repositório, você pode criptografá-la usando `travis encrypt "your-access-key"` (veja [Chaves de Criptografia][encryption-keys] para mais informações sobre criptografia), e adicionando a string segura conforme a seguir:

    addons:
      sauce_connect:
        username: "O seu nome de usuário Sauce Labs"
        access_key:
          secure: "A string segura gerada por `travis encrypt`"

Você também pode adicionar o `nome de usuário` e a `chave de acesso` como variáveis de ambiente caso as nomeie `SAUCE_USERNAME` e `SAUCE_ACCESS_KEY`, respectivamente. Neste caso, tudo que você precisa fazer é adicionar o seguinte ao seu arquivo .travis.yml:

    addons:
      sauce_connect: true

[encryption-keys]: http://about.travis-ci.org/pt-BR/user/encryption-keys/

### Firefox

As nossas máquinas virtuais vêm pré-instaladas com alguma versão recente do Firefox, mas algumas vezes você pode precisar que alguma versão específica esteja instalada. O addon do Firefox permite que você especifique qualquer versão do Firefox e o binário será baixado e instalado antes de executar o seu script de build (como uma parte do estágio before_install).

Caso necessite da versão 17.0 do Firefox, adicione o seguinte ao seu arquivo .travis.yml:

    addons:
      firefox: "17.0"

Por favor note que estes binários são compatíveis apenas com as nossas máquinas virtuais Linux de 64-bits, de forma que não funcionará nas nossas máquinas virtuais Mac.
