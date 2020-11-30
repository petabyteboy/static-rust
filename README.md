# Building Static Binary in Rust using Nix

This is an attempt to build static binary Rust using Nix with flakes feature.

## Development

For development, just run the following command:

```
$ nix develop
$ cargo build --target x86_64-unknown-linux-musl --release
```


## Release

For release, it still an ongoing work. Usually, you just run `nix build` or if you want specificly target the package, run:

```
nix build .#static-rust
```
