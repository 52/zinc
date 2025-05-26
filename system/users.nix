{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = {
    system = {
      users = mkOption {
        type = types.attrsOf (
          types.submodule (
            { name, ... }:
            {
              options = {
                name = mkOption {
                  type = types.str;
                  default = name;
                };
                description = mkOption {
                  type = types.str;
                  default = "";
                };
                extraGroups = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                };
              };
            }
          )
        );
        default = { };
      };
    };
  };
  config =
    let
      inherit (builtins) attrValues;
      inherit (lib) mapAttrs;
      inherit (config) system;
      inherit (system) users;
    in
    {
      environment = {
        systemPackages = attrValues {
          inherit (pkgs)
            # benchmark
            hyperfine
            # monitor
            procs
            btop
            # utils
            ripgrep
            skim
            fzf
            bat
            fd
            jq
            ;
        };
      };
      users = {
        users = mapAttrs (_: user: {
          inherit (user) name description extraGroups;
          isNormalUser = true;
        }) users;
      };
    };
}
