{ config, lib, pkgs, ... }:

{
  systemd.services.end0-shaping = {
    description = "Rate limit end0 to 2 Mbit/s";
    wantedBy = [ "multi-user.target" "sys-subsystem-net-devices-end0.device" ];
    after = [ "sys-subsystem-net-devices-end0.device" ];
    bindsTo = [ "sys-subsystem-net-devices-end0.device" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute2}/bin/tc qdisc replace dev end0 root tbf rate 2mbit burst 10kb latency 70ms";
      ExecStop = "${pkgs.iproute2}/bin/tc qdisc del dev end0 root";
    };
  };
}
