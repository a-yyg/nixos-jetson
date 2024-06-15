{ lib, pkgs, config, ... }:
{
  imports = [
    ./nvim.nix
  ];
  
  home.stateVersion = "23.05";
}

