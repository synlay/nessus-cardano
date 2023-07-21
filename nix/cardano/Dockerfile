#
# A multistage approach to building a Cardano Node/CLI image
#

# Some build-arg parameters
ARG CARDANO_VER
ARG CABAL_VER
ARG GHC_VER
ARG ARCH

## Install dependencies, secp256k1 and libsodium #################################################################################

FROM debian:11-slim as buildera

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    autoconf automake build-essential g++ git jq \
    libffi-dev libgmp-dev libncursesw5 libnuma-dev libssl-dev libsystemd-dev libtinfo-dev libtool llvm \
    make pkg-config tmux wget zlib1g-dev \
    libsodium23 libsodium-dev \
    libsystemd0 libsystemd-dev

# Install secp256k1
WORKDIR /src
RUN git clone https://github.com/bitcoin-core/secp256k1.git
WORKDIR secp256k1
RUN git reset --hard ac83be33d0956faf6b7f61a60ab524ef7d6a473a
RUN ./autogen.sh \
  && ./configure --prefix=/usr --enable-module-schnorrsig --enable-experimental \
  && make \
  && make check \
  && make install

# Install Libsodium

WORKDIR /src
RUN git clone https://github.com/input-output-hk/libsodium
WORKDIR libsodium
RUN git reset --hard dbb48cce5429cb6585c9034f002568964f1ce567
RUN ./autogen.sh \
  && ./configure \
  && make install

ENV LD_LIBRARY_PATH="/usr/local/lib"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

## Build + Install GHC & Cabal ########################################################################################

FROM buildera as builderb

ARG CABAL_VER
ARG GHC_VER
ARG ARCH

# Download and install GHC

WORKDIR /src
RUN wget -q https://downloads.haskell.org/ghc/${GHC_VER}/ghc-${GHC_VER}-${ARCH}-deb10-linux.tar.xz \
  && tar -xf ghc-${GHC_VER}-${ARCH}-deb10-linux.tar.xz

WORKDIR ghc-${GHC_VER}
RUN ./configure \
  && make install

RUN ghc --version

# The Haskell Common Architecture for Building Applications and Libraries

ARG CABAL_TAG="${CABAL_VER}"

WORKDIR /src
# TODO: Switch back to official cabal-install after packages are readded for debian10 + 11 on aarch64
# wget -q https://downloads.haskell.org/~cabal/cabal-install-${CABAL_TAG}/cabal-install-${CABAL_VER}-aarch64-linux-deb10.tar.xz \
RUN if [ "${ARCH}" = "aarch64" ]; then \
  wget -q https://downloads.haskell.org/~ghcup/unofficial-bindists/cabal/${CABAL_VER}/cabal-install-${CABAL_VER}-aarch64-linux-deb10.tar.xz \
  && tar -xf cabal-install-${CABAL_VER}-aarch64-linux-deb10.tar.xz; \
elif [ "${ARCH}" = "x86_64" ]; then \
  wget -q https://downloads.haskell.org/~cabal/cabal-install-${CABAL_TAG}/cabal-install-${CABAL_VER}-x86_64-linux-alpine-static.tar.xz \
  && tar -xf cabal-install-${CABAL_VER}-x86_64-linux-alpine-static.tar.xz; \
fi

RUN mv cabal /usr/local/bin/

RUN cabal --version

## Buid Cardano #######################################################################################################

FROM builderb as builderc

ARG CARDANO_VER
ARG CABAL_VER
ARG GHC_VER
ARG ARCH

# Build and install cardano-node

WORKDIR /src
RUN git clone -b $CARDANO_VER --depth 1 https://github.com/input-output-hk/cardano-node.git
WORKDIR cardano-node

RUN cabal update \
  && cabal configure

RUN echo "package cardano-crypto-praos" >> cabal.project.local
RUN echo "  flags: -external-libsodium-vrf" >> cabal.project.local
RUN echo "" >> cabal.project.local

RUN echo "package HsOpenSSL" >> cabal.project.local
RUN echo "  flags: +use-pkg-config" >> cabal.project.local
RUN echo "" >> cabal.project.local

# Can no longer build cardano-node on arm64
# https://github.com/input-output-hk/cardano-node/issues/3395
RUN echo "package trace-dispatcher" >> cabal.project.local
RUN echo "  ghc-options: -Wwarn" >> cabal.project.local
RUN echo "" >> cabal.project.local

RUN cat cabal.project.local \
  && cabal build all

RUN cp $(find ./dist-newstyle/build -type f -name "cardano-node") /usr/local/bin/
RUN cp $(find ./dist-newstyle/build -type f -name "cardano-cli") /usr/local/bin/
RUN cp $(find ./dist-newstyle/build -type f -name "cardano-submit-api") /usr/local/bin/

WORKDIR /root

## Buid Cardano #######################################################################################################

FROM buildera

# Copy the executables from the previous build
COPY --from=builderc /usr/local/bin/cardano-node /usr/local/bin/
COPY --from=builderc /usr/local/bin/cardano-cli /usr/local/bin/
COPY --from=builderc /usr/local/bin/cardano-submit-api /usr/local/bin/

WORKDIR /
