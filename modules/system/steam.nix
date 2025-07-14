{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.steam;
in
{
  imports = builtins.attrValues {
    inherit (inputs.nix-gaming.nixosModules)
      pipewireLowLatency
      platformOptimizations
      ;
  };

  options.steam = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the 'steam' module";
      default = false;
    };

    members = mkOption {
      type = types.listOf types.str;
      description = "Users to add to the 'gamemode' group";
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    # Enable steam, see: https://store.steampowered.com/
    programs.steam = {
      enable = true;

      # Enable diverse platform optimizations.
      platformOptimizations.enable = true;
    };

    # Enable gamemode, see: https://github.com/FeralInteractive/gamemode/
    programs.gamemode = {
      enable = true;

      settings.general = {
        # Enable soft real-time scheduling.
        softrealtime = "on";

        # Prevent screen from sleeping.
        inhibit_screensaver = 1;
      };
    };

    # Enable low-latency audio compatibility.
    services.pipewire.lowLatency.enable = true;

    # Manage the 'gamemode' group.
    users.groups.gamemode = {
      inherit (cfg) members;
    };
  };
}
