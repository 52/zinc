{ lib, config, ... }:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    system = {
      boot = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };
  };
  config =
    let
      inherit (config) system;
      inherit (system) boot;
    in
    mkIf boot.enable {
      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 10;
          };
          efi = {
            canTouchEfiVariables = true;
          };
          timeout = 3;
        };
      };
    };
}
