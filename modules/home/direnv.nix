{ ... }:
{
  # Enable direnv, see: https://direnv.net/
  programs.direnv = {
    enable = true;

    # Enable nix-direnv, see: https://github.com/nix-community/nix-direnv/
    nix-direnv.enable = true;
  };
}
