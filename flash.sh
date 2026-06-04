# exit on errors
set -xe

if [[ "$FSRA_MAKE" == "" || "$FSRA_OPENOCD" == "" || "$FSRA_PROJECT_NAME" == "" ]]; then
    echo "required environment setup not found. have you ran the appropriate env_*.sh script?"
    exit 1
fi

# make sure the flashed image is the latest one. NOTE: we might want to remove this from here
$FSRA_MAKE

# flash it using openocd. NOTE: currently the family of stm32f0x is hardcoded, but i do think that all of our chips are of this kind.
# anyway, we might want to add that as a configuration option in the future.
$FSRA_OPENOCD -f interface/stlink.cfg -f target/stm32f0x.cfg -c "program build/$FSRA_PROJECT_NAME.elf verify reset exit"
