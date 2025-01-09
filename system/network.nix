{ lib, config, ... }:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    system = {
      network = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        hostName = mkOption {
          type = types.str;
          default = "";
        };
      };
    };
  };
  config =
    let
      inherit (builtins) attrNames;
      inherit (lib) filterAttrs;
      inherit (config) system;
      inherit (system) network;
    in
    mkIf network.enable {
      networking = {
        inherit (network) hostName;
        networkmanager = {
          enable = true;
        };
        firewall = {
          enable = true;
          allowedTCPPorts = [ ];
          allowedUDPPorts = [ ];
        };
      };
      services = {
        avahi = {
          enable = true;
          nssmdns4 = true;
          publish = {
            enable = true;
            domain = true;
            userServices = true;
          };
        };
      };
      users = {
        groups = {
          networkmanager = {
            members = attrNames (filterAttrs (_: u: u.isNormalUser or false) config.users.users);
          };
        };
      };
    };
}
