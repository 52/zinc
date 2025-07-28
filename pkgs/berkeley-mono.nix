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
    sha256 = "c75105522ac76d33be9e5c76e956e5fcf73eaa0c16d016317bdc1d5ec5456e36";
    message = ''
      Berkeley Mono is a paid font, please download it from ${url},
      and add it to the nix store with the following command:

      nix-store --add-fixed sha256 /path/to/${name}

      Then, compute the SHA256 hash with the following command:

      sha256sum /path/to/${name} | cut -d' ' -f1

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
    find . -name "*.otf" -exec install -Dm644 {} -t $out/share/fonts/opentype \;

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
