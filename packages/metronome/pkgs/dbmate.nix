{ lib, fetchFromGitHub, buildGoModule, dbmate, ... } @ pkgs:
# https://github.com/NixOS/nixpkgs/issues/86349
let
  version = "1.16.2";
  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    hash = "sha256-5hjAP2+0hbYcA9G7YJyRqqp1ZC8LzFDomjeFjl4z4FY=";
  };
in
dbmate.override rec {
  buildGoModule = args: pkgs.buildGoModule (args // {
    inherit src version;
    vendorHash = "sha256-7fC1jJMY/XK+GX5t2/o/k+EjFxAlRAmiemMcWaZhL9o=";
  });
}
