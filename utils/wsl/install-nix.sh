curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install


sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs 


sudo nix-channel --update
