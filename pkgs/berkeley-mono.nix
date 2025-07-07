{
  lib,
  xorg,
  unzip,
  stdenvNoCC,
  requireFile,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "berkeley-mono";
  version = "1.0";

  src = requireFile rec {
    name = "berkeley-mono.zip";
    url = "https://berkeleygraphics.com/typefaces/berkeley-mono";
    sha256 = "0dkwhgvcim41crx2ixiygylf1a9ycncq7dxsah7mb4m4kbj066wy";
    message = ''
      Berkeley Mono is a paid font, please download it from ${url},
      and add it to the nix store with the following command:

      nix-store --add-fixed sha256 /path/to/${name}

      For more info, see: <https://nixos.org/manual/nixpkgs/stable/#requirefile>
    '';
  };

  nativeBuildInputs = [
    xorg.mkfontscale
    xorg.mkfontdir
    unzip
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    find $src -name "*.otf" -exec install -Dm644 {} -t $out/share/fonts/opentype \;

    mkfontscale "$out/share/fonts/opentype"
    mkfontdir "$out/share/fonts/opentype"
  '';

  meta = with lib; {
    homepage = "https://berkeleygraphics.com/typefaces/berkeley-mono";
    description = "Berkeley Mono";
    platforms = platforms.all;
    license = licenses.unfree;
  };
}
