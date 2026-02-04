{ lib, fetchurl, stdenv, ... }: stdenv.mkDerivation rec {
  pname = "substrate";
  version = "2024.08";
  artifact =
    if stdenv.isDarwin && stdenv.isAarch64 then
      "substrate-${version}-darwin-arm64"
    else throw "Unsupported system: ${stdenv.system}";

  src = fetchurl {
    url = "https://src-bin.com/${artifact}.tar.gz";
    hash = "sha256-WUmWGC0HXoPmM1IuAk/e1z3erAnc1NYxZuotvbvlEPM=";
  };
  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    install -m755 -D ${artifact}/bin/substrate $out/bin/substrate
    runHook postInstall
  '';
}
