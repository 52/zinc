{
  lib,
  pkgs,
  ...
}:
lib.mkUser {
  name = "max";
  description = "Max Karou";

  # Enable 'sudo' access.
  groups = [ "wheel" ];

  # Install user dependencies.
  packages = builtins.attrValues {
    inherit (pkgs)
      hyperfine
      ripgrep
      btop
      bat
      jq
      ;
  };

  # Configure home-manager modules.
  home = {
    # home/git.nix
    git = {
      userName = "Max Karou";
      userEmail = "maxkarou@protonmail.com";
    };

    # home/ssh.nix
    ssh = {
      enable = true;
      enableGitIntegration = true;
    };

    # home/sops.nix
    sops-nix = {
      enable = true;
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
