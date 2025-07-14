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

  # Enable nix, see: https://github.com/NixOS/nix/
  nix = {
    enable = true;

    settings = {
      # Enable experimental features.
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Disable warning for dirty git repositories.
      warn-dirty = false;
    };
  };

  # Enable nixpkgs, see: https://nixos.org/manual/nixpkgs/stable/
  nixpkgs = {
    # Set the custom overlays.
    overlays = builtins.attrValues outputs.overlays;

    # Allow use of proprietary software.
    config.allowUnfree =true;
  };

  home-manager = {
    # Define globally shared modules.
    sharedModules = lib.importAll "modules/home";

    # Use the system packages.
    useGlobalPkgs = true;

    # Set extra arguments.
    extraSpecialArgs = { inherit inputs outputs; };
  };

  # Disable the nixOS documentation.
  documentation.nixos.enable = false;
}
