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
}
