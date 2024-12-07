{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    home-ssh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables the 'home-ssh' module.";
      };
      publicKeyFile = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/.ssh/id_${config.home.username}.pub";
        description = "The path to the user's ssh public key.";
      };
      privateKeyFile = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/.ssh/id_${config.home.username}";
        description = "The path to the user's ssh private key.";
      };
      allowedSignersFile = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/.ssh/allowed_signers";
        description = "The path to the allowed_signers file.";
      };
    };
  };
  config =
    let
      options = config.home-ssh;
    in
    lib.mkIf options.enable {
      assertions = [
        {
          assertion = options.publicKeyFile != "";
          message = "home-ssh.publicKeyFile must not be empty.";
        }
        {
          assertion = options.privateKeyFile != "";
          message = "home-ssh.privateKeyFile must not be empty.";
        }
        {
          assertion = options.allowedSignersFile != "";
          message = "home-ssh.allowedSignersFile must not be empty.";
        }
      ];
      programs = {
        ssh = {
          enable = true;
          addKeysToAgent = "yes";
          extraConfig = ''
            HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com
            PubkeyAcceptedAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com
          '';
          matchBlocks = {
            "git" = {
              host = "gitlab.com github.com";
              user = "git";
              identitiesOnly = true;
              identityFile = options.privateKeyFile;
            };
          };
        };
      };
      services = {
        ssh-agent = {
          enable = true;
        };
      };
      systemd = {
        user = {
          services = {
            ssh-agent-add-key = {
              Unit = {
                Description = "Adds the user's ssh key to ssh-agent.";
                After = [ "ssh-agent.service" ];
              };
              Service = {
                Type = "oneshot";
                ExecStart = "${pkgs.openssh}/bin/ssh-add ${options.privateKeyFile}";
              };
              Install = {
                WantedBy = [ "default.target" ];
              };
            };
          };
        };
      };
      home = {
        file = {
          "${config.home.homeDirectory}/.ssh/known_hosts".text = ''
            github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
            gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
          '';
        };
      };
    };
}
