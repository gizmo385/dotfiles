{
  pkgs ? import <nixpkgs> {},
  distro ? "Linux_x86_64",
  version ? "0.0.17",
  sha256 ? "sha256-3J1ar5DebEbEe7mj2UnTrylUfpBcpeQyywurUdKH3sI"
}:

let
  url = "https://github.com/refaktor/rye/releases/download/v${version}/rye_${distro}.tar.gz";
in
pkgs.stdenv.mkDerivation {
  name = "ryelang";

  src = pkgs.fetchzip {
    inherit url sha256;
    stripRoot = false;
  };

  installPhase = "
    mkdir -p $out/bin
    cp rye $out/bin
  ";

}
