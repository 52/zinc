{ mkOSLib, ... }:
{
  imports = map mkOSLib.relativeToRoot [
    "system/steam.nix"
    "system/gamemode.nix"
  ];
}
