{ mkOSLib, ... }:
{
  imports = map mkOSLib.relativeToRoot [
    # core
    "system/steam.nix"
    "system/gamemode.nix"
  ];
}
