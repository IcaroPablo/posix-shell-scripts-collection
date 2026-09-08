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

O install não atropela nada: se o nome já estiver ocupado por algo que não é
nosso, ele reclama, pula aquele e sai com erro no fim — os outros entram. Com
`FORCE=1` o que estava lá é deslocado para `$PREFIX/share/posix-shell-scripts-collection/displaced`,
com a data no nome, em vez de apagado. Fora do `bin` de propósito: diretório de
PATH não é lugar para guardar arquivo deslocado.

Isso não é zelo teórico. O `compress` daqui disputa o nome com o `compress(1)`
do POSIX, que várias distribuições instalam em `/usr/bin` — como o `~/.local/bin`
vem antes no PATH, o daqui ganha. Sombra, não estrago, mas com `PREFIX=/usr/local`
seria estrago.
