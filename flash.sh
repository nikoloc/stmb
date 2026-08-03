#! /usr/bin/bash

set -e

if [[ "$FSRA_OPENOCD" == "" || "$FSRA_STM_FAMILY" == "" || "$FSRA_PROJECT_NAME" == "" ]]; then
    echo "required environment variables not found. have you setup you environment?"
    exit 1
fi

# flash it using openocd
$FSRA_OPENOCD -f interface/stlink.cfg -f "target/$FSRA_STM_FAMILY.cfg" -c "program build/$FSRA_PROJECT_NAME.elf verify reset exit"
