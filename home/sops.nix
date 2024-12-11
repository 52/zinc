{
  lib,
  config,
  inputs,
  mkOSLib,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];
  options = {
    home-sops = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables the 'home-sops' module.";
      };
      sopsFile = lib.mkOption {
        type = lib.types.str;
        default = mkOSLib.relativeToRoot "nix-secrets/secrets.yaml";
        description = "The path to the 'secrets.yaml' file.";
      };
      ageKeyFile = lib.mkOption {
        type = lib.types.str;
        default = ".sops/keys.txt";
        description = "The path to the master age key relative to '$HOME'.";
      };
      secrets = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "The set of secrets to be provisioned.";
      };
    };
  };
  config =
    let
      inherit (config) home-sops;
      options = home-sops;
    in
    lib.mkIf options.enable {
      assertions = [
        {
          assertion = options.sopsFile != "";
          message = "home-sops.sopsFile must not be empty.";
        }
        {
          assertion = options.ageKeyFile != "";
          message = "home-sops.ageKeyFile must not be empty.";
        }
      ];
      sops = {
        inherit (options) secrets;
        defaultSopsFile = options.sopsFile;
        age = {
          keyFile = "${config.home.homeDirectory}/${options.ageKeyFile}";
        };
      };
    };
}
