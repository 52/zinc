{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.ssh;
in
{
  options.ssh = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the 'ssh' module";
      default = false;
    };

    enableGitIntegration = mkOption {
      type = types.bool;
      description = "Whether to enable the 'git' integration";
      default = false;
    };

    publicKeyFile = mkOption {
      type = types.str;
      description = "Path to the public key file";
      default = "${config.home.homeDirectory}/.ssh/id_${config.home.username}.pub";
    };

    privateKeyFile = mkOption {
      type = types.str;
      description = "Path to the private key file";
      default = "${config.home.homeDirectory}/.ssh/id_${config.home.username}";
    };
  };

  config = mkIf cfg.enable (
    lib.mkMerge [
      {
        # enable ssh, see: https://www.openssh.com/
        programs.ssh = {
          enable = true;

          # automatically add keys to 'ssh-agent'
          addKeysToAgent = "yes";

          # restrict to secure algorithms only
          extraConfig = ''
            HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com
            PubkeyAcceptedAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com 
          '';
        };

        # enable ssh-agent, see: https://en.wikipedia.org/wiki/Ssh-agent/
        services.ssh-agent.enable = true;

        # automatically add key to agent (on login)
        systemd.user.services."ssh-agent-add-key" = {
          Unit.After = [ "ssh-agent.service" ];

          Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.openssh}/bin/ssh-add ${cfg.privateKeyFile}";
          };

          Install.WantedBy = [ "default.target" ];
        };
      }

      (mkIf cfg.enableGitIntegration {
        # add match blocks for common (git) hosts
        programs.ssh.matchBlocks."git" = {
          # set user for authentication
          user = "git";

          # match on 'github' and 'gitlab' hosts
          host = "github.com gitlab.com";

          # set the private key
          identityFile = cfg.privateKeyFile;

          # only use specified identity
          identitiesOnly = true;
        };

        # enable (signed) git commits
        programs.git = {
          signing = {
            # enable sign commits by default
            signByDefault = true;

            # set the public key
            key = cfg.publicKeyFile;
          };

          extraConfig = {
            # use ssh for signing
            gpg.format = "ssh";

            # rewrite https -> ssh
            url = {
              "ssh://git@github.com".insteadOf = "https://github.com";
              "ssh://git@gitlab.com".insteadOf = "https://gitlab.com";
            };
          };
        };

        # add common services (git) to 'known_hosts'
        home.file.".ssh/known_hosts".text = ''
          github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
          gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
        '';
      })
    ]
  );
}
