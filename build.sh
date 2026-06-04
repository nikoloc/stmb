set -e

if [[ "$FSRA_MAKE" == "" || "$FSRA_COMPILEDB" == "" ]]; then
    echo "required environment setup not found. have you ran the appropriate env_*.sh script?"
    exit 1
fi

# add the custom sources and includes
if [[ -f "custom.mk" ]] && ! grep -q "include custom.mk" Makefile; then
    sed -i '/# list of objects/i include custom.mk\n' Makefile
fi

$FSRA_COMPILEDB $FSRA_MAKE
