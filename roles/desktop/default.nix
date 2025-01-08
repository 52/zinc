{ lib, ... }:
{
  imports = map lib.custom.relativeToRoot [
    # wm
    "system/hyprland.nix"
    "system/fonts.nix"

    # apps
    "system/firefox.nix"
    "system/spotify.nix"
    "system/ledger.nix"
  ];
}
