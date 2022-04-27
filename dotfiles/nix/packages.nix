let
  pkgs = import <nixpkgs> {};
  nixRelease = hash: (import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz"));
  neovim_pin = nixRelease "9d6d1a474b946c98168bf7fee9e4185ed11cfd8f" {};
  commonPackages = [
    pkgs.awscli
    pkgs.bat
    pkgs.cabal-install
    pkgs.cmake
    pkgs.docker
    pkgs.docker-compose
    pkgs.fd
    pkgs.ffmpeg
    pkgs.fish
    pkgs.fzf
    pkgs.ghc
    pkgs.gitAndTools.delta
    pkgs.htop
    pkgs.leiningen
    pkgs.python39Packages.python-lsp-server
    pkgs.ripgrep
    pkgs.rust-analyzer
    pkgs.tmux
    pkgs.vim
    pkgs.watch
    pkgs.yq
    pkgs.zsh
  ];

  # Linux-specific packages
  linuxPackages = [
    pkgs.python3Full
    pkgs.git
    pkgs.jq
    pkgs.nodejs
    pkgs.wget
  ];
  # MacOS-specific packages
  darwinPackages = [
    pkgs.font-awesome
    pkgs.nerdfonts
    neovim_pin.neovim 
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
