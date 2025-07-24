{
  inputs,
  ...
}:
rec {
  ## Convert a path to a relative path from the flake root.
  ##
  ## ```nix
  ## relativePath "system/audio.nix"
  ## ```
  ##
  #@ String -> Path
  relativePath = path: "${inputs.self}/${path}";

  ## Read the contents of a file from a path relative to the flake root.
  ##
  ## ```nix
  ## readFileRelative "bin/mx"
  ## ```
  ##
  #@ String -> String
  readFileRelative = path: builtins.readFile (relativePath path);

  ## Filter a list of filenames by extension.
  ##
  ## ```nix
  ## filterExt "rs" [ "main.rs" "rust-toolchain" ]
  ## ```
  ##
  #@ String -> [String] -> [String]
  filterExt = ext: files: builtins.filter (name: builtins.match ".*\\.${ext}" name != null) files;

  ## Import all '.nix' files from a directory.
  ##
  ## ```nix
  ## importAll "system"
  ## ```
  ##
  #@ String -> [Path]
  importAll =
    dir:
    map (name: relativePath dir + "/${name}") (
      filterExt "nix" (builtins.attrNames (builtins.readDir (relativePath dir)))
    );

  ## Create a system user with a home-manager configuration.
  ##
  ## ```nix
  ## mkUser {
  ##   name = "max";
  ##   groups = [ "wheel" "docker" ];
  ##   packages = with pkgs; [ vim git ];
  ##   stateVersion = "24.11";
  ## }
  ## ```
  ##
  #@ AttrSet -> AttrSet
  mkUser =
    {
      ## Name of the system user account.
      ##
      #@ String
      name,

      ## Description of the system user account.
      ##
      #@ String
      description ? "",

      ## List of groups the user belongs to.
      ##
      #@ [String]
      groups ? [ ],

      ## Whether this is a 'real' user account.
      ##
      #@ Bool
      isNormalUser ? true,

      ## List of packages to install for the user.
      ##
      #@ [Package]
      packages ? [ ],

      ## Home-manager modules configuration.
      ##
      #@ AttrSet
      home ? { },

      ## Home-manager state version, see: https://github.com/nix-community/home-manager/issues/5794
      ##
      #@ String
      stateVersion,
    }:
    {
      users.users.${name} = {
        inherit description isNormalUser;
        extraGroups = groups;
      };

      home-manager.users.${name} = {
        home = {
          inherit packages stateVersion;
        };
      } // home;
    };
}
