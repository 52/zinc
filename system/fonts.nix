{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      # emoji
      font-awesome
      noto-fonts-color-emoji
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      # custom
      apple-fonts
    ];
    fontconfig = {
      defaultFonts = {
        serif = [
          "New York Medium"
          "emoji"
        ];
        sansSerif = [
          "SF Pro Text"
          "emoji"
        ];
        monospace = [
          "SF Mono"
          "emoji"
        ];
        emoji = [
          "Noto Color Emoji"
          "Font Awesome 6 Free"
          "Font Awesome 6 Brands"
          "Symbols Nerd Font Mono"
        ];
      };
    };
  };
}
