tty:
	stow -t ~ -v tty

wayland: tty
	stow -t ~ -v wayland

xorg: tty
	stow -t ~ -v xorg

clean:
