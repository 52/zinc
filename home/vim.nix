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
    vim = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config =
    let
      inherit (builtins) attrValues;
      inherit (config) vim;
    in
    mkIf vim.enable {
      home = {
        packages = attrValues {
          inherit (pkgs)
            vim
            ;
        };
      };
    };
}
