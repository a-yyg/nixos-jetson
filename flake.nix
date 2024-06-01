{
  description = "Nvidia Jetson Xavier AGX";
  inputs.nixpkgs.url = "nixpkgs/nixos-23.11";
  inputs.jetpack.url = "github:anduril/jetpack-nixos/8f27a0b1406c628b47cfd36932d70a96baf90d72";
  nixConfig = {
    extra-trusted-substituters = [ "https://cuda-maintainers.cachix.org" ];
    extra-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
  };

  outputs = { self, nixpkgs, jetpack, ... }: {
    nixosConfigurations.agx = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        jetpack.nixosModules.default
        # ./nixos/configuration.nix
 	./modules/agx-hardware.nix
 	./modules/filesystem.nix
 	{ # Nix-related
           nixpkgs.config.allowUnfree = true;
           nix.extraOptions = "experimental-features = nix-command flakes ca-derivations";
           nix.settings.substituters = [ "https://cuda-maintainers.cachix.org" ];
           nix.settings.trusted-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
           nix.package = nixpkgs.legacyPackages.aarch64-linux.nixVersions.nix_2_18;
           nix.nixPath = [ "nixpkgs=/etc/nixos/nixpkgs" "nixos-config=/etc/nixos/config" ];
 	}
	{ # SSH
          services.openssh.enable = true;
	}
 	{ # User
           networking.hostName = "agx";
           system.stateVersion = "23.11";
 
           users.mutableUsers = true;
           users.users.nixos = {
             isNormalUser = true;
             extraGroups = [ "wheel" ];
             uid = 1000;
           };
         }
      ];
    };
  };
}
