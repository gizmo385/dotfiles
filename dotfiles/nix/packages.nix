let
  pkgs = import <nixpkgs> {};
  commonPackages = [
    pkgs.awscli
    pkgs.bat
    pkgs.cabal-install
    pkgs.clojure
    pkgs.docker
    pkgs.docker-compose
    pkgs.fd
    pkgs.ffmpeg
    pkgs.fish
    pkgs.fzf
    pkgs.ghc
    pkgs.git
    pkgs.gitAndTools.delta
    pkgs.htop
    pkgs.jq
    pkgs.leiningen
    pkgs.neovim
    pkgs.nodePackages.livedown
    pkgs.nodePackages.pyright
    pkgs.nodePackages.typescript-language-server
    pkgs.nodejs
    pkgs.python3Full
    pkgs.ripgrep
    pkgs.tmux
    pkgs.vim
    pkgs.watch
    pkgs.wget
    pkgs.yq
    pkgs.zsh
  ];

  # Linux-specific packages
  linuxPackages = [];
  # MacOS-specific packages
  darwinPackages = [
    pkgs.font-awesome
    pkgs.nerdfonts
    pkgs.skhd
    pkgs.yabai
  ];
  packagesToInstall = commonPackages
  ++ (if pkgs.stdenv.isLinux then linuxPackages else [])
  ++ (if pkgs.stdenv.isDarwin then darwinPackages else []);
in
  {
    commonPackages = commonPackages;
    linuxPackages = linuxPackages;
    darwinPackages = darwinPackages;
    packagesToInstall = packagesToInstall;
  }
