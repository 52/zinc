{ ... }:
{
  # enable direnv, see: https://direnv.net/
  programs.direnv = {
    enable = true;

    # enable 'nix-direnv', see: https://github.com/nix-community/nix-direnv/
    nix-direnv.enable = true;
  };
}
