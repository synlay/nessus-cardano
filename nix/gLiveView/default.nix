## Install gLiveView ###########################################################
#
# Note, that guild-operators does currently not have reliable releases
# Instead, we cherry pick a revision that we found to be good at
# build time of this image.
#
# [FR] Improvements to the release process
# https://github.com/cardano-community/guild-operators/issues/855
#
# The auto update feature of gLiveView is disabled
#
# https://github.com/cardano-community/guild-operators
{
  pkgs ? import <nixpkgs> {},

  glvVersion,
}:

pkgs.stdenv.mkDerivation {

  pname = "gLiveView";
  version = "${glvVersion}";

  # gLiveView version
  # https://github.com/cardano-community/guild-operators/blame/alpha/scripts/cnode-helper-scripts/gLiveView.sh#L60

  src = builtins.fetchGit {
    name = "guild-operators";
    url = "https://github.com/cardano-community/guild-operators.git";
    rev = "2176da445a4028c93094a7fbb7c5831663462ea5";
    ref = "alpha";
  };

  builder = ./builder.sh;
}
