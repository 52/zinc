{
  description = "Development environment flake for rust";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        inherit (builtins) pathExists;
        inherit (nixpkgs) lib;

        # overlays
        overlays = [
          (import rust-overlay)
        ];

        # packages
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        # rust-overlay
        rust = pkgs.rust-bin;

        # rust toolchain file
        pwd = builtins.getEnv "PWD";
        file = lib.findFirst pathExists null [
          "${pwd}/rust-toolchain.toml"
          "${pwd}/rust-toolchain"
        ];

        # rust extensions
        extensions = [
          "rust-analyzer"
          "rust-src"
          "clippy"
        ];

        # rust toolchain
        base = if file != null then rust.fromRustupToolchainFile file else rust.stable.latest.minimal;
        channel = base.override {
          extensions = lib.unique (extensions ++ (base.extensions or [ ]));
        };

        # nightly components
        nightly = rust.selectLatestNightlyWith (toolchain: toolchain.rustfmt);
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = lib.concatLists [
            [
              nightly
              channel
            ]

            (with pkgs; [
              cargo-flamegraph
              cargo-criterion
              cargo-show-asm
              cargo-nextest
              cargo-expand
            ])
          ];
          shellHook = ''
            # ensure `cargo fmt` uses nightly `rustfmt`
            export RUSTFMT="${nightly}/bin/rustfmt"

            echo ""
            ${lib.optionalString (file != null) ''echo "Using file \"${toString file}\":"''}
            ${lib.optionalString (file == null) ''echo "Using latest stable:"''}
            echo "$(${channel}/bin/rustc --version)"
            echo "$(${channel}/bin/cargo --version)"
            echo "$(${channel}/bin/rust-analyzer --version)"
            echo ""
            echo "Using latest nightly:"
            echo "$($RUSTFMT --version)"
          '';
        };
      }
    );
}
