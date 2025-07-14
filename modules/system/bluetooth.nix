{ ... }:
{
  # Enable bluez, see: https://www.bluez.org/
  hardware.bluetooth = {
    enable = true;

    # Automatically start bluetooth at boot.
    powerOnBoot = true;

    settings.General = {
      # Enable experimental features.
      Experimental = true;

      # Enable faster advertising interval.
      FastConnectable = true;
    };
  };
}
