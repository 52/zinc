{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      # custom
      apple-fonts
      # emoji
      noto-fonts-color-emoji
      # symbols
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
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
          "Symbols Nerd Font Mono"
        ];
      };
    };
  };
}
