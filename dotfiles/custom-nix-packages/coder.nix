{ lib, stdenv, unzip, fetchurl }:

stdenv.mkDerivation rec {
  pname = "coder";
  version = "1.19.0";

  src = fetchurl {
    url = "https://github.com/cdr/coder-cli/releases/download/v${version}/coder-cli-darwin-amd64.zip";
    sha256 = "14y82jfq5mdlw56hkidk2hr674i0g78wqf0ym6qv3l8n1kds0km2";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    runHook preUnpack
    mkdir ${pname}-${version}
    unzip $src
    mv coder ${pname}-${version}
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv ${pname}-${version}/coder $out/bin
    runHook postInstall
  '';

  outputs = [ "out" ];

  meta = with lib; {
    description = "A tool for interacting with the Coder command line";
    homepage = "https://github.com/cdr/coder-cli";
    license = licenses.gpl3Only;
    platforms = platforms.darwin;
    maintainers = [ maintainers.rob ];
  };

  phases = ["unpackPhase" "installPhase"];
}
