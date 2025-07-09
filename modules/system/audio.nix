{
  lib,
  config,
  ...
}:
{
  # Enable pipewire, see: https://pipewire.org/
  services.pipewire = {
    enable = true;

    # Enable the jack connection kit, see: https://jackaudio.org/
    jack.enable = true;

    # Enable pulseaudio compatibility.
    pulse.enable = true;

    # Enable alsa compatibility.
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # Remove the '.pulse-cookie' from home.
  services.pulseaudio.extraClientConf = "cookie-file = /tmp/pulse-cookie";

  # Enabled for better performance, see: https://discourse.nixos.org/t/how-to-use-pipewire-instead-of-pulseaudio/22853/3/
  security.rtkit.enable = true;

  # Manage the 'audio' group.
  users.groups.audio = {
    members = builtins.attrNames (lib.filterAttrs (_: u: u.isNormalUser or false) config.users.users);
  };
}
