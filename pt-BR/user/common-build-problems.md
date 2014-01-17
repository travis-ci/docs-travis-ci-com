---
title: Problemas Comuns de Build
layout: pt-BR
permalink: common-build-problems/
---

<div id="toc"></div>

## Ruby: RSpec retorna 0 mas o build falhou

Em alguns cenários, ao executar `rake rspec` ou até mesmo o rspec diretamente, o comando retorna 0 mesmo quando o build falha.
Isto geralmente é causado por alguma RubyGem sobrescrevendo o handler `at_exit` de outra RubyGem, neste caso o do RSpec.

Uma solução é instalar o handler `at_exit` no seu código, como mostrado [neste artigo](http://www.davekonopka.com/2013/rspec-exit-code.html).

    if defined?(RUBY_ENGINE) && RUBY_ENGINE == "ruby" && RUBY_VERSION >= "1.9"
      module Kernel
        alias :__at_exit :at_exit
        def at_exit(&block)
          __at_exit do
            exit_status = $!.status if $!.is_a?(SystemExit)
            block.call
            exit exit_status if exit_status
          end
        end
      end
    end

## Ruby: A instalação da biblioteca `debugger_ruby-core-source` falha

Esta biblioteca Ruby infelizmente tem um histórico de quebrar mesmo com releases patchlevel do Ruby.
Normalmente é alguma dependência de bibliotecas como linecache ou outra biblioteca de debugging do Ruby.

Nós recomendamos que você mova estas bibliotecas para um grupo separado no seu Gemfile e então instale o RubyGems no Travis CI sem este grupo.
Como as bibliotecas são úteis apenas durante o desenvolvimento local, você observará um aumento na velocidade do processo de instalação do seu build.

    # Gemfile
    group :debug do
      gem 'debugger'
      gem 'debugger-linecache'
      gem 'rblineprof'
    end

    # .travis.yml
    bundler_args: --without development debug
