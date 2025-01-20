{
  description = "mkOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    hardware = {
      url = "github:nixos/nixos-hardware";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-overlay = {
      url = "github:jooooscha/nixpkgs-vim-extra-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-overlay = {
      url = "github:nix-community/nix-vscode-extensions";
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

      # custom lib, see '/lib'
      lib = nixpkgs.lib.extend (_: _: { custom = import ./lib { inherit inputs outputs; }; });

      # systems supported by this configuration
      systems = [
        "x86_64-linux"
      ];

      # generates an attrset for all systems
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

      specialArgs = {
        inherit lib inputs outputs;
      };
    in
    {
      # custom overlays, see: '/overlays'
      overlays = import ./overlays { inherit inputs outputs; };

      # custom packages, see: '/pkgs'
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      # formatter used by 'nix fmt', see: https://nix-community.github.io/nixpkgs-fmt
      formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);

      # shell used by 'nix develop', see: https://nix.dev/manual/nix/2.17/command-ref/new-cli/nix3-develop
      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            sops
            age
          ];
        };
      });

      nixosConfigurations = {
        m001-x86 = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/m001-x86
          ];
        };
      };
    };
}
