{
  lib,
  xorg,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "berkeley-mono";
  version = "1.0";

  src = ../../nix-secrets/fonts/berkeley-mono;

  nativeBuildInputs = [
    xorg.mkfontscale
    xorg.mkfontdir
  ];

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
