_: {
  # add custom packages
  additions = final: _prev: import ../pkgs { pkgs = final; };
}
