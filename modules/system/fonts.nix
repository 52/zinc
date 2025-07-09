{
  pkgs,
  ...
}:
{
  fonts = {
    packages = builtins.attrValues {
      # Corefonts, see: https://corefonts.sourceforge.net/
      inherit (pkgs)
        corefonts
        ;

      # Google, see: https://fonts.google.com/
      inherit (pkgs)
        roboto
        roboto-mono

        noto-fonts
        noto-fonts-extra
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji

        open-sans
        ;

      # Custom Fonts
      inherit (pkgs)
        apple-fonts
        ;

      # Nerd Fonts
      inherit (pkgs.nerd-fonts)
        symbols-only
        ;
    };

    fontconfig.defaultFonts = {
      serif = [
        "New York Medium"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "SF Pro Text"
        "Noto Color Emoji"
      ];
      monospace = [
        "SF Mono"
        "Noto Color Emoji"
      ];
      emoji = [
        "Noto Color Emoji"
      ];
    };
  };
}
