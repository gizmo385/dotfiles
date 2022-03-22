let
  pkgs = import <nixpkgs> {};
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
    pkgs.git
    pkgs.gitAndTools.delta
    pkgs.htop
    pkgs.jq
    pkgs.leiningen
    pkgs.neovim
    pkgs.nodejs
    pkgs.python39Packages.python-lsp-server
    pkgs.python3Full
    pkgs.ripgrep
    pkgs.rust-analyzer
    pkgs.tmux
    pkgs.vim
    pkgs.watch
    pkgs.wget
    pkgs.yq
    pkgs.zsh
  ];

  # Linux-specific packages
  linuxPackages = [pkgs.gcc];
  # MacOS-specific packages
  darwinPackages = [
    pkgs.font-awesome
    pkgs.nerdfonts
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
