{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hledger
  ];
  services.hledger-web = {
    enable = true;
    # Address and port to listen on
    host = "0.0.0.0";
    port = 5000;
    
    # Permission level: "view", "add", or "edit"
    allow = "add"; 
    
    # Path to your journal files (relative to stateDir or absolute)
    journalFiles = [ "finances.ledger" ];
    stateDir = "/var/lib/hledger-web";
  };

  # networking.firewall = {
  #   allowedTCPPorts = [
  #     5000
  #   ];
  # };
  services.caddy.virtualHosts."http://ledger.pi" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:5000
    '';
  };
}
