{ config, pkgs, ... }:

let
  packages = import ./packages.nix;
in
{
  # List packages installed in system profile.
  environment.systemPackages = packages.packagesToInstall;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

 # Fonts
 fonts = {
   enableFontDir = true;
   fonts = [ pkgs.nerdfonts pkgs.font-awesome ];
 };

  # Shell
  programs.bash.enable = false;
  programs.fish.enable = true;

  # Enable/Disable services
  services.skhd.enable = true;
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
  };

}
