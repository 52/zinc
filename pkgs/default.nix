{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  apple-fonts = pkgs.callPackage ./apple-fonts { };
  berkeley-mono = pkgs.callPackage ./berkeley-mono { };
}
