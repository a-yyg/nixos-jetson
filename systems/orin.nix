{ ... }@args:
let
  orin = import ./jetson.nix ({
    hostname = "orin";
    modules = [
      ../modules/orin-hardware.nix
      {
        age.secrets.cachix-orin.file = ../secrets/cachix-orin.age;
      }
      ({ config, ... }: {
        services.cachix-watch-store = {
          enable = true;
          cacheName = "a-yyg";
          cachixTokenFile = config.age.secrets.cachix-orin.path;
        };
      })
    ];
  } // args);
in orin
