{
  pkgs,
  ...
}:
{
  fonts = {
    # Install system fonts.
    # See: https://wiki.nixos.org/wiki/fonts
    packages = builtins.attrValues {
      inherit (pkgs)
        corefonts

        noto-fonts
        noto-fonts-extra
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji

        material-symbols
        font-awesome

        apple-fonts
        ;
    };

    fontconfig.defaultFonts = {
      # Set the default serif font.
      serif = [
        "New York"
        "Noto Serif"
        "Noto Serif CJK SC"
        "Noto Serif CJK JP"
        "Noto Color Emoji"
      ];

      # Set the default sans-serif font.
      sansSerif = [
        "SF Pro Display"
        "Noto Sans"
        "Noto Sans CJK SC"
        "Noto Sans CJK JP"
        "Noto Color Emoji"
      ];

      # Set the default monospace font.
      monospace = [
        "SF Mono"
        "Noto Sans Mono"
        "Noto Sans Mono CJK SC"
        "Noto Sans Mono CJK JP"
        "Noto Color Emoji"
      ];

      # Set the default emoji font.
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
