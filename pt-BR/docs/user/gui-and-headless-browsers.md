---
title: Testes de GUI & Headless no travis-ci.org
layout: pt-BR
permalink: gui-and-headless-browsers/
---

### O Que Este Guia Cobre

Este guia cobre testes de interface (GUI) e testes com o navegador (headless) utilizando ferramentas fornecidas pelo [Ambiente de Integração Contínua](/pt-BR/docs/user/ci-environment/) do Travis. A maior parte do conteúdo é independente de tecnologia e não cobre todos os detalhes de ferramentas específicas de teste (como Poltergeist ou Capybara). Recomendamos que você inicie com o [Guia de Início](/pt-BR/docs/user/getting-started/) e o guia de [Configuração de Build](/pt-BR/docs/user/build-configuration/) antes de ler este guia.

## Usando o xvfb para Executar  Testes que Utilizam GUI (ex. um navegador web)

É possível executar suites de testes que utilizem GUI (como um navegador web) no Travis CI. O ambiente possui o `xvfb` (X Virtual Framebuffer) e o `Firefox` instalados. A grosso modo, o xvfb imita um monitor e permite que você execute aplicações com GUI reais ou navegadores web, como se um monitor estivesse conectado na máquina.

Antes de poder utilizar o `xvfb`, ele deve ser iniciado. Tipicamente o melhor lugar para fazê-lo é no `before_script`, da seguinte forma:

    before_script:
      - "export DISPLAY=:99.0"
      - "sh -e /etc/init.d/xvfb start"

Isto inicia o xvfb na porta de exibição (display port) :99.0. A porta de exibição é definida diretamente no script `/etc/init.d`. Ao executar os testes, você deve informar ao processo da sua ferramenta de testes (ex: Selenium) sobre esta porta de exibição, de forma que ele saiba onde iniciar o Firefox. Este passo varia conforme a ferramenta de testes e a linguagem de programação.

### Configurando o Tamanho da Tela no xvfb e Mais

É possível definir o tamanho da tela e a produndidade de cor no xvfb. Como o xvfb é uma tela virtual, é possível emular qualquer resolução. Ao fazê-lo, é necessário iniciar o xvfb diretamente via utilitário `start-stop-daemon`, ao invés do script de init:

    before_install:
    - "/sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99 -ac -screen 0 1280x1024x16"
    
Neste exemplo, a resolução da tela foi definida como `1280x1024x16`.

## Iniciando um Servidor Web

Caso o seu projeto necessite de uma aplicação web executando para ser testada, você deve iniciar uma antes de executar os testes. É comum utilizar servidores web baseados em Ruby, Node.js e outros servidores baseados na JVM que servem páginas HTML utilizadas para executar a suite de testes. Como cada máquina virtual do travis-ci.org fornece ao menos uma versão de Ruby, Node.js e OpenJDK, você pode utilizar qualquer uma dessas 3 opções.


Adicione um `before_script` para iniciar um servidor. Por exemplo:

    before_script:
      - "export DISPLAY=:99.0"
      - "sh -e /etc/init.d/xvfb start"
      - sleep 3 # dá algum tempo para o xvfb iniciar
      - rackup  # inicia o servidor web
      - sleep 3 # dá algum tempo para o servidor web iniciar

Caso necessite que o servidor web esteja escutando na porta 80, lembre-se de utilizar o sudo (O Linux não permitirá que processos não privilegiados utilizem a porta 80). Para portas > 1024, o uso do sudo não é necessário (e não recomendado).


## Usando o Phantom.js

O [Phantom.js](http://www.phantomjs.org/) é um WebKit sem interface gráfica (headless) com uma API JavaScript. É uma solução ideal para testes rápidos, captura de informações em sites, captura de páginas, renderização de SVG, monitoração de redes e muitos outros casos de uso.

O [Ambiente de Integração Contínua](/pt-BR/docs/user/ci-environment/) fornece o Phantom.js (disponível no PATH como `phantomjs`). Como ele não utiliza interface gráfica, o `xvfb` não precisa estar executando.

Um exemplo bem simples:

    script: phantomjs testrunner.js
    
Caso necessite de um servidor web para servir aos testes, veja a seção anterior.

## Exemplos

### Projetos Reais

 * [Ember.js](https://github.com/emberjs/ember.js/blob/master/.travis.yml) (inicia o servidor web de forma programática)


### Ruby

#### RSpec, Jasmine, Cucumber

Este é um exemplo de uma rake task que executa testes Rspec, Jasmine e Cucumber:

    task :travis do
      ["rspec spec", "rake jasmine:ci", "rake cucumber"].each do |cmd|
        puts "Starting to run #{cmd}..."
        system("export DISPLAY=:99.0 && bundle exec #{cmd}")
        raise "#{cmd} failed!" unless $?.exitstatus == 0
      end
    end

Neste exemplo, tanto o Jasmine quanto o Cucumber necessitam de uma porta de exibição, pois ambos utilizam navegadores reais. Rspec pode executar sem isto, mas não existe problema em defini-lo.