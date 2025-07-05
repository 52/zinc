{
  ...
}:
{
  # enable systemd-boot as bootloader, see: https://wiki.archlinux.org/title/Systemd-boot/
  boot.loader.systemd-boot = {
    enable = true;

    # limit boot menu entries to 10 items
    configurationLimit = 10;

    # use highest available resolution (console)
    consoleMode = "max";
  };

  boot.loader = {
    # limit boot menu timeout to 3s
    timeout = 3;

    # allow modification of efi variables
    efi.canTouchEfiVariables = true;
  };
}
