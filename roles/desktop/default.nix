{ mkOSLib, ... }:
{
  imports = map mkOSLib.relativeToRoot [
    # wm
    "system/wayland.nix"
    "system/fonts.nix"

    # apps
    "system/firefox.nix"
    "system/spotify.nix"
    "system/ledger.nix"
  ];
}
