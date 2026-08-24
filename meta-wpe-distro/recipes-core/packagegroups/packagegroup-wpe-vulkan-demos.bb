SUMMARY = "WPE graphic demos based on Vulkan and their dependencies"
DESCRIPTION = "Vulkan/OpenGL graphic demo programs and libraries used to \
exercise the graphics stack on the WPE demo images."

inherit packagegroup

RDEPENDS:${PN} = "\
    assimp \
    glfw \
    glm \
    glmark2 \
    libsdl2-image \
    mesa-demos \
    vulkan-headers \
"
