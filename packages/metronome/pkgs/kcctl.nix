{ stdenv, lib, fetchurl, ... }: stdenv.mkDerivation rec {
  pname = "kcctl";
  version = "1.0.0.CR4";
  artifact =
    if stdenv.isDarwin && stdenv.isAarch64 then
      "${pname}-${version}-osx-aarch_64"
    else throw "Unsupported system: ${stdenv.system}";

  src = fetchurl {
    url = "https://github.com/kcctl/kcctl/releases/download/v${version}/${artifact}.tar.gz";
    hash = "sha256-W2FV6g7BQenU9+qEId0EJl/PuZ0a0rXacdN51e9/Y3M=";
  };

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    install -m755 -D ${artifact}/bin/kcctl $out/bin/kcctl
    runHook postInstall
  '';

  meta = with lib; {
    description = "A modern and intuitive command line client for Kafka Connect";
    homepage = "https://github.com/kcctl/kcctl";
    license = licenses.asl20;
    platforms = [ "aarch64-darwin" ];
  };
}

