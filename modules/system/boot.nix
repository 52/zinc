{ ... }:
{
  # Enable systemd-boot as bootloader, see: https://wiki.archlinux.org/title/Systemd-boot/
  boot.loader.systemd-boot = {
    enable = true;

    # Limit boot menu entries to 10 items.
    configurationLimit = 10;

    # Use highest available resolution in console.
    consoleMode = "max";
  };

  boot.loader = {
    # Limit boot menu timeout to 3 seconds.
    timeout = 3;

    # Allow modification of EFI variables.
    efi.canTouchEfiVariables = true;
  };
}
