set -xe

if [[ "$FSRA_MAKE" == "" || "$FSRA_COMPILEDB" == "" ]]; then
    echo "required environment setup not found. have you ran the appropriate env_*.sh script?"
    exit 1
fi

$FSRA_COMPILEDB $FSRA_MAKE
