BIN_NAME = copy-tweak
RUN = cargo run --release
LAUNCH_PLIST = com.inamiy.$(BIN_NAME).plist
LAUNCH_PLIST_PATH = ${HOME}/Library/LaunchAgents/$(LAUNCH_PLIST)
RUST_INSTALL_DIR = ${HOME}/.cargo/bin
OTHER_INSTALL_DIR = /usr/local/bin

build:
	make build-rust

build-rust:
	cargo build --release

build-swift:
	cd ./my-copy-tweak/swift/ && swift build -c release

install:
	make install-rust

# Installs `copy-tweak` in `~/.cargo/bin`.
install-core:
	cargo install --bin $(BIN_NAME) --path .

# 1. Installs both `copy-tweak` and `my-copy-tweak` (rust) in `~/.cargo/bin`.
# 2. Modifies launchctl plist and load.
install-rust:
	cargo install --path .
	sed -e "s;~;${HOME};g" -e "s;\$${MY_COPY_TWEAK_DIR};${RUST_INSTALL_DIR};g" ./resources/$(LAUNCH_PLIST) > $(LAUNCH_PLIST_PATH)
	make load

# 1. Installs `my-copy-tweak` (swift) in `/usr/local/bin`.
# 2. Modifies launchctl plist and load.
install-swift: install-core build-swift
	mv ./my-copy-tweak/swift/.build/release/my-copy-tweak /usr/local/bin
	sed -e "s;~;${HOME};g" -e "s;\$${MY_COPY_TWEAK_DIR};${OTHER_INSTALL_DIR};g" ./resources/$(LAUNCH_PLIST) > $(LAUNCH_PLIST_PATH)
	make load

uninstall:
	cargo uninstall 2>/dev/null || true
	rm -f /usr/local/bin/my-copy-tweak
	make unload
	rm $(LAUNCH_PLIST_PATH)

#----------------------------------------
# launchctl for Rust
#----------------------------------------
load:
	launchctl load $(LAUNCH_PLIST_PATH)

unload:
	launchctl unload $(LAUNCH_PLIST_PATH)

lint:
	plutil -lint ./resources/$(LAUNCH_PLIST)

#----------------------------------------
# Demos
#----------------------------------------
# Always adds trailing "!!!" text.
demo-python:
	$(RUN) --bin $(BIN_NAME) -- python -c 'import sys; sys.stdout.write(sys.argv[1] + "!!!")'

# See ./my-copy-tweak/rust/main.rs
demo-rust:
	$(RUN) --bin $(BIN_NAME) -- $(RUN) --bin my-copy-tweak

# TODO: Use `swift run` (if possible).
demo-swift: build-swift
	$(RUN) --bin $(BIN_NAME) -- ./my-copy-tweak/swift/.build/release/my-copy-tweak
