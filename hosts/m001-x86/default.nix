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
    (map lib.custom.relativeToRoot [
      "roles/system"
      "roles/desktop"
      "roles/docker"
      "roles/gaming"
    ])
  ];

  # roles/system
  system = {
    # system/users.nix
    users = {
      "max" = {
        description = "Max Karou";
        extraGroups = [ "wheel" ];
      };
    };

    # system/network.nix
    network = {
      hostName = "m001-x86";
    };

    # system/docker.nix
    docker = {
      members = [ "max" ];
    };

    # system/steam.nix
    steam = {
      members = [ "max" ];
    };

    # doc: https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
  };

  # home-manager
  home-manager = {
    users = {
      "max" = {
        imports = map lib.custom.relativeToRoot [
          "home/nvim.nix"
        ];

        home = {
          username = "max";
          homeDirectory = "/home/max";
          preferXdgDirectories = true;
          stateVersion = "24.11";
        };

        # doc: https://mynixos.com/home-manager/option/systemd.user.startServices
        systemd.user.startServices = "sd-switch";
      };
    };
  };

}
