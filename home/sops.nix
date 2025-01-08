{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (builtins) attrValues;
  inherit (lib) mkOption types custom;
  inherit (custom) relativeToRoot;
in
{
  imports = attrValues {
    inherit (inputs.sops-nix.homeManagerModules) sops;
  };
  options = {
    sops-nix = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      secrets = mkOption {
        type = types.attrs;
        default = { };
      };
    };
  };
  config =
    let
      inherit (lib) mkIf;
      inherit (config) sops-nix xdg;
    in
    mkIf sops-nix.enable {
      sops = {
        inherit (sops-nix) secrets;
        defaultSopsFile = relativeToRoot "nix-secrets/secrets.yaml";
        age = {
          keyFile = "${xdg.configHome}/sops-nix/keys.txt";
        };
      };
    };
}
