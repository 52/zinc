_: {
  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
          no_fade_in = true;
          grace = 0;
        };
        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            hide_input = false;
          }
        ];
      };
    };
  };
}
