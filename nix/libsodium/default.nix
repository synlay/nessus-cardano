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
  version = "8.1.1";

  # Check: https://github.com/input-output-hk/cardano-node/blob/8.1.1/doc/getting-started/install.md#installing-libsodium
  src = builtins.fetchGit {
    url = "https://github.com/input-output-hk/libsodium";
    allRefs = true;
    rev = "dbb48cce5429cb6585c9034f002568964f1ce567";
  };

  buildInputs = [
    pkgs.autoconf
    pkgs.automake
    pkgs.libtool
  ];

  builder = ./builder.sh;
}
