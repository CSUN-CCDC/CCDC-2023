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

    #boot.loader.grub.efiInstallAsRemovable = true;
    # boot.loader.grub = {
    #     enable = true;

    # };

    virtualisation = {
        #useBootLoader = true;
        #virtualbox.host = {
        #    enable = true;
        #    enableExtensionPack = true;
        #};
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


    networking.firewall.allowedTCPPorts = [80];

    system.stateVersion = lib.version;

    #users.mutableUsers = true;
    users.groups.layer8 = {};
    users.extraGroups.vboxusers.members = [ "layer8" ];
    users.users.root.password = "layer8";
    users.users.layer8 = {
        isNormalUser = true;
        group = "layer8";
        createHome = true;
        extraGroups = ["wheel" "docker" "libvirt" "kvm"];
        initialPassword = "layer8";
    };
}
