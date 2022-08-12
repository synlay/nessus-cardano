{
  # Pinned packages with Niv
  sources ? import ../sources.nix,
  haskellNix ? import sources.haskellNix {},
  nixpkgsSrc ? haskellNix.sources.nixpkgs-2105,
  nixpkgsArgs ? haskellNix.nixpkgsArgs,
  pkgs ? import nixpkgsSrc nixpkgsArgs,
}:

pkgs.stdenv.mkDerivation {

  pname = "libsodium";
  version = "1.35.3";

  # Check: https://github.com/input-output-hk/cardano-node/blob/1.35.3/doc/getting-started/install.md#installing-libsodium
  src = builtins.fetchGit {
    url = "https://github.com/input-output-hk/libsodium";
    allRefs = true;
    rev = "66f017f16633f2060db25e17c170c2afa0f2a8a1";
  };

  buildInputs = [
    pkgs.autoconf
    pkgs.automake
    pkgs.libtool
  ];

  builder = ./builder.sh;
}
