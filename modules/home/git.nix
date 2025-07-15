{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.git;
  env = config.env;
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
    # Enable git, https://git-scm.com/
    programs.git = {
      enable = true;

      # Set the username and email.
      inherit (cfg) userName userEmail;

      extraConfig = {
        core = {
          # Set the default editor.
          editor = env.EDITOR;

          # Enable file-system monitor.
          fsmonitor = true;

          # Enable untracked file caching.
          untrackedCache = true;
        };

        push = {
          # Push only current branch.
          default = "simple";

          # Automatically create remote branch.
          autoSetupRemote = true;

          # Automatically push tags with commits.
          followTags = true;
        };

        rebase = {
          # Automatically squash commits.
          autoSquash = true;

          # Automatically stash before rebase.
          autoStash = true;

          # Automatically update references.
          updateRefs = true;
        };

        diff = {
          # Use histogram diff algorithm.
          algorithm = "histogram";

          # Display moved lines in color.
          colorMoved = "plain";

          # Use descriptive prefixes.
          mnemonicPrefix = true;

          # Detect renamed files.
          renames = true;
        };

        commit = {
          # Cleanup at scissors marker.
          cleanup = "scissors";

          # Display complete diff.
          verbose = true;
        };

        # Set the default branch to 'master'.
        init.defaultBranch = "master";

        # Sort branches by most recent commit.
        branch.sort = "-committerdate";

        # Sort tags by the version and name.
        tag.sort = "version:refname";

        # Enable columized output.
        column.ui = "auto";

        # Enable colored output.
        color.ui = "auto";

        # Enable auto-correct.
        help.autocorrect = 1;
      };
    };
  };
}
