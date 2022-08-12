#!/bin/bash

# Also change HaskellNix in nix/sources.json
# and the Hydra build in nix/docker/node/default.nix
# Also check nix/libsodium/default.nix
# Also check nix/secp256k1/default.nix
# Also check libsodium + secp256k1 in nix/cardano/Dockerfile
CARDANO_VER="1.35.3"
CARDANO_REV="-rev1"

# Also check nix/cardano/Dockerfile
# Also check nix/cncli/Dockerfile
# Also check nix/docker/baseImage
DEBIAN_VER="11"
# https://github.com/tstack/lnav
LNAV_VER="0.10.1"

# https://github.com/cardano-community/guild-operators/blob/alpha/scripts/cnode-helper-scripts/gLiveView.sh#L60
# Also change change in nix/gLiveView/default.nix
GLVIEW_VER="1.27.1"

# https://github.com/cardano-community/cncli
CNCLI_VER="5.1.0"

# Check: https://github.com/input-output-hk/cardano-node/blob/master/doc/getting-started/install.md
# Check: https://github.com/input-output-hk/cardano-node/blob/master/.github/workflows/haskell.yml#L63
CABAL_VER="3.6.2.0"
# Check: https://github.com/input-output-hk/cardano-node/blob/master/.github/workflows/haskell.yml#L27
GHC_VER="8.10.7"

ARCH=`uname -m`

# Checking supported architectures ====================================================================================

if [[ ${ARCH} == "x86_64" ]]; then ARCH_SUFFIX="amd64"
elif [[ ${ARCH} == "aarch64" ]]; then ARCH_SUFFIX="arm64"
else
  echo "[ERROR] Unsupported platform architecture: ${ARCH}"
  exit 1
fi
