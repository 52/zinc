{ lib, ... }:
{
  imports = map lib.custom.relativeToRoot [
    "system/docker.nix"
  ];
}
