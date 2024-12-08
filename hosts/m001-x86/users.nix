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
          "libvirtd"
          "docker"
          "audio"
          "video"
        ];
    };
  };

  home-manager = {
    users.max = {
      imports = map mkOSLib.relativeToRoot [
        "home/wayland.nix"
        "home/wezterm.nix"
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
          TERMINAL = "wezterm";
          # used by home/hyprland.nix
          BROWSER = "firefox";
          # used by home/${wezterm | tmux}.nix
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

      # home/sops.nix
      home-sops = {
        enable = true;
        secrets = {
          "ssh/id_max" = {
            path = "/home/max/.ssh/id_max";
            mode = "0400";
          };
          "ssh/id_max.pub" = {
            path = "/home/max/.ssh/id_max.pub";
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

      # home/xdg.nix
      home-xdg = {
        enable = true;
        enableUserDirs = true;
      };

      # doc: https://mynixos.com/home-manager/option/systemd.user.startServices
      systemd.user.startServices = "sd-switch";
    };
  };
}
