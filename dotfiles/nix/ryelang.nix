{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "ryelang";

  src = pkgs.fetchzip {
    url = "https://github.com/refaktor/rye/releases/download/v0.0.17/rye_Linux_x86_64.tar.gz";
    sha256 = "sha256-3J1ar5DebEbEe7mj2UnTrylUfpBcpeQyywurUdKH3sI";
    stripRoot = false;
  };

  installPhase = "
    mkdir -p $out/bin
    cp rye $out/bin
  ";

}
