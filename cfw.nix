{ lib, pkgs, config, ... }:
with lib;
let 
  cfg = config.services.clash-core-service;
in {
  options.services.clash-core-service = {
    enable = mkEnableOption "clash-core-service service";
  };

  config = {
    systemd.services.clash-core-service = {
      wantedBy = ["multi-user.target"];
      serviceConfig.ExecStart = /home/zgl/.config/clash/service/clash-core-service;
    };
  };
}