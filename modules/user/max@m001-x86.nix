{
  lib,
  pkgs,
  ...
}:
lib.mkUser {
  name = "max";
  description = "Max Karou";

  # enable 'sudo' access
  groups = [ "wheel" ];

  # install dependencies (user)
  packages = builtins.attrValues {
    inherit (pkgs)
      hyperfine
      ripgrep
      btop
      bat
      jq
      ;
  };

  # configure modules (home-manager)
  modules = {
    ssh = {
      enable = true;
      enableGitIntegration = true;
    };

    sops = {
      age.keyFile = "/home/max/.age-key.txt";
      defaultSopsFile = lib.relativePath "nix-secrets/secrets.yaml";

      secrets = {
        "ssh/id_max" = {
          path = ".ssh/id_max";
          mode = "0400";
        };

        "ssh/id_max.pub" = {
          path = ".ssh/id_max.pub";
          mode = "0444";
        };
      };
    };
  };

  # WARNING - SEE: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  stateVersion = "24.11";
}
