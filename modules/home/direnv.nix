{ ... }:
{
  # Enable "direnv".
  # See: https://direnv.net
  programs.direnv = {
    enable = true;

    # Enable "nix-direnv".
    # See: https://github.com/nix-community/nix-direnv
    nix-direnv.enable = true;
  };
}
