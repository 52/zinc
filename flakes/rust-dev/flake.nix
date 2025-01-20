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
        # overlays
        overlays = [
          (import rust-overlay)
        ];

        # packages
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        # rust channel
        rust = pkgs.rust-bin;
        channel = rust.stable.latest.minimal.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
            "clippy"
          ];
        };

        # nightly components
        nightly = rust.selectLatestNightlyWith (toolchain: toolchain.rustfmt);
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            nightly
            channel
          ];
          shellHook = ''
            # ensure `cargo fmt` uses nightly `rustfmt`
            export RUSTFMT="${nightly}/bin/rustfmt"

            echo "$(${channel}/bin/rustc --version)"
            echo "$(${channel}/bin/cargo --version)"

            echo "$(${channel}/bin/rust-analyzer --version)"
            echo "$($RUSTFMT --version)"
          '';
        };
      }
    );
}
