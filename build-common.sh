#!/bin/bash

# Also change HaskellNix in nix/sources.json
# Also check nix/libsodium/default.nix
# Also check nix/secp256k1/default.nix
# Also check libsodium + secp256k1 in nix/cardano/Dockerfile
CARDANO_VER="8.1.1"
CARDANO_REV="-rev2"

# Also check nix/cardano/Dockerfile
# Also check nix/cncli/Dockerfile
# Also check nix/docker/baseImage
DEBIAN_VER="11"
# https://github.com/tstack/lnav
# Also check nix/docker/baseImage/shell.nix
LNAV_VER="0.11.2"

# https://github.com/cardano-community/guild-operators/blob/alpha/scripts/cnode-helper-scripts/gLiveView.sh#L60
# Also change change in nix/gLiveView/default.nix
GLVIEW_VER="1.27.5"

# https://github.com/cardano-community/cncli
# TODO: version 5.3.2 needs some modification additional work in Dockerfiles because of missing deps
CNCLI_VER="5.2.0"

# Check: https://github.com/input-output-hk/cardano-node/blob/8.1.1/doc/getting-started/install.md
# Check: https://github.com/input-output-hk/cardano-node/blob/8.1.1/.github/workflows/haskell.yml#L29
CABAL_VER="3.8.1.0"
# Check: https://github.com/input-output-hk/cardano-node/blob/8.1.1/.github/workflows/haskell.yml#L28
GHC_VER="8.10.7"

ARCH=`uname -m`

# Checking supported architectures ====================================================================================

if [[ ${ARCH} == "x86_64" ]]; then ARCH_SUFFIX="amd64"
elif [[ ${ARCH} == "aarch64" ]]; then ARCH_SUFFIX="arm64"
else
  echo "[ERROR] Unsupported platform architecture: ${ARCH}"
  exit 1
fi
