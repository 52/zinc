{ mkOSLib, ... }:
{
  imports = map mkOSLib.relativeToRoot [
    "system/bluetooth.nix"
    "system/packages.nix"
    "system/nixpkgs.nix"
    "system/network.nix"
    "system/locale.nix"
    "system/audio.nix"
    "system/home.nix"
    "system/boot.nix"
  ];
}
