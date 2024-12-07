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
      publicKeyFile = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/.ssh/id_${config.home.username}.pub";
        description = "The path to the user's public key.";
      };
      allowedSignersFile = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/.ssh/allowed_signers";
        description = "The path to the allowed_signers file.";
      };
    };
  };
  config =
    let
      options = config.home-git;
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
          assertion = options.enableAuth -> options.publicKeyFile != "";
          message = "home-git.publicKeyFile must not be empty.";
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
                  ssh = { inherit (options) allowedSignersFile; };
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
              key = options.publicKeyFile;
            };
          };
      };
    };
}
