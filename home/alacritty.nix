_: {
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = {
          size = 18;
          normal = {
            family = "monospace";
            style = "Light";
          };
        };
        window = {
          padding = {
            x = 6;
            y = 6;
          };
        };
        selection = {
          save_to_clipboard = true;
        };
        keyboard = {
          bindings = [
            {
              key = "+";
              mods = "Super";
              action = "IncreaseFontSize";
            }
            {
              key = "-";
              mods = "Super";
              action = "DecreaseFontSize";
            }
          ];
        };
      };
    };
  };
}
