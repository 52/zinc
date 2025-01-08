{
  lib,
  inputs,
  outputs,
  ...
}:
let
  inherit (builtins) attrValues;
in
{
  imports = attrValues {
    inherit (inputs.home-manager.nixosModules) home-manager;
  };
  home-manager = {
    sharedModules = map lib.custom.relativeToRoot [
      "home/ghostty.nix"
      "home/style.nix"
      "home/nvim.nix"
      "home/fish.nix"
    ];
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };
}
