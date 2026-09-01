SUMMARY = "WPE graphic demos based on Vulkan and their dependencies"
DESCRIPTION = "Vulkan/OpenGL graphic demo programs and libraries used to \
exercise the graphics stack on the WPE demo images."

# RDEPENDS on shared-library packages (assimp, glfw, libsdl2-image, ...) that
# debian.bbclass renames per soname (libassimp5, libglfw3, ...). An allarch
# packagegroup cannot depend on such dynamically renamed packages, so keep it
# per-machine instead of allarch.
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = "\
    assimp \
    glfw \
    glm \
    glmark2 \
    libsdl2-image \
    mesa-demos \
    vulkan-headers \
    vulkan-loader \
    vulkan-tools \
"
