{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      ledger-live-desktop
    ];
  };
  hardware = {
    ledger = {
      enable = true;
    };
  };
}
