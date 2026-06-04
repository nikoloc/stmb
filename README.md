# Using STM32 MCUs without the CubeIDE

## Requirements

First you need the `CubeMX` for generating the boilerplate project and for the code
generation for various interfaces.

In `CubeMX`, create a project (or use an existing one) and under the `Project Manager`
select the `Makefile` option under the `Toolchain/IDE` tab and then generate the
code.

You will also need to install `arm-none-eabi-gcc`, `arm-none-eabi-gdb`, `arm-none-eabi-newlib`,
`make`, `openocd` and `compiledb`.

`make` is our build system, which relies on the `arm-none-eabi-gcc` compiler,
`arm-none-eabi-gdb` is the debugger and `arm-none-eabi-newlib` is the slimer
standard library for c.

`openocd` is a programmer thats going to flash our program onto a MCU.

`compiledb` generates `clangd` directives for the LSP support (auto-suggestions,
auto-completions etc).

All the relevant actions can be found in the provided bash scripts.

## Setup

After making or obtaining a project and installing the software required above,
you first need to setup the `build-utils` submodule and the required environment.

If the repository is brand new, then you need to setup the submodule as

```bash
git submodule add <dodati-kad-bude-aktivno-negde> build-utils
```

Else, if the repository already contains the submodule, you just need to
initialize it

```bash
git submodule update --init --recursive
```

Next, you need to provide the system with the required binaries. If you are on
Linux, then you can do so easily by running

```bash
source build-utils/env/linux.sh
```

If you are on Windows, then we will figure it out later. Check the current notes
in `env/linux.sh` and `env/windows.sh`. We will also need to add one for the MacOS,
but we should be able to just reuse the Linux version. Will need to test so.

## Building

You can build the image by running

```bash
build-utils/build.sh
```

## Flashing

In order to flash the image onto a MCU, you need to run

```bash
build-utils/flash.sh
```

This script is just a wrapper around the `openocd`. It is tested on Linux and
is EXTREMELY FAST. Will need to be tested on Windows and adjusted as needed.

> Note: This will also build the latest image if there have been any changes.

## LSP Support

In order to have the LSP Support you need to provide the LSP with the relevant
info about the project in `compile_commands.json`. We use `compiledb` in order
to generate it from our Makefile, which is included in our build step. It should
work by default in VSCode and Neovim.
