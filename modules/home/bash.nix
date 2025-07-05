{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.bash;
in
{
  options.bash = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the 'bash' module";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      historyFile = "${config.xdg.dataHome}/bash/bash_history";
    };
  };
}
