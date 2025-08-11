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
        material-symbols

        noto-fonts
        noto-fonts-extra
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji

        apple-fonts
        berkeley-mono
        ;
    };

    fontconfig.defaultFonts = {
      # Set the default serif font.
      serif = [ "New York" ];

      # Set the default sans-serif font.
      sansSerif = [ "SF Pro Text" ];

      # Set the default monospace font.
      monospace = [ "SF Mono" ];

      # Set the default emoji font.
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
