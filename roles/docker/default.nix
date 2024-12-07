{ mkOSLib, ... }:
{
  imports = map mkOSLib.relativeToRoot [
    # core
    "system/docker.nix"
  ];
}
