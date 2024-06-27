{                                                                             
  description = "Nvidia Jetson Xavier AGX";                                  
  nixConfig = {                                                                                                
    extra-trusted-substituters = [ "https://cuda-maintainers.cachix.org" ];     
    extra-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    jetpack.url = "github:anduril/jetpack-nixos/8f27a0b1406c628b47cfd36932d70a96baf90d72";
    agenix.url = "github:ryantm/agenix";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, ... }@inputs:
  let   
    system = "aarch64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
        inputs.jetpack.overlays.default
      ];
    };                                      
  in   {
    nixosConfigurations.xavier = (import ./systems/xavier.nix) {
      inherit (inputs) nixpkgs jetpack agenix home-manager nixvim;
      inherit pkgs;
    };
    nixosConfigurations.orin = (import ./systems/orin.nix) {
      inherit (inputs) nixpkgs jetpack agenix home-manager nixvim;
    };


    deploy = {
      sshUser = "root";
      user = "root";
      sshOpts = [ "-i" "/home/momonga/.ssh/jetson" ];
      autoRollback = false;
      magicRollback = false;
      remoteBuild = true;

      nodes = {
        "xavier" = {
          hostname = "100.74.155.72";
          profiles.system = {
            path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.xavier;
          };
        };
        "orin" = {
          hostname = "192.168.151.140";
          profiles.system = {
            path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.orin;
          };
        };
      };
    };
  };
}
