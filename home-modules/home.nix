{ lib, pkgs, config, ... }:
{
  imports = [
    ./nvim.nix
  ];
  
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    cachix
  ];
}

