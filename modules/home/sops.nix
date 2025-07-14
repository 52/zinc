{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.sops-nix;
in
{
  imports = builtins.attrValues {
    inherit (inputs.sops-nix.homeManagerModules)
      sops
      ;
  };

  options.sops-nix = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the 'sops' module";
      default = false;
    };

    secrets = mkOption {
      type = types.attrs;
      description = "Set of secrets";
      default = {};
    };

    ageKeyFile = mkOption {
      type = types.str;
      description = "Path to the '.age-key.txt' file";
      default = "${config.home.homeDirectory}/.age-key.txt";
    };

    defaultSopsFile = mkOption {
      type = types.str;
      description = "Path to the 'secrets.yaml' file";
      default = lib.relativePath "nix-secrets/secrets.yaml";
    };
  };

  config = mkIf cfg.enable {
    # Enable sops, https://github.com/mic92/sops-nix/
    sops = {
      inherit (cfg) secrets defaultSopsFile;

      # Set the key file.
      age.keyFile = cfg.ageKeyFile;
    };
  };
}
