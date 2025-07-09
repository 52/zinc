{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.ledger;
in
{
  options.ledger = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the 'ledger' module";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # Install system-wide dependencies.
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        ledger-live-desktop
        ;
    };

    # Enable ledger, see: https://www.ledger.com/
    hardware.ledger.enable = true;
  };
}
