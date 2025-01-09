{ lib, config, ... }:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    direnv = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config =
    let
      inherit (config) direnv;
    in
    mkIf direnv.enable {
      programs = {
        direnv = {
          inherit (direnv) enable;
          nix-direnv = {
            enable = true;
          };
        };
      };
    };
}
