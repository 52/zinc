{ mkOSLib, ... }:
{
  imports = map mkOSLib.relativeToRoot [
    # core
    "system/bluetooth.nix"
    "system/packages.nix"
    "system/network.nix"
    "system/locale.nix"
    "system/audio.nix"
    "system/boot.nix"

    # nix
    "system/nixpkgs.nix"
    "system/home.nix"
  ];
}
