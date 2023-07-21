#
# A multistage approach to building an extended Debian
#
# - Log Navigator

# Required version args
ARG LNAV_VER

## Install required dependencies ######################################################################################

FROM debian:12-slim as buildera

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    bzip2 curl zlib1g-dev \
    libarchive-dev libcurl4-openssl-dev libncurses-dev libpcre2-dev libreadline-dev libsqlite3-dev

Using ./nix/cardano/target/cardano-node-8.1.1-arm64
Using ./nix/cncli/target/cncli-5.2.0-arm64


## Build lnav #########################################################################################################

FROM buildera as builderb

# Required version args
ARG LNAV_VER

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get install -y \
  autoconf automake build-essential git libpcre2-dev

RUN git clone --depth 1 --branch v${LNAV_VER} https://github.com/tstack/lnav gitsrc
WORKDIR gitsrc

RUN ./autogen.sh \
  && ./configure \
  && make install

## Buid Cardano #######################################################################################################

FROM buildera

# Copy the executables from the previous build
COPY --from=builderb /usr/bin/lnav /usr/local/bin/

WORKDIR /
