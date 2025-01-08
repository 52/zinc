{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    system = {
      audio = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };
  };
  config =
    let
      inherit (builtins) attrValues attrNames;
      inherit (lib) filterAttrs;
      inherit (config) system;
      inherit (system) audio;
    in
    mkIf audio.enable {
      environment = {
        systemPackages = attrValues {
          inherit (pkgs) pulseaudio;
        };
      };
      services = {
        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse = {
            enable = true;
          };
          jack = {
            enable = true;
          };
          wireplumber = {
            enable = true;
          };
        };
      };
      hardware = {
        pulseaudio = {
          enable = false;
        };
      };
      security = {
        rtkit = {
          enable = true;
        };
      };
      users = {
        groups = {
          audio = {
            members = attrNames (filterAttrs (_: u: u.isNormalUser or false) config.users.users);
          };
        };
      };
    };
}
