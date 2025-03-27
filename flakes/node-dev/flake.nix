{
  description = "Development environment flake for node";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        inherit (nixpkgs) lib;

        # packages
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = lib.concatLists [
            (with pkgs; [
              nodejs_22
              typescript
              typescript-language-server
            ])
          ];
          shellHook = ''
            echo ""
            echo "Using node versions:"
            echo "$(${pkgs.nodejs_22}/bin/node --version)"
            echo "$(${pkgs.nodejs_22}/bin/npm --version)"
            echo ""
          '';
        };
      }
    );
}
