{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      # icon
      material-design-icons
      font-awesome
      # noto
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      # custom
      apple-fonts
      # nerd
      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
        ];
      })
    ];
    fontconfig = {
      defaultFonts = {
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
  };
}
