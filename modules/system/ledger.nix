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
      default = false;
      description = ''
        Whether to enable the "ledger" module.

        This enables hardware support for Ledger wallets
        and installs the "Ledger Live" application.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Install system-wide dependencies.
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        ledger-live-desktop
        ;
    };

    # Enable "Ledger".
    # See: https://www.ledger.com
    hardware.ledger.enable = true;
  };
}
