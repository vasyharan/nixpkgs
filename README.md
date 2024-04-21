# Activate 

## nix-darwin
`nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake .#thinktank`

## home-manager standalone
`nix --extra-experimental-features nix-command --extra-experimental-features flakes run -v github:nix-community/home-manager -- switch --flake .#web0`
