# on unix systems, system binaries are fairly standardized, and these names are probably not going
# to differ between mac and linux distibutions, hence we can have these basically hard-coded here,
# with some checks for different distros if necessary.
# as for windows users, they are advised to use `scoop` or a similar package manager in order to
# install compatible software, as that seems like the easiest solution.
export FSRA_MAKE=make
export FSRA_OPENOCD=openocd
export FSRA_COMPILEDB=compiledb
export FSRA_TIO=tio
