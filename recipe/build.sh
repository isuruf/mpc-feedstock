#!/bin/bash

./configure --prefix=$PREFIX \
            --with-gmp=$PREFIX \
            --with-mpfr=$PREFIX \
            --disable-static

make -j${CPU_COUNT}
make check -j${CPU_COUNT}
make install
