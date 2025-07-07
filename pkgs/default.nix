{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # 'Apple Fonts', see: https://developer.apple.com/fonts/
  apple-fonts = pkgs.callPackage ./apple-fonts.nix { };

  # 'Berkeley Mono', see: https://usgraphics.com/products/berkeley-mono/
#   berkeley-mono = pkgs.callPackage ./berkeley-mono.nix { };
}
