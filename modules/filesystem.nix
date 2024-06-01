{ config, lib, pkgs, modulesPath, ... }:

{
  # "/dev/disk/by-uuid/9d596c98-5413-41d9-bcb4-be5c9188e649"
  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  # "/dev/disk/by-uuid/479A-EEAA";
  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices = [ ];
}
