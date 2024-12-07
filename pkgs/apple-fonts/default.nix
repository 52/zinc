{
  lib,
  xorg,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "apple-fonts";
  version = "1.0";

  src = ./.;
  dontBuild = true;
  dontUnpack = true;

  nativeBuildInputs = [
    xorg.mkfontscale
    xorg.mkfontdir
  ];

  installPhase = ''
    mkdir -p $out/share/fonts;
    mkdir -p $out/share/fonts/opentype

    for folder in $src/fonts/*; do
      install -Dm644 "$folder"/*.otf -t $out/share/fonts/opentype
    done

    mkfontscale "$out/share/fonts/opentype"
    mkfontdir "$out/share/fonts/opentype"
  '';

  meta = with lib; {
    homepage = "https://developer.apple.com/fonts";
    description = "Apple Fonts for nixOS";
    platforms = platforms.all;
    license = licenses.unfree;
  };
}
