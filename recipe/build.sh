#!/bin/bash

# Get an updated config.sub and config.guess
# Delete first because they have weird permissions
rm -f config.sub
rm -f config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* .

./configure --prefix=$PREFIX \
            --with-gmp=$PREFIX \
            --with-mpfr=$PREFIX \
            --disable-static

make -j${CPU_COUNT}
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != 1 ]]; then
  make check -j${CPU_COUNT}
fi
make install
