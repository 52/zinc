{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  inherit (config) home;
  inherit (home) username homeDirectory;
in
{
  options = {
    ssh = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      identityFile = mkOption {
        type = types.str;
        default = "${homeDirectory}/.ssh/id_${username}";
      };
      publicKeyFile = mkOption {
        type = types.str;
        default = "${homeDirectory}/.ssh/id_${username}.pub";
      };
      allowedSignersFile = mkOption {
        type = types.str;
        default = "${homeDirectory}/.ssh/allowed_signers";
      };
    };
  };
  config =
    let
      inherit (config) ssh;
    in
    mkIf ssh.enable {
      programs = {
        ssh = {
          inherit (ssh) enable;
          addKeysToAgent = "yes";
          extraConfig = ''
            HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com
            PubkeyAcceptedAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com
          '';
          matchBlocks = {
            "git" = {
              inherit (ssh) identityFile;
              identitiesOnly = true;
              host = "gitlab.com github.com";
              user = "git";
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
                ExecStart = "${pkgs.openssh}/bin/ssh-add ${ssh.identityFile}";
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
          "${homeDirectory}/.ssh/known_hosts".text = ''
            github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
            gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
          '';
        };
      };
    };
}
