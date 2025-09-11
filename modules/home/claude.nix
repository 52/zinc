{
  pkgs,
  config,
  ...
}:
let
  # Create a wrapped version of the "claude-code" package.
  # This forces $CLAUDE_CONFIG_DIR to always point to $XDG_CONFIG_DIRECTORY.
  # See: https://github.com/anthropics/claude-code/issues/264
  claude = pkgs.symlinkJoin {
    name = "claude-code";

    paths = [
      pkgs.unstable.claude-code
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/claude \
        --set CLAUDE_CONFIG_DIR "${config.xdg.configHome}/claude"
    '';
  };
in
{
  # Enable "claude-code".
  # See: https://github.com/anthropics/claude-code
  home.packages = builtins.attrValues {
    inherit claude;
  };
}
