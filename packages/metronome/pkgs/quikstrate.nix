{ lib, fetchFromGitHub, buildGoModule, ... }: buildGoModule rec {
  pname = "quikstrate";
  version = "1.0.23";
  src = fetchFromGitHub {
    owner = "Metronome-Industries";
    repo = "quikstrate";
    rev = version;
    hash = "sha256-dIga0pVrbnC/75ERUd1miz/HWUC7gOTToGxaU8MF+7o=";
  };
  vendorHash = "sha256-3iHBi9t9yUa+z7AM08zMVi7ReSXPPK/inGpmacmahvA=";

  meta = with lib; {
    description = "Wrapper of substrate CLI to cache credentials for faster authentication and configure aws and kubectl config files for easier profile and context switching.";
    homepage = "https://github.com/Metronome-Industries/quikstrate";
    platforms = [ "aarch64-darwin" ];
  };
}
