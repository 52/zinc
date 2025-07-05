{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf types;
  cfg = config.ledger;
in
{
  options.ledger = {
    enable = {
      type = types.bool;
      description = "Whether to enable the ledger module";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # install dependencies (system-wide)
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        ledger-live-desktop
        ;
    };

    # enable hardware support for ledger devices, see: https://www.ledger.com/
    hardware.ledger.enable = true;
  };
}
