{
  lib,
  inputs,
  outputs,
  ...
}:
{
  imports = builtins.attrValues {
    inherit (inputs.home-manager.nixosModules)
      home-manager
      ;
  };

  # enable nix, see: https://github.com/NixOS/nix/
  nix = {
    enable = true;

    settings = {
      # enable experimental features
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # disable warning for dirty git repositories
      warn-dirty = false;
    };
  };

  # enable nixpkgs, see: https://nixos.org/manual/nixpkgs/stable/
  nixpkgs = {
    # set custom overlays
    overlays = builtins.attrValues outputs.overlays;

    config = {
      # allow use of proprietary software
      allowUnfree = true;

      # enforce strict build-time dependencies
      strictDepsByDefault = false;
    };
  };

  home-manager = {
    # globally shared modules
    sharedModules = lib.importAll "modules/home";

    # use the system level 'pkgs'
    useGlobalPkgs = true;

    # set extra args
    extraSpecialArgs = { inherit inputs outputs; };
  };

  # disable nixos documentation
  documentation.nixos.enable = false;
}
