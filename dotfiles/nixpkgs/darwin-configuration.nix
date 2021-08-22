{ config, pkgs, ... }:

{

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages =
    [
      pkgs.awscli
      pkgs.bat
      pkgs.clojure
      pkgs.docker
      pkgs.docker-compose
      pkgs.fira-code
      pkgs.fzf
      pkgs.gitAndTools.delta
      pkgs.htop
      pkgs.j
      pkgs.jq
      pkgs.kubectl
      pkgs.leiningen
      pkgs.mosh
      pkgs.neovim
      pkgs.nodejs
      pkgs.nodePackages.pyright
      pkgs.ripgrep
      pkgs.skhd
      pkgs.tmux
      pkgs.vim
      pkgs.watch
      pkgs.wget
      pkgs.yabai
      pkgs.yq
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

  # Enable/Disable services
  services.skhd.enable = true;
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
  };

}
