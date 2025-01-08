{ lib, ... }:
{
  imports = map lib.custom.relativeToRoot [
    "system/bluetooth.nix"
    "system/keyboard.nix"
    "system/nixpkgs.nix"
    "system/network.nix"
    "system/locale.nix"
    "system/audio.nix"
    "system/users.nix"
    "system/boot.nix"
    "system/time.nix"
    "system/home.nix"
  ];
}
