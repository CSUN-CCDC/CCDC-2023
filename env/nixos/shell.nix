# { pkgs ? import <nixpkgs> { } }:
{ pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz) { } }:


with pkgs;
mkShell {
  allowUnfree = true;
  buildInputs = [
    (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions; [
            bbenoist.nix
            ms-azuretools.vscode-docker
            ms-vscode-remote.remote-ssh
            ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                {
                    name = "quarto";
                    publisher = "quarto";
                    version = "1.107.0";
                    sha256 = "sha256-wRAB9C1vBgqI/+mhyz4nfvLgHzYKEmAYs1R5Nbdl490=";
                }
                {
                    name = "vscode-yaml";
                    publisher = "redhat";
                    version = "1.14.0";
                    sha256 = "sha256-hCRyDA6oZF7hJv0YmbNG3S2XPtNbyxX1j3qL1ixOnF8=";
                }
            ];
        })
  ];
}
