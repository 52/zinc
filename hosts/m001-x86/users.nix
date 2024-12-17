{
  pkgs,
  config,
  mkOSLib,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users = {
    users.max = {
      description = "Max Karou";
      isNormalUser = true;
      extraGroups =
        [
          "wheel"
        ]
        ++ ifTheyExist [
          "networkmanager"
          "gamemode"
          "docker"
          "audio"
          "video"
        ];
    };
  };

  home-manager = {
    users.max = {
      imports = map mkOSLib.relativeToRoot [
        "home/alacritty.nix"
        "home/hyprland.nix"
        "home/style.nix"
        "home/bash.nix"
        "home/fish.nix"
        "home/nvim.nix"
        "home/tmux.nix"
        "home/sops.nix"
        "home/ssh.nix"
        "home/git.nix"
        "home/xdg.nix"
      ];

      home = {
        username = "max";
        homeDirectory = "/home/max";
        sessionVariables = {
          # used by home/hyprland.nix
          TERMINAL = "alacritty";
          # used by home/hyprland.nix
          BROWSER = "firefox";
          # used by home/${alacritty | wezterm | tmux}.nix
          SHELL = "fish";
          # used by home/git.nix
          EDITOR = "nvim";
        };
        packages = with pkgs; [
          just
        ];
        preferXdgDirectories = true;
        stateVersion = "24.11";
      };

      # home/hyprland.nix
      home-hyprland = {
        enable = true;
      };

      # home/nvim.nix
      home-nvim = {
        enable = true;
      };

      # home/sops.nix
      home-sops = {
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
      home-ssh = {
        enable = true;
      };

      # home/git.nix
      home-git = {
        enable = true;
        enableAuth = true;
        userName = "Max Karou";
        userEmail = "maxkarou@protonmail.com";
      };

      # doc: https://mynixos.com/home-manager/option/systemd.user.startServices
      systemd.user.startServices = "sd-switch";
    };
  };
}
