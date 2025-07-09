{
  lib,
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
        # Enable ssh, see: https://www.openssh.com/
        programs.ssh = {
          enable = true;

          # Automatically add keys to 'ssh-agent'.
          addKeysToAgent = "yes";

          # Restrict to secure algorithms only.
          extraConfig = ''
            HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com
            PubkeyAcceptedAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com 
          '';
        };

        # Enable ssh-agent, see: https://en.wikipedia.org/wiki/Ssh-agent/
        services.ssh-agent.enable = true;
      }

      (mkIf cfg.enableGitIntegration {
        # Add match blocks for common git hosts.
        programs.ssh.matchBlocks."git" = {
          # Set user for authentication.
          user = "git";

          # Match on 'github' and 'gitlab' hosts.
          host = "github.com gitlab.com";

          # Set the private key file.
          identityFile = cfg.privateKeyFile;

          # Only use specified identity.
          identitiesOnly = true;
        };

        # Enable signed git commits.
        programs.git = {
          signing = {
            # Sign commits by default.
            signByDefault = true;

            # Set the public key file.
            key = cfg.publicKeyFile;
          };

          extraConfig = {
            # Use ssh for signing.
            gpg.format = "ssh";

            # Rewrite 'https' to 'ssh' for git hosts.
            url = {
              "ssh://git@github.com".insteadOf = "https://github.com";
              "ssh://git@gitlab.com".insteadOf = "https://gitlab.com";
            };
          };
        };

        # Add common git services to 'known_hosts'.
        home.file.".ssh/known_hosts".text = ''
          github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
          gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
        '';
      })
    ]
  );
}
