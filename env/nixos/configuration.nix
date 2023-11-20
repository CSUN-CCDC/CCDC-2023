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
        nmap
        masscan
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
        shellcheck
        (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions; [
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
                {
                    name = "ansible";
                    publisher = "redhat";
                    version = "2.8.108";
                    sha256 = "sha256-67YAcxCsXiocltNhJuuCU1R3itRJYJoXEA7EFXjDx5g=";
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
