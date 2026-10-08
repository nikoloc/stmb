# Using STM32 MCUs without the CubeIDE

## Requirements

First you need the `CubeMX` for generating the boilerplate project and for the code
generation for various interfaces.

In `CubeMX`, create a project (or use an existing one) and under the `Project Manager`
select the `Makefile` option under the `Toolchain/IDE` tab and then generate the
code.

You will also need to install `arm-none-eabi-gcc`, `arm-none-eabi-gdb`, `arm-none-eabi-newlib`,
`make`, `openocd`, `telnet` (or `netcat`) and `compiledb`.

`make` is our build system, which relies on the `arm-none-eabi-gcc` compiler,
`arm-none-eabi-gdb` is the debugger and `arm-none-eabi-newlib` is the slimer
standard library for c.

`openocd` is a programmer thats going to flash our program onto a MCU.

`telnet` (or alternative implementations such as `netcat`) are used to communicate
remotely to an `openocd` instance.

`compiledb` generates `clangd` directives for the LSP support (auto-suggestions,
auto-completions etc).

Optionally, you may install `tio` (Unix only) for monitoring of UART ports.

All the relevant actions can be found in the provided bash script.

## Setup

After making or obtaining a project and installing the software required above,
you first need to setup the `stmb` build system. You can either install the
`stmb.sh` globally (by putting it somewhere in your path) or locally (by copying
the provied `stmb.sh` file directly into the project).

You may generate the default template configuration file `stmb.conf` and the
`Makefile` fragment `stmb.mk` by running

```bash
./stmb.sh init
```

You will then need to setup the configuration for they build system. This is
done by setting the following environment variables inside `stmb.conf` in
the root of the project.

- `STMB_BOARD` - Family of microcontroller, info used by `openocd` in order to
  properly flash the code onto a mcu. The full list of supported hardware can be
  found in the installation directory of `openocd`, on Linux that being
  `/usr/share/openocd/scripts/target`. It needs to match the name of the file without
  the `.cfg` extension.

- `STMB_BAUDRATE` - Baudrate for the UART device communication. Only needed if
  `tio` is to be used for communication. If its not used, it can be left undefined.

You can also provide the system with the required binary names if they differ
from the standard. The build system depends on the next few binaries, which
should be installed and their executable names set in the following environment
variables:

- `STMB_MAKE` - The standard `make` build system. Defaults to `make`.
- `STMB_COMPILEDB` - [compiledb](https://github.com/nickdiego/compiledb) used
  for the LSP support inside of code editors. Defaults to `compiledb`.
- `STMB_OPENOCD` - [openocd](https://openocd.org/) - cross-platform tool used to
  flash our code onto a board. Defaults to `openocd`.
- `STMB_TELNET` - telnet protocol client. By default tries `telnet`, `netcat` or
  `nc`.
- `STMB_TIO` - [tio](https://github.com/tio/tio) Optional Unix only program for
  serial communication over UART, used only for `uart` command. Defaults to
  `tio`.

If you are on Windows, then the recommended way is to setup a package manager,
such as `scoop`, and install the required software through it. That way you get
full compatibility with Unix systems, on which the build system is primarly
developed and tested.

## Building

You can build the image by running

```bash
./stmb.sh build
```

## Flashing

In order to flash the image onto a MCU, you need to run

```bash
./stmb.sh flash
```

This script is just a wrapper around the `openocd`. It is tested on Linux and
is EXTREMELY FAST. Will need to be tested on Windows and adjusted as needed.

> Note: This will not build the latest image if there have been any changes. You
> need to do that before manually.

## Debugging

`openocd` provides a `gdbserver` for remote debugging. The script provides two
helper commands called `debug` and `debug-server`. Calling

```bash
./stmb.sh debug
```

starts up `openocd`, resets the target, halts the CPU and start an interactive
`gdb` session. From there you can, for example, `break main` and `continue`, to
arrive at the main function.

```bash
./stmb.sh debug-server
```

starts up `openocd`, resets the target and waits for remote `gdb` connection. This
is meant to be used with external DAP (Debug Adaptor Protocol) client, provided
by your editor of choice. A `telnet` instance is started in the current terminal
and serves to communicate to an `openocd` server directly (e.g. to reset the target
by running `reset halt`).

There is also a `cppdbg` `launch.json` example at `examples/launch.json` for
integration with VSCode.

## Adding custom sources

If you want to add a new source file, or to include a new include directory
you can do so, but you need to edit the `stmb.mk` file in the root of your
project. For more documentation and an example fragment code take a look at
`examples/stmb.mk`.

## Submodules

You can vendor another submodule into the project be following the next two
rules:

- The submodule needs to have the top-level `stmb.mk` Makefile fragment
  specifying its sources, includes, flags etc.
- The main project needs to include the appropriate `stmb.mk` into its own
  `stmb.mk`.

For an example, checkout `examples/module.mk` and `examples/stmb.mk`.

## Cleaning the project

```bash
./stmb.sh clean
```

## LSP Support

In order to have the LSP Support you need to provide the LSP with the relevant
info about the project in `compile_commands.json`. We use `compiledb` in order
to generate it from our `Makefile`, which is included in our build step. It should
work by default in `VSCode` (using the `Clangd` extension) and `Neovim`.

## Examples

For the example usage of the build system check out `examples/demo` as well as
[this demo program](https://gitlab.com/nikoloc-fsra/fsra-build), showcasing more
advanced setup.

## TODO

- Test the process on Windows and MacOS. Add more documentation for those platforms.
- Add `.vscode` shenanigans for better integration with `Visual Studio Code`, for
  quick actions, debugger etc.
- Write a function for searching for the right ports for UART communication.
