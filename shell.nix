{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = [
    pkgs.unstable.rnix-lsp
  ];

  shellHook = ''
    # ...
  '';
}
