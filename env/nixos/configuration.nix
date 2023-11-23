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
            {
                name = "ansible";
                publisher = "redhat";
                version = "2.8.108";
                sha256 = "sha256-67YAcxCsXiocltNhJuuCU1R3itRJYJoXEA7EFXjDx5g=";
            }
        ];
};

staticrypt = (pkgs.callPackage ./staticrypt/nodejs-default.nix {}).nodeDependencies; # this gives us the staticrypt npm package

in
{

    
    nixpkgs.config.allowUnfree = true;

    boot.kernelParams = [ "transparent_hugepage=never" ];
    #boot.loader.grub.efiInstallAsRemovable = true;
    # boot.loader.grub = {
    #     enable = true;

    # };

    virtualisation = {
        #useBootLoader = true;
        virtualbox.host = {
            enable = true;
            enableExtensionPack = true;
        };
        virtd.enable = true;
        docker.enable = true;
        vmware.host = {
            enable = true;
        };
    };


    # services.xserver = {
    #     enable = true;
    #     displayManager.sddm.enable = true;
    #     desktopManager.plasma5.enable = true;
    # };

    # environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    #     elisa
    #     gwenview
    #     okular
    #     oxygen
    #     khelpcenter
    #     konqueror
    # ];

    environment.systemPackages = with pkgs; [
        gh
        staticrypt
        firefox
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
        powershell
        vscodeWithExtensions
        texlive.combined.scheme-full
        nmap
        masscan
        virt-manager
        remmina
    ];


    networking.firewall = {
        enable = false;
        #allowedTCPPorts = [ 80 443 ];
    };

    #users.mutableUsers = true;
    users.groups.layer8 = {};
    #users.extraGroups.vboxusers.members = [ "layer8" ];
    users.users.root.password = "layer8";
    users.users.layer8 = {
        isNormalUser = true;
        group = "layer8";
        createHome = true;
        extraGroups = ["wheel" "docker" "libvirt" "kvm" "vboxusers"];
        initialPassword = "layer8";
    };
}
