{ pkgs, ... }:
{
  programs.yt-dlp = {
    enable = true;
    settings = {
      cookies-from-browser = "firefox";
      js-runtimes = "deno:${pkgs.deno}/bin/deno"; # force this for resonite
    };
  };
}
