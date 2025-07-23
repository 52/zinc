{
  lib,
  pkgs,
  ...
}:
let
  # List of script names for the 'mx' toolkit.
  scripts = [
    "mx"
    "mx-flake"
    "mx-rebuild"
  ];
in
{
  # Install the 'mx' toolkit, see: 'bin' folder.
  home.packages = builtins.map (
    name: pkgs.writeShellScriptBin name (lib.readRelativeFile "bin/${name}")
  ) scripts;
}
