{
  inputs,
  ...
}:
{
  # custom packages
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # custom overrides
  overrides = final: prev: { };

  # add stable packages
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config = {
        allowUnfree = true;
      };
    };
  };

  # add unstable packages
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config = {
        allowUnfree = true;
      };
    };
  };

  # apply 'github:52/vim' overlay
  vim-overlay = inputs.vim-overlay.overlays.default;
}
