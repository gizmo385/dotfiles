{ pkgs ? import <nixpkgs> {} }:

let
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
    pkgs.git
    pkgs.gitAndTools.delta
    pkgs.htop
    pkgs.j
    pkgs.jq
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.leiningen
    pkgs.neovim
    pkgs.nerdfonts
    pkgs.nodePackages.pyright
    pkgs.nodePackages.typescript-language-server
    pkgs.nodejs
    pkgs.python3Full
    pkgs.ripgrep
    pkgs.rustup
    pkgs.tmux
    pkgs.vim
    pkgs.watch
    pkgs.wget
    pkgs.yq
  ];
  # Linux-specific packages
  linuxPackages = [
    pkgs.terminator
  ];
  # MacOS-specific packages
  darwinPackages = [
    pkgs.yabai
    pkgs.skhd
    pkgs.iterm2
  ];
  packagesToInstall = commonPackages
  ++ (if pkgs.stdenv.isLinux then linuxPackages else [])
  ++ (if pkgs.stdenv.isDarwin then darwinPackages else []);
in
pkgs.buildEnv {
  name = "dev-env";
  paths = packagesToInstall;
}
