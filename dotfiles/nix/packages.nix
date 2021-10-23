let
  pkgs = import <nixpkgs> {};
  commonPackages = [
    pkgs.awscli
    pkgs.bat
    pkgs.clojure
    pkgs.docker
    pkgs.docker-compose
    pkgs.fd
    pkgs.ffmpeg
    pkgs.fish
    pkgs.font-awesome
    pkgs.fzf
    pkgs.gcc
    pkgs.git
    pkgs.gitAndTools.delta
    pkgs.htop
    pkgs.jq
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.leiningen
    pkgs.neovim
    pkgs.nerdfonts
    pkgs.nodePackages.pyright
    pkgs.nodePackages.typescript-language-server
    pkgs.nodejs
    pkgs.opam
    pkgs.python3Full
    pkgs.ripgrep
    pkgs.rustup
    pkgs.tmux
    pkgs.vim
    pkgs.watch
    pkgs.wget
    pkgs.yq
    pkgs.zsh
  ];

  # Linux-specific packages
  linuxPackages = [
    pkgs.terminator
  ];
  # MacOS-specific packages
  darwinPackages = [
    pkgs.yabai
    pkgs.skhd
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
