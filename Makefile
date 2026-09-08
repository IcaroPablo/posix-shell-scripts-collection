# scripts — utilitários avulsos: cada um roda sozinho, sem depender da minha
# configuração de shell. O que precisa dela mora nos dotfiles, em .config/sh/bin.
#
#   make install     liga os scripts em ~/.local/bin
#   make uninstall   remove só os links que apontam para cá
#   make list        mostra o que seria instalado
#
# São symlinks, não cópias: editar aqui vale na hora, sem reinstalar.

PREFIX ?= $(HOME)/.local
BINDIR := $(PREFIX)/bin
SRCDIR := $(CURDIR)/bin

# Onde vai parar o que estava ocupando o nome, quando se instala com FORCE=1.
# Fora do BINDIR de propósito: diretório de PATH não é lugar para acumular
# arquivo .bak — ficaria no caminho de busca e o uninstall não o levaria embora.
DISPLACED := $(PREFIX)/share/posix-shell-scripts-collection/displaced

SCRIPTS := $(notdir $(wildcard $(SRCDIR)/*))

.PHONY: install uninstall list

# Não atropela o que já está lá. `ln -sf` sobrescreve calado, e o nome de um
# script avulso não é tão improvável quanto parece: o compress daqui já disputa
# com o compress(1) do POSIX. Conflito é reportado e a instalação segue nos
# outros; FORCE=1 desloca o que estava ocupando o nome, sem apagar.
install:
	@mkdir -p $(BINDIR)
	@bad=0; for s in $(SCRIPTS); do \
		d=$(BINDIR)/$$s; \
		if [ -L "$$d" ] && [ "`readlink $$d`" = "$(SRCDIR)/$$s" ]; then \
			echo "  = $$s"; continue; \
		fi; \
		if [ -e "$$d" ] || [ -L "$$d" ]; then \
			if [ -z "$(FORCE)" ]; then \
				echo "  ! $$s já existe e não é nosso (FORCE=1 para deslocar)"; \
				bad=1; continue; \
			fi; \
			mkdir -p $(DISPLACED) || { bad=1; continue; }; \
			mv "$$d" "$(DISPLACED)/$$s.`date +%Y%m%d%H%M%S`" || { bad=1; continue; }; \
			echo "  ~ $$s (o que estava lá foi para $(DISPLACED))"; \
		fi; \
		ln -sfn $(SRCDIR)/$$s "$$d" && echo "  + $$s"; \
	done; exit $$bad

# Varre o BINDIR atrás de link que aponte para cá, em vez de percorrer os
# scripts do repositório. A diferença aparece quando um script é apagado daqui:
# pela outra ordem o link instalado deixava de ser enumerado e ficava para
# sempre, quebrado, sem install nem uninstall voltarem a olhar para ele.
#
# Arquivo comum, ou link para outro lugar, continua intocado.
uninstall:
	@for f in $(BINDIR)/*; do \
		[ -L "$$f" ] || continue; \
		case "`readlink $$f`" in \
			$(SRCDIR)/*) rm -f "$$f" && echo "  - `basename $$f`" ;; \
		esac; \
	done
	@if [ -d $(DISPLACED) ] && [ -n "`ls -A $(DISPLACED) 2>/dev/null`" ]; then \
		echo ""; \
		echo "  nota: `ls -A $(DISPLACED) | wc -l | tr -d ' '` arquivo(s) em $(DISPLACED)"; \
		echo "  foram deslocados por um FORCE=1 e não voltam sozinhos."; \
	fi

list:
	@for s in $(SCRIPTS); do echo "  $$s"; done
