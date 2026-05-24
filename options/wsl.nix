{ pkgs, ... }:

{
  config = {
    gizmo = {
      username = "gizmo";

      languages = {
        rust = {
          toolchain = true;
          lsp = true;
        };
      };
    };

    # wslu (which provides wslview) isn't packaged in nixpkgs, so point xdg-open
    # consumers at Windows' explorer.exe to handle URL launches from WSL.
    home.sessionVariables.BROWSER = "/mnt/c/Windows/explorer.exe";

    # paplay (from pulseaudio) is used for audio notifications; WSLg routes it
    # to the host's audio device via the built-in PulseAudio server.
    home.packages = [ pkgs.pulseaudio ];
  };
}
