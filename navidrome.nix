{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.navidrome = {
    enable = true;
 settings = {
    Address = "0.0.0.0";
    DataFolder = "/mnt/audio/data";
    MusicFolder = "/mnt/audio/music";
  };

    plugins = with pkgs.navidromePlugins; [
      apple-music
      listenbrainz-daily-playlist
    ];

    # The lyrics plugin bundle is named lyrics-plugin.ndp.
    settings.LyricsPriority = ".ttml,.yaml,.yml,.elrc,.srt,lyrics-plugin,embedded,.lrc,.txt";
  };
  services.caddy.virtualHosts."http://music.pi" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:4533
    '';
  };
  services.caddy.virtualHosts."https://music.pi" = {
    extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:4533
    '';
  };
}
