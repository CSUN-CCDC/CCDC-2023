# { pkgs ? import <nixpkgs> { } }:
{ pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz) { } }:
let
vscodeWithExtensions = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscode;
    vscodeExtensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        ms-python.python
        ms-pyright.pyright
        ms-python.vscode-pylance
        mads-hartmann.bash-ide-vscode
        ms-vscode.powershell
        redhat.vscode-yaml
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
                name = "quarto";
                publisher = "quarto";
                version = "1.107.0";
                sha256 = "sha256-wRAB9C1vBgqI/+mhyz4nfvLgHzYKEmAYs1R5Nbdl490=";
            }
            # {
            #     name = "vscode-yaml";
            #     publisher = "redhat";
            #     version = "1.14.0";
            #     sha256 = "sha256-hCRyDA6oZF7hJv0YmbNG3S2XPtNbyxX1j3qL1ixOnF8=";
            # }
            {
                name = "ansible";
                publisher = "redhat";
                version = "2.8.108";
                sha256 = "sha256-67YAcxCsXiocltNhJuuCU1R3itRJYJoXEA7EFXjDx5g=";
            }
        ];
};

in
with pkgs;
mkShell {
  allowUnfree = true;
  buildInputs = [
    powershell
    shellcheck
    vscodeWithExtensions
  ];
}
