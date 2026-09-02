{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.navidrome = {
    enable = true;
    settings.MusicFolder = "/mnt/audio/music";

    plugins = with pkgs.navidromePlugins; [
      audiomuseai
      apple-music
      listenbrainz-daily-playlist
      lyrics-plugin
    ];

    # The lyrics plugin bundle is named lyrics-plugin.ndp.
    settings.LyricsPriority = ".ttml,.yaml,.yml,.elrc,.srt,lyrics-plugin,embedded,.lrc,.txt";
  };
}
