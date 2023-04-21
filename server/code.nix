{ config, pkgs, lib, ... }:

{
  users.users.code = {
    password = "Z@gl2001code";
    isNormalUser = true;
    description = "vscode";
    createHome = true;
    home = "/home/code";
    homeMode = "777";
    extraGroups = [ "networkmanager" "wheel" "docker" "code-server" ];
    packages = with pkgs; [
      unstable.nodejs-16_x
    ];
  };

  services.code-server = {
    enable = false;
    user = "code";
  };
}
