# scripts — utilitários avulsos: cada um roda sozinho, sem depender da minha
# configuração de shell. O que precisa dela mora nos dotfiles, em .config/sh/bin.
#
#   make install     liga os scripts em ~/.local/bin
#   make uninstall   remove só os links que apontam para cá
#   make list        mostra o que seria instalado
#
# São symlinks, não cópias: editar aqui vale na hora, sem reinstalar.
#
# POSIX make, e portanto também bmake e o make do OpenBSD: nada de wildcard,
# notdir, addprefix ou CURDIR, que são função do GNU make e não existem lá. As
# listas saem do shell, com glob, e a raiz sai de `pwd` — por isso `cd` no
# repositório antes, e não `make -C`, que o make do OpenBSD não tem.

PREFIX ?= $(HOME)/.local
BINDIR = $(PREFIX)/bin

# Onde vai parar o que estava ocupando o nome, quando se instala com FORCE=1.
# Fora do BINDIR de propósito: diretório de PATH não é lugar para acumular
# arquivo deslocado — ficaria no caminho de busca e o uninstall não o levaria.
DISPLACED = $(PREFIX)/share/posix-shell-scripts-collection/displaced

.PHONY: all install uninstall list

all:
	@echo "make install | make uninstall | make list"

# Não atropela o que já está lá. `ln -sf` sobrescreve calado, e o nome de um
# script avulso não é tão improvável quanto parece: o compress daqui já disputa
# com o compress(1) do POSIX. Conflito é reportado e a instalação segue nos
# outros; FORCE=1 desloca o ocupante, sem apagar.
install:
	@src="`pwd`/bin"; mkdir -p "$(BINDIR)"; bad=0; \
	for s in "$$src"/*; do \
		n=`basename "$$s"`; d="$(BINDIR)/$$n"; \
		if [ -L "$$d" ] && [ "`readlink "$$d"`" = "$$s" ]; then \
			echo "  = $$n"; continue; \
		fi; \
		if [ -e "$$d" ] || [ -L "$$d" ]; then \
			if [ -z "$(FORCE)" ]; then \
				echo "  ! $$n já existe e não é nosso (FORCE=1 para deslocar)"; \
				bad=1; continue; \
			fi; \
			mkdir -p "$(DISPLACED)" || { bad=1; continue; }; \
			mv "$$d" "$(DISPLACED)/$$n.`date +%Y%m%d%H%M%S`" || { bad=1; continue; }; \
			echo "  ~ $$n (o que estava lá foi para $(DISPLACED))"; \
		fi; \
		ln -sfn "$$s" "$$d" && echo "  + $$n"; \
	done; exit $$bad

# Varre o BINDIR atrás de link que aponte para cá, em vez de percorrer os
# scripts do repositório. A diferença aparece quando um script é apagado daqui:
# pela outra ordem o link instalado deixava de ser enumerado e ficava para
# sempre, quebrado, sem install nem uninstall voltarem a olhar para ele.
#
# Arquivo comum, ou link para outro lugar, continua intocado.
uninstall:
	@src="`pwd`/bin"; \
	for f in "$(BINDIR)"/*; do \
		[ -L "$$f" ] || continue; \
		t=`readlink "$$f"`; \
		case "$$t" in \
			"$$src"/*) rm -f "$$f" && echo "  - `basename "$$f"`" ;; \
		esac; \
	done; \
	if [ -d "$(DISPLACED)" ] && [ -n "`ls -A "$(DISPLACED)" 2>/dev/null`" ]; then \
		echo ""; \
		echo "  nota: `ls -A "$(DISPLACED)" | wc -l | tr -d ' '` arquivo(s) em $(DISPLACED)"; \
		echo "  foram deslocados por um FORCE=1 e não voltam sozinhos."; \
	fi

list:
	@for s in bin/*; do echo "  `basename "$$s"`"; done
