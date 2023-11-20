{
    config,
    lib,
    pkgs,
    ...
}: 

let

my-python-packages = ps: with ps; [
    ansible
    ansible-core
    molecule
    molecule-plugins
    dnspython
    # other python packages
  ];


in
{
    nixpkgs.config.allowUnfree = true;

    virtualisation = {
        virtualbox.host = {
            enable = true;
            enableExtensionPack = true;
        };
        libvirtd.enable = true;
        docker.enable = true;

    };


    services.xserver = {
        enable = true;
        displayManager.sddm.enable = true;
        desktopManager.plasma5.enable = true;
    };


    environment.systemPackages = with pkgs; [
        vscode-fhs
        quarto
        podman
        podman-compose
        zellij
        vagrant
        openssh
        sshpass
        sshs
        (pkgs.python311.withPackages my-python-packages)
        sshfs
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
                    sha256 = "sha256-VnEqqS/2eQxdvq1DzOylNpb3fo2lmAcBJ8BxDj1JArs=";
                }
                {
                    name = "YAML";
                    publisher = "redhat";
                    version = "1.14.0";
                    sha256 = "sha256-vapZKVBoDln12aBTUG9ipW425FXTWBqhjX2mQf+BAZw=";
                }
            ];
        })
    ];


    networking.firewall.allowedTCPPorts = [80];

    system.stateVersion = lib.version;

    #users.mutableUsers = true;
    extraGroups.vboxusers.members = [ "layer8" ];
    users.users.root.password = "layer8";
    users.users.layer8 = {
        createHome = true;
        extraGroups = ["wheel" "docker" "libvirt" "kvm"];
        initialPassword = "layer8"
    }
    services.openssh.settings.PermitRootLogin = lib.mkDefault "yes";
}