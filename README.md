# scripts

Utilitários avulsos. Cada um roda sozinho, com o que o sistema já tem — nenhum
depende da minha configuração de shell.

O que **precisa** dela (o `preview` do fzf, o `openfile` do navegador, o `bar` do
xinitrc, o `shpad` do nvim) não está aqui: mora nos dotfiles, em `.config/sh/bin`,
junto do `rc.sh` que os chama. A divisão é por dependência, não por gosto.

    make install     liga os scripts em ~/.local/bin
    make uninstall   remove só os links que apontam para cá
    make list        mostra o que seria instalado

`PREFIX` muda o destino (`make install PREFIX=/usr/local`).
