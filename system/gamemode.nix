{ pkgs, inputs, ... }:
{
  imports = with inputs.nix-gaming; [
    nixosModules.pipewireLowLatency
    nixosModules.platformOptimizations
  ];
  services = {
    pipewire = {
      lowLatency = {
        enable = true;
      };
    };
  };
  programs = {
    steam = {
      platformOptimizations = {
        enable = true;
      };
    };
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
          softrealtime = "on";
          inhibit_screensaver = 1;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
