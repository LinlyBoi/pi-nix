{ pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    hostName = "raspberrypi";
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/etc/nextcloud/admin-pass";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
