.PHONY: add remove

add:
	stow --restow -t ~ configs

remove:
	stow --delete -t ~ configs
