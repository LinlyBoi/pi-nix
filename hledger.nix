{ lib, config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hledger
  ];

  services.hledger-web = {
    enable = true;
    host = "127.0.0.1";
    port = 5000;
    allow = "add"; 
    stateDir = "/mnt/hledger/"; 
    
    # Point directly to the exact file path inside Nextcloud storage
    journalFiles = [ "finances.ledger" ];
  };

  # override service user
  systemd.services.hledger-web = {
    serviceConfig = {
      DynamicUser = lib.mkForce false; 

      User = lib.mkForce "nextcloud";
      Group = lib.mkForce "nextcloud";
      ProtectHome = lib.mkForce "no";
      ReadWritePaths = lib.mkForce [ "/mnt/hledger" ];
    };
  };

  services.caddy.virtualHosts."http://ledger.pi" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:5000
    '';
  };
}
