{
    description = "Slarkarus's NixOS configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        }; 
    };

    outputs = 
        {
            self,
            nixpkgs,
            home-manager,
            ...
        }@inputs:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {inherit system; };
        hostName = "carbon";
    in
    {
        nixosConfigurations."${hostName}" = nixpkgs.lib.nixosSystem {
            system = system;

            specialArgs = {
                inherit hostName;
                inherit system;
                inherit inputs;
            };

            modules = [
                ./configuration.nix
                home-manager.nixosModules.home-manager
            ];
        };

        devShells."${system}".default = pkgs.mkShell {
            packages = with pkgs; [ git ];

            shellHook = ''
                # Ensure that hooks run before commit
                git config core.hooksPath .githooks
            '';

            name = "carbon";
        };
    };
}