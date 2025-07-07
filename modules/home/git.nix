{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.git;
  env = config.home.sessionVariables;
in
{
  options.git = {
    userName = mkOption {
      type = types.str;
      description = "Default git user name";
      default = throw "Must provide a non-empty string";
    };

    userEmail = mkOption {
      type = types.str;
      description = "Default git user email";
      default = throw "Must provide a non-empty string";
    };
  };

  config = {
    # enable git, https://git-scm.com/
    programs.git = {
      enable = true;

      # set username and email
      inherit (cfg) userName userEmail;

      extraConfig = {
        core = {
          # set default editor
          editor = env.EDITOR;

          # enable file-system monitor
          fsmonitor = true;

          # enable untracked file caching
          untrackedCache = true;
        };

        push = {
          # push only current branch
          default = "simple";

          # automatically create remote branch
          autoSetupRemote = true;

          # push tags with commits
          followTags = true;
        };

        rebase = {
          # automatically squash commits
          autoSquash = true;

          # automatically stash before rebase
          autoStash = true;

          # automatically update refs
          updateRefs = true;
        };

        diff = {
          # use histogram diff algorithm
          algorithm = "histogram";

          # display moved lines in color
          colorMoved = "plain";

          # use descriptive prefixes
          mnemonicPrefix = true;

          # detect renamed files
          renames = true;
        };

        commit = {
          # cleanup at scissors marker
          cleanup = "scissors";

          # display entire diff in editor
          verbose = true;
        };

        # set default branch to 'master'
        init.defaultBranch = "master";

        # sort branches by most recent commit
        branch.sort = "-comitterdate";

        # sort tags by most recent commit
        tag.sort = "-comitterdate";

        # enable columized output
        column.ui = "auto";

        # enable colored output
        color.ui = "auto";

        # enable auto-correct
        help.autocorrect = 1;
      };
    };
  };
}
