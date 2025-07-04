{
  inputs,
  ...
}:
{
  # <todo>
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # <todo>
  overrides = final: prev: { };

  # <todo>
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config = {
        allowUnfree = true;
      };
    };
  };

  # <todo>
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config = {
        allowUnfree = true;
      };
    };
  };

  # <todo>
  vim-overlay = inputs.vim-overlay.overlays.default;
}
