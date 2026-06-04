set -e
if [[ "$FSRA_MAKE" == "" ]]; then
    echo "required environment setup not found. have you ran the appropriate env_*.sh script?"
    exit 1
fi

$FSRA_MAKE clean
rm compile_commands.json
