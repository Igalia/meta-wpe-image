#!/usr/bin/python3

import argparse
import uinput
import time

DEVICE_READY_TIMEOUT = 3
DISPLAY_WIDTH = 1920
DISPLAY_HEIGHT = 1080


"""
Simulate button left click at (start_x, start_y).

When offset_x or offset_y are set, their value is added at the cursor position
before release the button.
"""
def button_left_click(device, start_x, start_y, offset_x=0, offset_y=0, touch_delay=0):

    # Move to cursor to start position.
    device.emit(uinput.ABS_X, start_x, syn=False)
    device.emit(uinput.ABS_Y, start_y, syn=False)
    device.syn()

    # Press touch.
    device.emit(uinput.BTN_TOUCH, 1)

    # If offset is set, shift cursor offset pixels.
    if (offset_x > 0 or offset_y > 0):
        device.emit(uinput.ABS_X, start_x + offset_x, syn=False)
        device.emit(uinput.ABS_Y, start_y + offset_y, syn=False)
        device.syn()

    time.sleep(touch_delay)

    # Release button.
    device.emit(uinput.BTN_TOUCH, 0)

def main():
    parser = argparse.ArgumentParser(description="Simulate a button left click.")
    parser.add_argument("start_x", type=int,
                        help="Starting X position.")
    parser.add_argument("start_y", type=int,
                        help="Starting Y position.")
    parser.add_argument("offset_x", type=int, nargs='?', default=0,
                        help="Offset X position.")
    parser.add_argument("offset_y", type=int, nargs='?', default=0,
                        help="Offset Y position.")
    parser.add_argument("--touch-delay", type=float, default=0,
                        help="Delay between touch down and touch up.")

    args = parser.parse_args()

    # Create a device that can emit touch events.
    device = uinput.Device([
        uinput.ABS_X + (0, DISPLAY_WIDTH, 0, 0),
        uinput.ABS_Y + (0, DISPLAY_HEIGHT, 0, 0),
        uinput.BTN_TOUCH
    ])

    time.sleep(DEVICE_READY_TIMEOUT)

    button_left_click(device, args.start_x, args.start_y,
                      args.offset_x, args.offset_y, args.touch_delay)


if __name__ == "__main__":
    main()
