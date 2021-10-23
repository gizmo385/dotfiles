{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  environment.systemPackages =
    [
      ./dev.nix
      pkgs.awscli
      pkgs.bat
      pkgs.clojure
      pkgs.docker
      pkgs.docker-compose
      pkgs.fd
      pkgs.fish
      pkgs.font-awesome
      pkgs.fzf
      pkgs.gitAndTools.delta
      pkgs.gmp6
      pkgs.htop
      pkgs.j
      pkgs.jq
      pkgs.kubectl
      pkgs.kubernetes-helm
      pkgs.leiningen
      pkgs.neovim
      pkgs.nerdfonts
      pkgs.nodejs
      pkgs.opam
      pkgs.pkg-config
      pkgs.ripgrep
      pkgs.skhd
      pkgs.tmux
      pkgs.vim
      pkgs.watch
      pkgs.wget
      pkgs.yabai
      pkgs.yq

      # Node Packages
      pkgs.nodePackages.pyright
      pkgs.nodePackages.typescript-language-server
    ];

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
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Enable/Disable services
  services.skhd.enable = true;
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
  };

}
