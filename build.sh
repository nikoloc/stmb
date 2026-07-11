#! /usr/bin/bash

set -e

if [[ "$FSRA_MAKE" == "" || "$FSRA_COMPILEDB" == "" ]]; then
    echo "required environment variables not found. have you setup you environment?"
    exit 1
fi

# add the custom sources and includes
if ! grep -q "\-include custom.mk" Makefile; then
    sed -i '/# list of objects/i -include custom.mk\n' Makefile
fi

if ! grep -q "\-include custom.mk" Makefile; then
    sed -i '/# list of objects/i -include custom.mk\n' Makefile
fi

$FSRA_COMPILEDB $FSRA_MAKE
