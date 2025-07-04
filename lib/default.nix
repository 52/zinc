{
  inputs,
  ...
}:
rec {
  ## Convert a path to an absolute path from the flake root.
  ##
  ## ```nix
  ## lib.relativePath "system/audio.nix"
  ## ```
  ##
  #@ String -> Path
  relativePath = path: "${inputs.self}/${path}";

  ## Filter a list of filenames by extension.
  ##
  ## ```nix
  ## lib.filterExt "rs" [ "main.rs" "rust-toolchain" ]
  ## ```
  ##
  #@ String -> [String] -> [String]
  filterExt = ext: files: builtins.filter (name: builtins.match ".*\\.${ext}" name != null) files;

  ## Import all '.nix' files from a directory.
  ##
  ## ```nix
  ## lib.importAll "system"
  ## ```
  ##
  #@ String -> [Path]
  importAll =
    dir:
    map (name: relativePath dir + "/${name}") (
      filterExt "nix" (builtins.attrNames (builtins.readDir (relativePath dir)))
    );
}
