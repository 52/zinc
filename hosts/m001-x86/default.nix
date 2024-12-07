{
  lib,
  inputs,
  mkOSLib,
  ...
}:
{
  imports = lib.flatten [
    # hardware
    ./hardware.nix

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    # roles
    (map mkOSLib.relativeToRoot [
      "roles/system"
      "roles/desktop"
      "roles/docker"
    ])

    # users
    ./users.nix
  ];

  # networking
  networking = {
    hostName = "m001-x86";
  };

  # doc: https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
