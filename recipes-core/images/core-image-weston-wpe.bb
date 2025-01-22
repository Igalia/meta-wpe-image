DESCRIPTION = "core-image-weston with WPEWebKit"

inherit image_browsers image_weston

IMAGE_INSTALL:append = " \
    wpewebkit \
    wpe-simple-launcher \
    python3-uinput \
"

IMAGE_INSTALL:append:raspberrypi4 = " rpi-eeprom"
IMAGE_INSTALL:append:raspberrypi4-64 = " rpi-eeprom"
IMAGE_INSTALL:append:raspberrypi5 = " rpi-eeprom"

