{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # <todo>
  apple-fonts = pkgs.callPackage ./apple-fonts { };

  # <todo>
  berkeley-mono = pkgs.callPackage ./berkeley-mono { };
}
