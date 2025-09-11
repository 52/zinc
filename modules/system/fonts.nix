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

    fontconfig.defaultFonts = rec {
      # Set the default sans-serif font.
      sansSerif = [
        "SF Pro Text"
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

      # Serif fonts are a glorious mistake.
      # This defaults to `sansSerif` instead.
      serif = sansSerif;

      # Set the default emoji font.
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
