{
  lib,
  pkgs,
  ...
}:
let
  # List of scripts inside the "bin" directory.
  scripts = lib.attrNames (
    lib.filterAttrs (_: type: type == "regular") (builtins.readDir (lib.relativePath "bin"))
  );
in
{
  # Install all scripts, see: "bin" folder.
  home.packages = builtins.map (
    name: pkgs.writeScriptBin name (lib.readFileRelative "bin/${name}")
  ) scripts;
}
