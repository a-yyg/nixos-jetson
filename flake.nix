{                                                                             
  description = "Nvidia Jetson Xavier AGX";                                  
  inputs.nixpkgs.url = "nixpkgs/nixos-23.11";
  inputs.jetpack.url = "github:anduril/jetpack-nixos/8f27a0b1406c628b47cfd36932d70a96baf90d72";
  nixConfig = {                                                                                                
    extra-trusted-substituters = [ "https://cuda-maintainers.cachix.org" ];     
    extra-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
  };
  inputs.agenix.url = "github:ryantm/agenix";

  inputs.deploy-rs = {
    url = "github:serokell/deploy-rs";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { self, nixpkgs, jetpack, agenix, deploy-rs, ... }: {
    nixosConfigurations.agx =
    let   
      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };                                      
    in   
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        jetpack.nixosModules.default
        agenix.nixosModules.default
        {
          age.secrets.tailscale.file = ./secrets/tailscale.age;
        }
        # ./nixos/configuration.nix
        ./modules/agx-hardware.nix
        ./modules/filesystem.nix
        { # Nix-related
           nixpkgs.config.allowUnfree = true;
           nix.extraOptions = "experimental-features = nix-command flakes ca-derivations";
           nix.settings.substituters = [ "https://cuda-maintainers.cachix.org" ];
           nix.settings.trusted-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
           nix.package = nixpkgs.legacyPackages.aarch64-linux.nixVersions.nix_2_18;
           # nix.nixPath = [ "nixpkgs=/etc/nixos/nixpkgs" "nixos-config=/etc/nixos/config" ];
        }
        { # SSH
          services.openssh = {
            enable = true;
            permitRootLogin = "yes";
          };
        }
        ({ config, ... }: { # Tailscale
          environment.systemPackages = [ pkgs.tailscale ];
          services.tailscale.enable = true;
          services.tailscale.authKeyFile = config.age.secrets.tailscale.path;

          services.resolved = {
            enable = true;
            fallbackDns = [ "1.1.1.1#one.one.one.one" ];
          };
        })
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
         {
           users.users.nixos = {
             extraGroups = [ "docker" ];
           };
           virtualisation.docker.rootless = {
             enable = true;
             setSocketVariable = true;
           };
         }
         { # Utils
           environment.systemPackages = with pkgs; [
             neovim
             git
             tmux
           ];
         }
      ];
    };


    deploy = {
      sshUser = "root";
      user = "root";
      sshOpts = [ "-i" "/home/momonga/.ssh/xavier" ];
      autoRollback = false;
      magicRollback = false;
      remoteBuild = true;

      nodes = {
        "agx" = {
          hostname = "100.74.155.72";
          profiles.system = {
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.agx;
          };
        };
      };
    };
  };
}
