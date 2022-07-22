source $stdenv/setup

# Make a writeable copy of the sources
# https://github.com/NixOS/nixpkgs/issues/14277

wrsrc=$TMPDIR

echo "Original sources in $src ..."
echo "Writable sources in $wrsrc ..."
cp -r $src/* $wrsrc
chmod -R +w $wrsrc

# Configure the writable sources

cd $wrsrc

./autogen.sh
./configure --prefix=$out --enable-module-schnorrsig --enable-experimental

# Build, Check & Install

make
make check
make install

echo "----------------------------------------------------------------------"
echo "Export generated libraries like this ..."
echo "   export SECP2561K1_LIBRARY_PATH=$out/lib"
echo "   export PKG_CONFIG_PATH=$out/lib/pkgconfig"
echo "----------------------------------------------------------------------"
