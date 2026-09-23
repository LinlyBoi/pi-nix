{ config, pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    hostName = "raspberrypi";
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/etc/nextcloud/admin-pass";
    };
  settings = {
    trusted_domains = [ "raspberrypi" "nextcloud.pi" ];
    overwriteprotocol = "https"; # Use "https" if you set up TLS in Caddy later
  };
};
  # Configure Nextcloud's trusted domains so it accepts proxy requests from Caddy

# Shift NGINX (Nextcloud's default backend) off port 80 onto 8080
  services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
  listen = [
    {
      addr = "127.0.0.1";
      port = 8080;
    }
  ];
};

# Route nextcloud.pi from Caddy to NGINX on port 8080
  services.caddy.virtualHosts."http://nextcloud.pi" = {
    extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:8080
    '';
  };
  services.caddy.virtualHosts."https://nextcloud.pi" = {
    extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:8080
    '';
  };
}
