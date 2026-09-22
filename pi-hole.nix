{ config, lib, pkgs, ... }:

{
  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    openFirewallDHCP = true;
    queryLogDeleter.enable = true;
    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        # Alternatively, use the file from nixpkgs. Note its contents won't be
        # automatically updated by Pi-hole, as it would with an online URL.
        # url = "file://${pkgs.stevenblack-blocklist}/hosts";
        description = "Steven Black's unified adlist";
      }
    ];
    settings = {
      files.pid = "/run/pihole/pihole-flt.pid";
      dns = {
        domainNeeded = true;
        expandHosts = true;
        listeningMode = "ALL";
        upstreams = [ "1.1.1.1" "1.0.0.1" ];
        hosts = [
          "100.64.26.26 music.pi"
          "100.64.26.26 nextcloud.pi"
          "100.64.26.26 hledger.pi"
          "100.64.26.26 pi.hole"
        ];
      };
      dhcp = {
        active = true;
        router = "192.168.10.1";
        start = "192.168.10.2";
        end = "192.168.10.254";
        leaseTime = "1d";
        ipv6 = true;
        multiDNS = true;
        hosts = [
          # Static address for the current host
          "aa:bb:cc:dd:ee:ff,192.168.10.1,${config.networking.hostName},infinite"
        ];
        rapidCommit = true;
      };
      misc.dnsmasq_lines = [
        # This DHCP server is the only one on the network
        "dhcp-authoritative"
        # Source: https://data.iana.org/root-anchors/root-anchors.xml
        "trust-anchor=.,38696,8,2,683D2D0ACB8C9B712A1948B27F741219298D0A450D612C483AF444A4C0FB2B16"
        "address=/.pi/100.64.26.26"
      ];
    };
  };
  services.pihole-web = {
    enable = true;
    ports = [ "6969" ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      53
      6969
    ];
    allowedUDPPorts = [ 53 ];
  };
  services.resolved.settings = {
    Resolve = {
      DNSStubListener = "no";
    };
  };
}
