{
  description = "A modular, multi-host nixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-secrets = {
      url = "git+ssh://git@github.com/52/nix-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    forge = {
      url = "github:52/forge";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vix = {
      url = "github:52/vix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      systems = [
        "x86_64-linux"
      ];

      # Generate an attribute set for each system.
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});

      # Generate "nixpkgs" for each system.
      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

      # Custom library, see: "lib" folder.
      lib = nixpkgs.lib.extend (
        _: _:
        import ./lib {
          inherit (nixpkgs) lib;
          inherit inputs;
        }
      );

      # Custom packages, see: "pkgs" folder.
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      # Custom overlays, see: "overlays" folder.
      overlays = import ./overlays { inherit inputs; };

      specialArgs = {
        inherit lib inputs outputs;
      };
    in
    {
      inherit overlays packages;

      # Formatter used by "nix fmt".
      # See: https://nix-community.github.io/nixpkgs-fmt/
      formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);

      # Shell used by "nix develop".
      # See: https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-develop
      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nixfmt-rfc-style
            deadnix
            statix
            nixd
          ];
        };
      });

      nixosConfigurations = {
        m001-x86 = lib.nixosSystem {
          inherit specialArgs;
          modules = map lib.relativePath [
            "modules/host/m001-x86"
          ];
        };

        m002-x86 = lib.nixosSystem {
          inherit specialArgs;
          modules = map lib.relativePath [
            "modules/host/m002-x86"
          ];
        };
      };
    };
}
