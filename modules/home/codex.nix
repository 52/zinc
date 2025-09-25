{
  pkgs,
  config,
  ...
}:
let
  # Create a wrapped version of the "codex" package.
  # This forces $CODEX_HOME to always point to $XDG_CONFIG_DIRECTORY.
  # See: https://github.com/openai/codex/issues/1980
  codex = pkgs.symlinkJoin {
    name = "codex";

    paths = [
      pkgs.unstable.codex
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/codex \
        --set CODEX_HOME "${config.xdg.configHome}/codex"
    '';
  };
in
{
  # Enable "codex".
  # See: https://chatgpt.com/codex
  home.packages = builtins.attrValues {
    inherit codex;
  };

  # Manage the configuration file directly.
  # See: https://github.com/openai/codex/blob/main/docs/config.md
  xdg.configFile."codex/config.toml".text = ''
    model = "gpt-5-codex"
    model_provider = "openai"
    model_reasoning_effort = "high"
  '';

  # Manage the "AGENTS.md" file directly.
  xdg.configFile."codex/AGENTS.md".text = ''
    ## Development

    ### Code
    - Adhere to language-specific best practices and established conventions.
    - Be consistent with existing code style and patterns within the repository.
    - Use clear, descriptive names for variables, functions, and classes.
    - Keep functions small and focused on a single responsibility.
    - Handle errors gracefully with appropriate messages.

    ### Comments
    - Explain the intent, rationale and trade-offs (if any) - avoid restating the code.
    - Use `TODO:`/`FIXME:` with an owner or issue reference when applicable.
    - Be consistent with existing comment style and structure within the repository.

    ## Git (Version Control)

    ### Commits (ref.: [Chris Beams](https://cbea.ms/git-commit))
    - Separate the subject from the body with a blank line.
    - Subject: ≤ 50 characters, imperative mood, start with a capital letter and no period at the end.
    - Body: ≤ 72 characters per line, use complete sentences and explain the what and why (not the how).
    - References: add `Resolves #<ISSUE_ID>` and/or `Refs #<ISSUE_ID>` in the body.

    ```git
    # <Subject>

    # <Body>

    # <References>

    # Optional:
    # BREAKING CHANGE: <description>
    # Co-authored-by: Full Name <email@example.com>
    ```

    ### Pull Requests (PRs)
    - Keep PRs small and focused; one topic per PR.
    - Title: ≤ 72 characters, imperative mood - optionally include scope.
    - References: add `Resolves #<ISSUE_ID>` and/or `Refs #<ISSUE_ID>` in the body.
  '';
}
