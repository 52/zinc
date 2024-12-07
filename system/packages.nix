{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      ripgrep
      procs
      just
      btop
      bat
      fzf
    ];
  };
}
