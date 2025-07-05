{
  lib,
  inputs,
  ...
}:
{
  imports = lib.flatten [
    # hardware
    ./hardware.nix

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    # system
    (lib.importAll "modules/system")

    # users
    (lib.relativePath "modules/users/max@m001-x86.nix")
  ];

  # system/network.nix
  network = {
    hostName = "m001-x86";
  };

  # system/wayland.nix
  wayland = {
    enable = true;
  };

  # system/docker.nix
  docker = {
    enable = true;
    members = [ "max" ];
  };

  # system/steam.nix
  steam = {
    enable = true;
    members = [ "max" ];
  };

  # system/keyboard.nix
  keyboard = {
    remaps = {
      "keychron-k8" = [ "3434:0281" ];
    };
  };

  # see: https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
