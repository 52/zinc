{
  lib,
  config,
  ...
}:
{
  # enable pipewire, see: https://pipewire.org/
  services.pipewire = {
    enable = true;

    # enable jack audio connection kit, see: https://jackaudio.org/
    jack.enable = true;

    # enable pulseaudio compatibility
    pulse.enable = true;

    # enable alsa compatibility
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # remove the `.pulse-cookie` from $HOME
  services.pulseaudio.extraClientConf = "cookie-file = /tmp/pulse-cookie";

  # enabled for better performance, see: https://discourse.nixos.org/t/how-to-use-pipewire-instead-of-pulseaudio/22853/3/
  security.rtkit.enable = true;

  # manage the 'audio' group
  users.groups.audio = {
    members = builtins.attrNames (lib.filterAttrs (_: u: u.isNormalUser or false) config.users.users);
  };
}
