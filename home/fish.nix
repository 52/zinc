{
  pkgs,
  ...
}:
{
  programs = {
    fish = {
      enable = true;
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
        gc = "git commit";
        gs = "git status";
        gb = "git branch";
        gl = "git log --decorate --oneline --graph";

        # vim
        v = "nvim";
        vi = "nvim";
        vim = "nvim";

        # nix
        n = "nix";

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
      functions = {
        fish_greeting = {
          description = "Greeting to show when starting a fish shell.";
          body = "";
        };
      };
    };
  };
}
