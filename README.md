# copy-tweak

A simple clipboard-copy tweaker utility written in Rust.

This project contains 2 executables:

1. `copy-tweak`: A job that observes clipboard change, tweaks the copied string using a converter (child process), and automatically saves to the clipboard.
2. `my-copy-tweak`: Simple string converter example that can be written in any programming language (Currently supports Rust and Swift).

## Demo

```shell
# Installs both `copy-tweak` and `my-copy-tweak` (rust) in `~/.cargo/bin`.
$ cargo install --path .

# Calls python, always adding trailing "!!!" text.
$ copy-tweak python -c 'import sys; sys.stdout.write(sys.argv[1] + "!!!")'

# Copy text "Hello".
# Then, you can paste a tweaked text as "Hello!!!"

# Other examples written in your favorite language.
$ make demo-rust
$ make demo-swift
```

## How to use

```shell
$ copy-tweak /path/to/your-converter-script-or-executable
```

Your string converter needs to accept clipboard's raw string from commandline argument, and sends the tweaked string (or empty) to standard output.

```rust
// Rust converter example

fn main() {
    // Accept raw string from clipboard.
    let mut args: Vec<String> = std::env::args().collect::<Vec<String>>();
    args.remove(0);
    let raw = args.join(" ");

    // Tweak the string whatever you want.
    let tweaked = tweak(&raw);

    // Send to standard output.
    print!("{}", tweaked);
}

fn tweak(str: &str) -> String {
    let str = my_tweak1(&str);
    let str = my_tweak2(&str);
    // ...
    str
}
```

See [my-copy-tweak](my-copy-tweak) examples for more information.

## Installation using macOS launchctl (daemonization)

```shell
# Uses Rust version of `my-copy-tweak`.
$ make install-rust

# Uses Swift version of `my-copy-tweak`.
$ make install-swift
```

## Uninstall

```shell
$ make uninstall
```

## License

[MIT](LICENSE)
