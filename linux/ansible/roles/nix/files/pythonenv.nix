# { pkgs ? import <nixpkgs> { } }:
{ pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz) { } }:

let
  my-python-packages = ps: with ps; [
    #dnspython
    #jmespath
    sqlalchemy
    mysqlclient
    psycopg2
    requests
    pyopenssl
    pymongo
    #pywinrm
    # other python packages

  ];
in
with pkgs;
mkShell {
  LC_ALL = "C.UTF-8";
  LANG = "C.UTF-8";
  ANSIBLE_HOST_KEY_CHECKING = "False";
  VAGRANT_WSL_ENABLE_WINDOWS_ACCESS = "1";
  buildInputs = [
    (pkgs.python311.withPackages my-python-packages)
  ];
  shellHook = ''
    echo "${(pkgs.python311.withPackages my-python-packages).outPath}/bin/python3"
    # Your post-shell hook commands go here
  '';
}
