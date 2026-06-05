# This is a template for the submodule initialization. This is the idea:
# - Every submodule needs to have the top-level `module.mk` Makefile fragment, which
#   extends the default `C_SOURCES`, `C_INCLUDES` and other variables as needed.
# - This fragment is then going to be included into the main projects `custom.mk`,
#   which will result it the build system compiling and linking the submodule
#   into the final image.

# Because the Makefile is stupid in the same sence as the C preprocessor, that is, 
# it only pastes the contents of this Makefile into the other one, we cannot use
# relative paths here and have to rely on this bellow to generate absoulute paths.
ROOT_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# This is how we would add the submodules include directories
C_INCLUDES += -I$(ROOT_DIR)Core/Inc

# And sources for compilation
C_SOURCES += $(ROOT_DIR)Core/Src/main.c \
			 # other

# Include the CoreLib as a submodule, see notes for the submodule initialization.
include CoreLib/module.mk
