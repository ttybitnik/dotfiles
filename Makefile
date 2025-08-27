.PHONY: tty wayland xorg install clean uninstall help __dirs

RM       := rm -f
INSTALL  := install
MKDIR    := mkdir
ROOT_CMD := sudo

SRC_PREFIX := tty/.local
SYS_PREFIX := /usr/local

SRC_LIBDIR := $(SRC_PREFIX)/lib
SRC_BINDIR := $(SRC_PREFIX)/bin
SYS_LIBDIR := $(SYS_PREFIX)/lib
SYS_BINDIR := $(SYS_PREFIX)/bin

SYS_LIB_BASENAMES := tty.sh
SYS_BIN_BASENAMES := ttybkp ttysha
SYS_LIB_FILES     := $(addprefix $(SYS_LIBDIR)/,$(SYS_LIB_BASENAMES))
SYS_BIN_FILES     := $(addprefix $(SYS_BINDIR)/,$(SYS_BIN_BASENAMES))

tty: __dirs $(SYS_LIB_FILES)
	stow -t ~ -v $@

wayland: tty
	stow -t ~ -v $@

xorg: tty
	stow -t ~ -v $@

install: $(SYS_LIB_FILES) $(SYS_BIN_FILES)

clean:
	stow -D -t ~ -v tty
	stow -D -t ~ -v wayland
	stow -D -t ~ -v xorg

uninstall:
	$(ROOT_CMD) $(RM) -- $(SYS_LIB_FILES)
	$(ROOT_CMD) $(RM) -- $(SYS_BIN_FILES)

help:
	@echo "Configuration targets:"
	@echo "  tty       - Stow tty environment for user and install shell"
	@echo "              scripts lib for system"
	@echo "  wayland   - Stow wayland environment for user (requires tty)"
	@echo "  xorg      - Stow xorg environment for user (requires tty)"
	@echo "  install   - Install selected scripts and libs for system"
	@echo
	@echo "Cleaning targets:"
	@echo "  clean     - Unstow all configurations"
	@echo "  uninstall - Remove installed scripts and libs for system"

__dirs:
	$(MKDIR) -p ~/.config/systemd

$(SYS_LIBDIR)/%: $(SRC_LIBDIR)/%
	$(ROOT_CMD) $(INSTALL) -m 644 -- $< $@

$(SYS_BINDIR)/%: $(SRC_BINDIR)/%
	$(ROOT_CMD) $(INSTALL) -m 755 -- $< $@
