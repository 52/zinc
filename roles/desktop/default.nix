{ mkOSLib, ... }:
{
  imports = map mkOSLib.relativeToRoot [
    # core
    "system/wayland.nix"
    "system/fonts.nix"

    # apps
    "system/firefox.nix"
    "system/ledger.nix"
  ];
}
