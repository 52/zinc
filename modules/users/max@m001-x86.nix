{
  lib,
  pkgs,
  ...
}:
lib.mkUser {
  name = "max";

  description = "Max Karou";

  groups = [ "wheel" ];

  packages = builtins.attrValues {
    inherit (pkgs)
      hyperfine
      ripgrep
      btop
      bat
      jq
      ;
  };

  modules = { };

  stateVersion = "24.11";
}
