let
  pkgs = import <nixpkgs> {};
  commonPackages = [
    pkgs.fish
    pkgs.fzf
    pkgs.neovim
    pkgs.vim
    pkgs.zsh
  ];

  # Linux-specific packages
  linuxPackages = [pkgs.git];
  # MacOS-specific packages
  darwinPackages = [
    pkgs.font-awesome
    pkgs.nerdfonts
    pkgs.neovim
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
