{ config, lib, pkgs, ... }:

{
  networking.interfaces.end0.postUp = "${pkgs.iproute2}/bin/tc qdisc add dev end0 root tbf rate 2mbit burst 10kb latency 70ms";
  networking.interfaces.end0.preDown = "${pkgs.iproute2}/bin/tc qdisc del dev end0 root";

}
