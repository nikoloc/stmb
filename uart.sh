#! /usr/bin/bash

set -e

if [[ "$FSRA_TIO" == "" || "$FSRA_UART_BAUDRATE" == "" ]]; then
    echo "required environment variables not found. have you setup you environment?"
    exit 1
fi

# TODO: currently the device name is hardcoded since i dont have any boards at me right now.
# we should list all the connected devices and grep through them to find the approprate one.
# consult milan for the right marks we should look for here.
$FSRA_TIO -b $FSRA_UART_BAUDRATE /dev/ttyACM0

