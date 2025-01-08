{ inputs, outputs, ... }:
let
  inherit (builtins) attrValues;
in
{
  imports = attrValues {
    inherit (inputs.home-manager.nixosModules) home-manager;
  };
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };
}
