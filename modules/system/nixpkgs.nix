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

  nixpkgs = {
    # Set the list of overlays to apply to "nixpkgs".
    overlays = builtins.attrValues outputs.overlays;

    # Enable the use of proprietary packages.
    config.allowUnfree = true;
  };

  home-manager = {
    # Import all home-manager modules.
    sharedModules = lib.importAll "modules/home";

    # Use the system-wide "nixpkgs" instance.
    useGlobalPkgs = true;

    # Set global arguments for use in home-manager modules.
    extraSpecialArgs = { inherit inputs outputs; };
  };

  # Enable experimental features for "nix".
  # See: https://nix.dev/manual/nix/2.18/contributing/experimental-features/
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
