{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "usb_storage" "mmc_block" "sdhci_tegra" ];
      kernelModules = [ "ahci" "usb_storage" "mmc_block" "sdhci_tegra" ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;

      # AGX Xavier peculiarity.
      # See: https://forums.developer.nvidia.com/t/using-uefi-runtime-variables-on-xavier-agx/227970
      efi.canTouchEfiVariables = true;

      efi.efiSysMountPoint = "/boot";
    };
  };

  hardware = {
    nvidia-jetpack = {
      enable = true;
      som = "orin-agx";
      carrierBoard = "devkit";
    };
    enableAllFirmware = true;
  };
  powerManagement.cpuFreqGovernor = "ondemand"; # from hardware

  nixpkgs.hostPlatform = "aarch64-linux";
  nixpkgs.config.allowUnfree = true;
}
