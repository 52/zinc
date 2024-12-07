{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  apple-fonts = pkgs.callPackage ./apple-fonts { };
}
