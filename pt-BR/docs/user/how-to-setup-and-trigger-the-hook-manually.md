---
title: Como configurar e ativar o hook manualmente
layout: pt-BR
permalink: how-to-setup-and-trigger-the-hook-manually/
---

As vezes será necessário configurar o hook manualmente. Normalmente isto não é necessário pois [ativar o botão correto](/pt-BR/docs/user/getting-started/) na página de perfil será suficiente.

Contudo as vezes o hook deve ser configurado manualmente, especialmente ao configurar um repositório hospedado dentro de uma organização do GitHub. Simplesmente acesse o painel de administração do repositório em questão no GitHub, e vá até a sessão chamada "service hooks".

A URL será algo como ``https://github.com/[sua organização]/[seu repositório]/admin/hooks``.

Como a lista é longa, será necessário descer até a opção "Travis", e após selecioná-la, voltar ao topo da página. Você verá um formulário com 3 campos: Domain, User e Token.

Você pode deixar o campo Domain vazio. No campo User, digite a conta do github que você utilizou para se autenticar no travis-ci.org. No campo Token cole o token da forma que ele é listado na página de perfil no travis-ci.org.

Ao clicar em "Update Settings" o hook será configurado e partir deste instante qualquer push neste repositório disparará uma construção no travis-ci.org.

Um clique em "Test Hook" irá disparar uma construção no seu branch "master" sem a necessidade de um push. Note que isto também funcionará caso você tenha configurado o hook através do botão na sua página de perfil.