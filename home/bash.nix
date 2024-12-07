{ config, ... }:
{
  programs = {
    bash = {
      enable = true;
      historyFile = "${config.xdg.dataHome}/bash/bash_history";
    };
  };
}
