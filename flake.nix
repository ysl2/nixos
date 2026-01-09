{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    noctalia.url = "github:noctalia-dev/noctalia-shell";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {

      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager ({ pkgs, ... }: {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;

            home-manager.users.songliyu = {
              imports = [ 
                inputs.noctalia.homeModules.default
              ];

              programs.noctalia-shell.enable = true;

	      home.stateVersion = "25.11";

              gtk = {
                enable = true;
                
                theme = {
                  name = "Adwaita-dark";
                  package = pkgs.gnome-themes-extra;
                };

                iconTheme = {
                  name = "Adwaita";
                  package = pkgs.adwaita-icon-theme;
                };

                gtk3.extraConfig = {
                  gtk-application-prefer-dark-theme = 1;
                };
                gtk4.extraConfig = {
                  gtk-application-prefer-dark-theme = 1;
                };
              };

              dconf.settings = {
                "org/gnome/desktop/interface" = {
                  color-scheme = "prefer-dark";
                };
              };

            };
          })
        ];
      };
    };
  };
}

