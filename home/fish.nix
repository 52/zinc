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
    fish = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config =
    let
      inherit (config) fish env;
    in
    mkIf fish.enable {
      programs = {
        fish = {
          inherit (fish) enable;
          plugins = [
            {
              inherit (pkgs.fishPlugins.autopair) src;
              name = "autopair";
            }
          ];
          shellAbbrs = {
            # fs
            df = "df -h";
            du = "du -h -c";

            # ls
            l = "ls -lF -G --group-directories-first";
            ls = "ls -lF -G --group-directories-first";
            la = "ls -lAF -G --group-directories-first";

            # git
            g = "git";
            ga = "git add";
            gp = "git push";
            gd = "git diff";
            gc = "git commit";
            gs = "git status";
            gb = "git branch";
            gl = "git log --decorate --oneline --graph";

            # nix
            n = "nix";

            # hypr
            h = "hyprctl";

            # docker
            d = "docker";

            # kubectl
            k = "kubectl";

            # tmux
            t = "tmux";
            tl = "tmux ls";
            td = "tmux detach";
            ta = "tmux attach -t";
          };
          shellAliases = {
            # vim
            v = "nvim";
            vi = "nvim";
            vim = "nvim";

            # zed
            z = "zeditor";
            ze = "zeditor";
            zed = "zeditor";
          };
          functions = {
            nd = {
              description = "Shortcut for executing upstream flakes.";
              body = ''
                if test (count $argv) -eq 1
                  set flake "github:52/mOS?dir=flakes/$argv"
                  command nix develop $flake --no-write-lock-file --impure -c ${pkgs.${env.SHELL}}/bin/${env.SHELL}
                else
                  echo "Usage: nd <flake-name>"
                end
              '';
            };
          };
        };
      };
    };
}
