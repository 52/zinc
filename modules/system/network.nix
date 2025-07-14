{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.network;
in
{
  options.network = {
    hostName = mkOption {
      type = types.str;
      description = "The hostname of the system";
      default = "";
    };
  };

  config = {
    networking = {
      # Set the system hostname.
      inherit (cfg) hostName;

      # Enable networkmanager, see: https://github.com/NetworkManager/NetworkManager/
      networkmanager.enable = true;

      # Enable the network firewall.
      firewall = {
        enable = true;

        # Open (TCP) ports.
        allowedTCPPorts = [ ];

        # Open (UDP) ports.
        allowedUDPPorts = [ ];
      };
    };

    # Enable avahi (local network discovery), see: https://avahi.org/
    services.avahi = {
      enable = true;

      # Enable mDNS NSS (IPv4), see: https://github.com/avahi/nss-mdns/
      nssmdns4 = true;

      # Enable local network publishing.
      publish = {
        enable = true;

        # Publish locally used domain.
        domain = true;

        # Publish user services.
        userServices = true;
      };
    };

    # Manage the 'networkmanager' group.
    users.groups.networkmanager = {
      members = builtins.attrNames (
        lib.filterAttrs (_: user: user.isNormalUser or false) config.users.users
      );
    };
  };
}
