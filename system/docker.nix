{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      kubectl
    ];
  };
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
      autoPrune = {
        enable = true;
      };
    };
  };
}
