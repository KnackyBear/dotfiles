.PHONY: all
all: bin udev dotfiles

.PHONY: bin
bin: ## Installs the bin directory
# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name "*-backlight" -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done

.PHONY: dotfiles
dotfiles: ## Installs dotfiles
# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".travis.yml" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done;
	gpg --list-keys || true;
	mkdir -p $(HOME)/.gnupg
	for file in $(shell find $(CURDIR)/.gnupg); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/.gnupg/$$f; \
	done; \
	ln -fn $(CURDIR)/gitignore $(HOME)/.gitignore;
	git update-index --skip-worktree $(CURDIR)/.gitconfig;
	ln -snf $(CURDIR)/.bash_profile $(HOME)/.profile;
	if [ -f /usr/local/bin/pinentry ]; then \
		sudo ln -snf /usr/bin/pinentry /usr/local/bin/pinentry; \
	fi;
	mkdir -p $(HOME)/Pictures;
	ln -snf $(CURDIR)/737474.png $(HOME)/Pictures/737474.png;

.PHONY: udev
udev: ## Installs udev rules
	for file in $(shell find $(CURDIR)/udev -type f -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /etc/udev/rules.d/$$f; \
	done

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
