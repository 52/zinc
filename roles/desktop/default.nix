{ mkOSLib, ... }:
{
  imports = map mkOSLib.relativeToRoot [
    # core
    "system/wayland.nix"

    # apps
    "system/firefox.nix"
    "system/ledger.nix"
  ];
}
