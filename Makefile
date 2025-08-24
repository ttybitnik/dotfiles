.PHONY: tty wayland xorg sys clean uninstall

ROOT_CMD   ?= sudo
SRC_PREFIX  = tty/.local
SRC_BINDIR  = $(SRC_PREFIX)/bin
SRC_LIBDIR  = $(SRC_PREFIX)/lib
SYS_PREFIX  = /usr/local
SYS_BINDIR  = $(SYS_PREFIX)/bin
SYS_LIBDIR  = $(SYS_PREFIX)/lib

tty:
	stow -t ~ -v tty
	$(ROOT_CMD) install -m 644 $(SRC_LIBDIR)/tty.sh $(SYS_LIBDIR)

wayland: tty
	stow -t ~ -v wayland

xorg: tty
	stow -t ~ -v xorg

sys:
	$(ROOT_CMD) install -m 644 $(SRC_LIBDIR)/tty.sh $(SYS_LIBDIR)

	$(ROOT_CMD) install -m 755 $(SRC_BINDIR)/ttybkp $(SYS_BINDIR)
	$(ROOT_CMD) install -m 755 $(SRC_BINDIR)/ttysha $(SYS_BINDIR)

clean:
	stow -D -t ~ -v tty
	stow -D -t ~ -v wayland
	stow -D -t ~ -v xorg

uninstall:
	$(ROOT_CMD) $(RM) $(SYS_LIBDIR)/tty.sh

	$(ROOT_CMD) $(RM) $(SYS_BINDIR)/ttybkp
	$(ROOT_CMD) $(RM) $(SYS_BINDIR)/ttysha
