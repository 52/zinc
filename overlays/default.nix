{ inputs, ... }:
{
  # add custom pkgs
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # add stable pkgs
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config = {
        allowUnfree = true;
      };
    };
  };

  # add unstable pkgs
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config = {
        allowUnfree = true;
      };
    };
  };

  # add emacs overlay
  emacs-overlay = inputs.emacs-overlay.overlay;

  # add neovim (extra plugins) overlay
  neovim-overlay = inputs.neovim-overlay.overlays.default;

  # add vscode (extensions) overlay
  vscode-overlay = inputs.vscode-overlay.overlays.default;
}
