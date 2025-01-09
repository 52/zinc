{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    git = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      userName = mkOption {
        type = types.str;
        default = "";
      };
      userEmail = mkOption {
        type = types.str;
        default = "";
      };
      enableAuth = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config =
    let
      inherit (lib) optionalAttrs;
      inherit (config) git ssh env;
    in
    mkIf git.enable {
      programs = {
        git =
          {
            inherit (git) enable userName userEmail;
            package = pkgs.gitAndTools.gitFull;
            extraConfig =
              {
                core = {
                  excludesfile = "~/.gitignore_global";
                  editor = env.EDITOR;
                };
                init = {
                  defaultBranch = "master";
                };
                branch = {
                  sort = "-committerdate";
                };
                push = {
                  autoSetupRemote = true;
                };
                pull = {
                  rebase = true;
                };
                diff = {
                  algorithm = "patience";
                  context = 10;
                };
                color = {
                  ui = "auto";
                };
                help = {
                  autocorrect = 1;
                };
              }
              // optionalAttrs git.enableAuth {
                gpg = {
                  ssh = { inherit (ssh) allowedSignersFile; };
                  format = "ssh";
                };
                url = {
                  "ssh://git@github.com".insteadOf = "https://github.com";
                  "ssh://git@gitlab.com".insteadOf = "https://gitlab.com";
                };
              };
            ignores = [
              "*.swp"
              "*.log"
              "npm-debug.log"
              "node_modules"
            ];
          }
          // optionalAttrs git.enableAuth {
            signing = {
              signByDefault = true;
              key = ssh.publicKeyFile;
            };
          };
      };
    };
}
