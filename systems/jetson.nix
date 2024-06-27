{ nixpkgs, jetpack, agenix, home-manager, nixvim, ... }@args:
let
  system = "aarch64-linux";
  pkgs = import nixpkgs {
    inherit system;
    overlays = [
      jetpack.overlays.default
    ];
  };
in
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    jetpack.nixosModules.default
    agenix.nixosModules.default
    ../modules/filesystem.nix
    { # Nix-related
      nixpkgs.config.allowUnfree = true;
      nix.extraOptions = "experimental-features = nix-command flakes ca-derivations";
      nix.settings.extra-substituters = [
        "https://cache.nixos.org"
        "https://cuda-maintainers.cachix.org"
        "https://a-yyg.cachix.org"
        "https://ros.cachix.org"
      ];
      nix.settings.extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "a-yyg.cachix.org-1:VZj4h48OUiblqC5VSFN3ideB+E1oh5BoGzonCqGSsAU="
        "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
      ];

      nix.package = nixpkgs.legacyPackages.aarch64-linux.nixVersions.nix_2_18;
      nixpkgs.overlays = [
        jetpack.overlays.default
      ];
      nix.settings.trusted-users = [ "nixos" ]; # change later
    }
    { # SSH
      services.openssh = {
        enable = true;
        permitRootLogin = "yes";
      };
    }
    { # User
      networking.hostName = args.hostname;
      system.stateVersion = "23.11";

      users.mutableUsers = true;
      users.users.nixos = {
        isNormalUser = true;
        extraGroups = [ "wheel" "video" ];
        uid = 1000;
      };
      # users.users.nixremote = {
      #   isNormalUser = true;
      #   extraGroups = [ "wheel" ];
      #   uid = 1001;
      # }; 
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
        # neovim
        git
        # tmux
        # nvidia-jetpack.l4t-gstreamer
        # nvidia-jetpack.l4t-multimedia
      ];
    }
    {
      fileSystems."/nfs" = {
        device = "192.168.151.39:/export";
        fsType = "nfs";
      };
      fileSystems."/hdd" = {
        device = "192.168.151.39:/mnt/hdd";
        fsType = "nfs";
      };
    }
    home-manager.nixosModules.home-manager {
      home-manager.users.nixos = {
        imports = [
          nixvim.homeManagerModules.nixvim
          ../home-modules/home.nix
        ];
      };
    }
  ] ++ (args.modules or []);
}
