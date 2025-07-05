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
      description = "<todo>";
      default = "";
    };
  };

  config = {
    networking = {
      # set system hostname
      inherit (cfg) hostName;

      # enable networkmanager, see: https://github.com/NetworkManager/NetworkManager/
      networkmanager.enable = true;

      # enable network firewall
      firewall = {
        enable = true;

        # open ports (TCP)
        allowedTCPPorts = [ ];

        # open ports (UDP)
        allowedUDPPorts = [ ];
      };
    };

    # enable avahi (local network discovery), see: https://avahi.org/
    services.avahi = {
      enable = true;

      # enable mDNS NSS (IPv4), see: https://github.com/avahi/nss-mdns/
      nssmdns4 = true;

      # enable publishing
      publish = {
        enable = true;

        # publish locally used domain
        domain = true;

        # publish user services
        userServices = true;
      };
    };

    # manage the 'networkmanager' group
    users.groups.networkmanager = {
      members = builtins.attrNames (
        lib.filterAttrs (_: user: user.isNormalUser or false) config.users.users
      );
    };
  };
}
