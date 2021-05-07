{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  environment.systemPackages =
    [
        pkgs.vim
        pkgs.fira-code
        pkgs.jq
        pkgs.ripgrep
        pkgs.docker
        pkgs.nodejs
        pkgs.python38
        pkgs.clojure
        pkgs.skhd
        pkgs.chunkwm
        pkgs.neovim
    ];

  nixpkgs.overlays = [
   (self: super: {
     neovim = super.neovim.override {
       viAlias = true;
       vimAlias = true;
     };
   })
 ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

 # Fonts
  fonts = {
    enableFontDir = true;
    fonts = [ pkgs.fira-code ];
  };

  # Shell
  programs.bash.enable = false;
  programs.zsh.enable = true;
}
