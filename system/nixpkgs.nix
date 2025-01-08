{ outputs, ... }:
let
  inherit (builtins) attrValues;
  inherit (outputs) overlays;
in
{
  nixpkgs = {
    overlays = attrValues overlays;
    config = {
      allowUnfree = true;
    };
  };
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };
}
