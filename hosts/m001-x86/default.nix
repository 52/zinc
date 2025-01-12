{
  lib,
  inputs,
  ...
}:
{
  imports = lib.flatten [
    # hardware
    ./hardware.nix

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    # system
    (map lib.custom.relativeToRoot [
      "roles/system"
      "roles/desktop"
      "roles/docker"
      "roles/gaming"
    ])
  ];

  # roles/system
  system = {
    # system/users.nix
    users = {
      "max" = {
        description = "Max Karou";
        extraGroups = [ "wheel" ];
      };
    };

    # system/network.nix
    network = {
      hostName = "m001-x86";
    };

    # system/docker.nix
    docker = {
      members = [ "max" ];
    };

    # system/steam.nix
    steam = {
      members = [ "max" ];
    };

    # doc: https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
  };

  # home-manager
  home-manager = {
    users = {
      "max" = {
        home = {
          username = "max";
          homeDirectory = "/home/max";
          stateVersion = "24.11";
        };

        # home/env.nix
        env = {
          # used by hyprland
          TERMINAL = "ghostty";
          # used by hyprland
          BROWSER = "firefox";
          # used by terminal & tmux
          SHELL = "fish";
          # used by git
          EDITOR = "nvim";
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

        # home/ssh.nix
        ssh = {
          enable = true;
        };

        # home/git.nix
        git = {
          enable = true;
          enableAuth = true;
          userName = "Max Karou";
          userEmail = "maxkarou@protonmail.com";
        };

        # home/fish.nix
        fish = {
          enable = true;
        };

        # home/ghostty.nix
        ghostty = {
          enable = true;
        };

        # home/tmux.nix
        tmux = {
          enable = true;
        };

        # home/nvim.nix
        nvim = {
          enable = true;
        };

        # home/direnv.nix
        direnv = {
          enable = true;
        };

        # home/hyprland.nix
        hyprland = {
          enable = true;
        };

        # doc: https://mynixos.com/home-manager/option/systemd.user.startServices
        systemd.user.startServices = "sd-switch";
      };
    };
  };
}
