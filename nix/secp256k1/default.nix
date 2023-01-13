{
  # Pinned packages with Niv
  sources ? import ../sources.nix,
  haskellNix ? import sources.haskellNix {},
  nixpkgsSrc ? haskellNix.sources.nixpkgs-2105,
  nixpkgsArgs ? haskellNix.nixpkgsArgs,
  pkgs ? import nixpkgsSrc nixpkgsArgs,
}:

pkgs.stdenv.mkDerivation {

  pname = "secp256k1";
  version = "1.35.4";

  # Check: https://github.com/input-output-hk/cardano-node/blob/1.35.4/doc/getting-started/install.md#installing-secp256k1
  src = builtins.fetchGit {
    url = "https://github.com/bitcoin-core/secp256k1";
    rev = "ac83be33d0956faf6b7f61a60ab524ef7d6a473a";
  };

  buildInputs = [
    pkgs.autoconf
    pkgs.automake
    pkgs.libtool
  ];

  builder = ./builder.sh;
}
