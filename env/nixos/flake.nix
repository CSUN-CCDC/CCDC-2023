{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-generators, ... }: {
    packages.x86_64-linux = {
      vmwareDev = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          # you can include your own nixos configuration here, i.e.
           ./configuration.nix
        ];
        format = "vmware";
        
        # optional arguments:
        # explicit nixpkgs and lib:
        # pkgs = nixpkgs.legacyPackages.x86_64-linux;
        # lib = nixpkgs.legacyPackages.x86_64-linux.lib;
        # additional arguments to pass to modules:
        # specialArgs = { myExtraArg = "foobar"; };
        
        # you can also define your own custom formats
        # customFormats = { "myFormat" = <myFormatModule>; ... };
        # format = "myFormat";
      };
      vboxDev = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "virtualbox";
        modules = [
            ./configuration.nix
        ];
      };

      hypervDev = nixos.generators.nixosGenerate {
        system = "x86_64-linux";
        format = "hyperv";
        modules = [
            ./configuration.nix
        ];
      };
    };
  };
}