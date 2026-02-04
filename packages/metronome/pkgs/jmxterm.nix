{ lib, fetchFromGitHub, jre, makeWrapper, maven }:
maven.buildMavenPackage rec {
  pname = "jmxterm";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "jiaqi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sArh0+bz5RUKeo0VejfhJqt7r5Tc2jSp48e8G69tKyM=";
  };

  mvnHash = "sha256-KlUJBYdvkn6xfqomDo3ZUuDAH8av9nqhpXpIWdf8+Jg=";

  doCheck = false;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share
    install -Dm644 target/${pname}-${version}-uber.jar $out/share/jmxterm.jar
    makeWrapper ${jre}/bin/java $out/bin/jmxterm \
      --add-flags "-jar $out/share/jmxterm.jar"
  '';

  meta = with lib; {
    description = "Interactive command line JMX client";
    homepage = "https://github.com/jiaqi/jmxterm";
    license = licenses.asl20;
  };
}
