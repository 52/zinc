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
    zed = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config =
    let
      inherit (config) zed env;
    in
    mkIf zed.enable {
      programs = {
        zed-editor = {
          enable = true;
          package = pkgs.unstable.zed-editor;
          extensions = [
            "vscode-dark-modern"
            "git-firefly"
            "dockerfile"
            "make"
            "toml"
            "nix"
            "lua"
          ];
          userSettings = {
            # zed
            auto_update = false;
            load_direnv = "shell_hook";
            restore_on_startup = "last_workspace";

            # editor
            theme = {
              mode = "system";
              light = "One Light";
              dark = "VSCode Dark Modern";
            };

            cursor_shape = "block";
            cursor_blink = false;

            ui_font_family = "Berkeley Mono";
            ui_font_weight = 350;
            ui_font_size = 18;

            buffer_font_family = "Berkeley Mono";
            buffer_font_weight = 350;
            buffer_font_size = 16;

            preview_tabs = {
              enabled = true;
              enable_preview_from_file_finder = true;
              enable_preview_from_code_navigation = true;
            };

            collaboration_panel = {
              button = false;
            };

            chat_panel = {
              button = false;
            };

            # terminal
            terminal = {
              shell = {
                program = "${pkgs.${env.SHELL}}/bin/${env.SHELL}";
              };
            };

            # vim
            vim_mode = true;
            vim = {
              use_multiline_find = true;
              use_smartcase_find = true;
              toggle_relative_line_numbers = true;
              use_system_clipboard = "always";
            };

            # telemetry
            telemetry = {
              diagnostics = false;
              metrics = false;
            };

          };
          userKeymaps =
            let
              leader = ",";
            in
            [
              {
                "context" = "Editor && (vim_mode == normal || vim_mode == visual) && !VimWaiting && !menu";
                bindings = {
                  "${leader} f b" = "tab_switcher::Toggle";
                  "${leader} f f" = "file_finder::Toggle";
                  "${leader} f s" = "project_symbols::Toggle";
                  "${leader} g b" = "buffer_search::Deploy";
                  "${leader} g f" = "workspace::NewSearch";
                  "${leader} o f" = "editor::OpenExcerpts";
                };
              }
              {
                "context" = "Editor && vim_mode == normal && !VimWaiting && !menu";
                bindings = {
                  "${leader} c a" = "editor::ToggleCodeActions";
                  "${leader} g r" = "editor::FindAllReferences";
                  "${leader} g i" = "editor::GoToImplementation";
                  "${leader} g t" = "editor::GoToTypeDefinition";
                  "${leader} g d" = "editor::GoToDefinition";
                  "${leader} r n" = "editor::Rename";
                };
              }
              {
                "context" = "Editor";
                bindings = {
                  "ctrl-h" = "editor::ToggleInlayHints";
                };
              }
              {
                "context" = "Pane || ProjectSearchBar || BufferSearchBar";
                bindings = {
                  "ctrl-n" = "search::SelectNextMatch";
                  "ctrl-p" = "search::SelectPrevMatch";
                };
              }
            ];
        };
      };
    };
}
