{ mkOSLib, ... }:
{
  imports = map mkOSLib.relativeToRoot [
    "system/docker.nix"
  ];
}
