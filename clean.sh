#! /usr/bin/bash

set -e

if [[ "$FSRA_MAKE" == "" ]]; then
    echo "required environment variables not found. have you setup you environment?"
    exit 1
fi

$FSRA_MAKE clean
rm compile_commands.json
