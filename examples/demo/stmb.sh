#!/usr/bin/env bash

# fail on errors
set -e

check() {
    local cmd="$1"
    
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd"
        return 0
    else
        echo "error: '$cmd' not found" >&2
        return 1
    fi
}

get_make() {
    local cmd="${STMB_MAKE:-make}"
    check "$cmd"
}

get_compiledb() {
    local cmd="${STMB_COMPILEDB:-compiledb}"
    check "$cmd"
}

get_tio() {
    local cmd="${STMB_TIO:-tio}"
    check "$cmd"
}

get_openocd() {
    local cmd="${STMB_OPENOCD:-openocd}"
    check "$cmd"
}

get_project_name() {
    basename "$(ls | grep ".ioc")" ".ioc"
}

clean() {
    local make=$(get_make)

    $make clean
    rm compile_commands.json
}

build() {
    local make=$(get_make)
    local compiledb=$(get_compiledb)

    # add our custom sources and includes
    if ! grep -q "\-include stmb.mk" Makefile; then
        sed -i '/# list of objects/i -include stmb.mk' Makefile
    fi

    $compiledb $make
}

get_board() {
    if [[ "$STMB_BOARD" == "" ]]; then
        echo "error: board not found" >&2
        return 1
    fi

    echo "$STMB_BOARD"
    return 0
}

flash() {
    local openocd=$(get_openocd)
    local project_name=$(get_project_name)

    # note: if these are on the same line then 'set -e' does not work, so we have to separete them on two lines :/ idk, bash
    local board
    board=$(get_board)
    
    # TODO: make the actions customizable
    $openocd -f interface/stlink.cfg -f target/$board.cfg -c "program build/$project_name.elf verify reset exit"
}

get_baudrate() {
    local baudrate="${STMB_BAUDRATE:-115200}"

    echo "$baudrate"
}

uart() {
    local tio=$(get_tio)
    local baudrate=$(get_baudrate)

    # TODO: currently the device name is hardcoded since i dont have any boards at me right now. we should list all the
    # connected devices and grep through them to find the approprate one. consult milan for the right marks we should
    # look for here.
    $tio -b $baudrate /dev/ttyACM0

}

if [[ -f stmb.conf ]]; then
    source stmb.conf
fi

case "$1" in
    build)
        build
        ;;
    flash)
        flash
        ;;
    uart)
        uart
        ;;
    clean)
        clean
        ;;
    *)
        echo "usage: $0 {build|flash|uart|clean}" >&2
        exit 1
        ;;
esac
