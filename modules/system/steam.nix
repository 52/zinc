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
    # enable steam, see: https://store.steampowered.com/
    programs.steam = {
      enable = true;

      # enable platform optimizations
      platformOptimizations.enable = true;
    };

    # enable gamemode, see: https://github.com/FeralInteractive/gamemode/
    programs.gamemode = {
      enable = true;

      settings = {
        general = {
          # enable soft real-time scheduling
          softrealtime = "on";
          # prevent screen from sleeping
          inhibit_screensaver = 1;
        };
      };
    };

    # enable low-latency audio compatibility
    services.pipewire.lowLatency.enable = true;

    # manage the 'gamemode' group
    users.groups.gamemode = {
      inherit (cfg) members;
    };
  };
}
