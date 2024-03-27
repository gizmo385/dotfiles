let
  pkgs = import <nixpkgs> {};
  nixRelease = hash: (import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz"));
  neovim_pin = nixRelease "3e656f7c1d52a257325d28cfb9154c4448f5c69a" {};
  commonPackages = [
    pkgs.bat
    pkgs.cmake
    pkgs.ctags
    pkgs.docker
    pkgs.docker-compose
    pkgs.eza
    pkgs.fd
    pkgs.fish
    pkgs.fzf
    pkgs.gcc9
    pkgs.gitAndTools.delta
    pkgs.htop
    pkgs.leiningen
    pkgs.python3
    pkgs.ripgrep
    pkgs.tmux
    pkgs.vim
    pkgs.watch
    pkgs.yq
    pkgs.zsh
  ];

  # Linux-specific packages
  linuxPackages = [
    pkgs.git
    pkgs.jq
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
