.PHONY: tty wayland xorg

tty:
	stow -t ~ -v tty

wayland: tty
	stow -t ~ -v wayland

xorg: tty
	stow -t ~ -v xorg

clean:
	stow -D -t ~ -v tty
	stow -D -t ~ -v wayland
	stow -D -t ~ -v xorg
