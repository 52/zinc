{
  description = "mkOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf/v0.7";
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
      inherit (nixpkgs) lib;

      # custom lib, see '/lib'
      mkOSLib = import ./lib { inherit inputs; };

      # systems that are supported by this configuration
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
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
        inherit inputs outputs mkOSLib;
      };
    in
    {
      # custom overlays, see: '/overlays'
      overlays = import ./overlays { inherit inputs outputs; };

      # custom packages, see: '/pkgs'
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      # formatter used by 'nix fmt', see: https://nix-community.github.io/nixpkgs-fmt
      formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);

      nixosConfigurations = {
        m001-x86 = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/m001-x86
          ];
        };
      };
    };
}
