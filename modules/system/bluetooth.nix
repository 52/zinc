{ ... }:
{
  # enable bluez, see: https://www.bluez.org/
  hardware.bluetooth = {
    enable = true;

    # automatically power-on at boot
    powerOnBoot = true;

    # configure bluez
    settings.General = {
      # enable experimental features
      Experimental = true;

      # use faster advertising interval
      FastConnectable = true;
    };
  };
}
