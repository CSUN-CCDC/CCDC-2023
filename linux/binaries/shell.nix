# { pkgs ? import <nixpkgs> { } }:
{ pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz) { } }:

let
  my-python-packages = ps: with ps; [
    ansible
    ansible-core
    # other python packages
  ];
in
with pkgs;
mkShell {
  LC_ALL = "C.UTF-8";
  LANG = "C.UTF-8";
  buildInputs = [
    zellij
    fsearch
    fd
    (pkgs.python311.withPackages my-python-packages)
    ansible-lint
  ];
}
