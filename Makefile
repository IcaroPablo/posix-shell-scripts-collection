# scripts — utilitários avulsos: cada um roda sozinho, sem depender da minha
# configuração de shell. O que precisa dela mora nos dotfiles, em .config/sh/bin.
#
#   make install     liga os scripts em ~/.local/bin
#   make uninstall   remove só os links que apontam para cá
#   make list        mostra o que seria instalado
#
# São symlinks, não cópias: editar aqui vale na hora, sem reinstalar.

PREFIX  ?= $(HOME)/.local
BINDIR  := $(PREFIX)/bin
DATADIR := $(PREFIX)/share
SRCDIR  := $(CURDIR)/bin

SCRIPTS := $(notdir $(wildcard $(SRCDIR)/*))
DATA    := $(notdir $(wildcard $(CURDIR)/share/*))

.PHONY: install uninstall list

install:
	@mkdir -p $(BINDIR) $(DATADIR)
	@for s in $(SCRIPTS); do \
		ln -sfn $(SRCDIR)/$$s $(BINDIR)/$$s && echo "  + bin/$$s"; \
	done
	@for d in $(DATA); do \
		ln -sfn $(CURDIR)/share/$$d $(DATADIR)/$$d && echo "  + share/$$d"; \
	done

# só remove o que aponta para este repositório: link alheio de mesmo nome fica
uninstall:
	@for s in $(SCRIPTS); do \
		if [ -L $(BINDIR)/$$s ] && [ "`readlink $(BINDIR)/$$s`" = "$(SRCDIR)/$$s" ]; then \
			rm -f $(BINDIR)/$$s && echo "  - bin/$$s"; \
		fi; \
	done
	@for d in $(DATA); do \
		if [ -L $(DATADIR)/$$d ] && [ "`readlink $(DATADIR)/$$d`" = "$(CURDIR)/share/$$d" ]; then \
			rm -f $(DATADIR)/$$d && echo "  - share/$$d"; \
		fi; \
	done

list:
	@for s in $(SCRIPTS); do echo "  bin/$$s"; done
	@for d in $(DATA); do echo "  share/$$d"; done
