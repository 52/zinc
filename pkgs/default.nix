{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # "Apple Fonts".
  # See: https://developer.apple.com/fonts
  apple-fonts = pkgs.callPackage ./apple-fonts.nix { };

  # "Berkeley Mono".
  # See: https://usgraphics.com/products/berkeley-mono
  berkeley-mono = pkgs.callPackage ./berkeley-mono.nix { };
}
