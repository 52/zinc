{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    home-git = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables the 'home-git' module.";
      };
      userName = lib.mkOption {
        type = lib.types.str;
        description = "The name of the 'git' user.";
      };
      userEmail = lib.mkOption {
        type = lib.types.str;
        description = "The e-mail of the 'git' user.";
      };
      enableAuth = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables the authentication with an ssh key.";
      };
    };
  };
  config =
    let
      inherit (config) home-git home-ssh;
      options = home-git;
    in
    lib.mkIf options.enable {
      assertions = [
        {
          assertion = options.userName != "";
          message = "home-git.userName must not be empty.";
        }
        {
          assertion = options.userEmail != "";
          message = "home-git.userEmail must not be empty.";
        }
        {
          assertion = options.enableAuth -> home-ssh.enable;
          message = "home-git.enableAuth requires an enabled 'home-ssh' module.";
        }
      ];
      programs = {
        git =
          {
            inherit (options) userName userEmail;
            enable = true;
            package = pkgs.gitAndTools.gitFull;
            extraConfig =
              {
                core = {
                  excludesfile = "~/.gitignore_global";
                  editor = config.home.sessionVariables.EDITOR;
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
              // lib.optionalAttrs options.enableAuth {
                gpg = {
                  ssh = { inherit (home-ssh) allowedSignersFile; };
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
          // lib.optionalAttrs options.enableAuth {
            signing = {
              signByDefault = true;
              key = home-ssh.publicKeyFile;
            };
          };
      };
    };
}
