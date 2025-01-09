{
  lib,
  inputs,
  outputs,
  ...
}:
let
  inherit (builtins) attrValues;
in
{
  imports = attrValues {
    inherit (inputs.home-manager.nixosModules) home-manager;
  };
  home-manager = {
    sharedModules = map lib.custom.relativeToRoot [
      "home/hyprland.nix"
      "home/ghostty.nix"
      "home/direnv.nix"
      "home/style.nix"
      "home/bash.nix"
      "home/fish.nix"
      "home/tmux.nix"
      "home/sops.nix"
      "home/nvim.nix"
      "home/ssh.nix"
      "home/git.nix"
      "home/env.nix"
      "home/xdg.nix"
    ];
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };
}
