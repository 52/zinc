{
  lib,
  pkgs,
  ...
}:
lib.mkUser {
  name = "max";
  description = "Max Karou";

  # enable 'sudo' access
  groups = [ "wheel" ];

  # install dependencies (user)
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

  # WARNING - SEE: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  stateVersion = "24.11";
}
