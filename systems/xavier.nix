{ pkgs, ... }@args:
let
  xavier = import ./jetson.nix ({
    hostname = "xavier";
    modules = [
      ../modules/xavier-hardware.nix
      {
        age.secrets.tailscale.file = ../secrets/tailscale.age;
        age.secrets.cachix-xavier.file = ../secrets/cachix-xavier.age;
      }
      ({ config, ... }: {
        services.cachix-watch-store = {
          enable = true;
          cacheName = "a-yyg";
          cachixTokenFile = config.age.secrets.cachix-xavier.path;
        };
      })
      ({ config, ... }: { # Tailscale
        environment.systemPackages = [ pkgs.tailscale ];
        services.tailscale.enable = true;
        services.tailscale.authKeyFile = config.age.secrets.tailscale.path;

        services.resolved = {
          enable = true;
          fallbackDns = [ "1.1.1.1#one.one.one.one" ];
        };
      })
    ];
  } // args);
in xavier
