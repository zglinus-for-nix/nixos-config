{ config, pkgs, lib, ... }:

{
  users.users.code = {
    group = "code";
    password = "Z@gl2001code";
    isNormalUser = true;
    description = "vscode";
    createHome = true;
    home = "/home/code";
    homeMode = "777";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  services.code-server = { 
    enable = true;
    user = "code";
    group = "code";
  };
}
