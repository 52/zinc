{
  pkgs,
  ...
}:
{
  fonts = {
    packages = builtins.attrValues {
      inherit (pkgs)
        # noto
        noto-fonts
        noto-fonts-extra
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji

        # microsoft
        corefonts

        # google
        roboto
        roboto-mono
        open-sans

        # custom
        # berkeley-mono
        apple-fonts
        ;

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
