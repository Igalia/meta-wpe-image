#! /usr/bin/python3

import argparse
import uinput
import time

DEVICE_READY_TIMEOUT = 3
DISPLAY_WIDTH = 1920
DISPLAY_HEIGHT = 1080


def simulate_scroll(device, start_x, start_y, end_x, end_y,
                    duration=0.5, steps=10, delay_on_touch_up=0):
    """Simulate a swipe gesture from (start_x, start_y) to (end_x, end_y)"""

    # Calculate step increments for smooth motion
    if steps > 0:
        step_x = (end_x - start_x) // steps
        step_y = (end_y - start_y) // steps
        delay = 1.0 * duration / steps  # Time delay between each step

    # Start touch
    device.emit(uinput.ABS_X, start_x, syn=False)
    device.emit(uinput.ABS_Y, start_y, syn=False)
    device.emit(uinput.BTN_TOUCH, 1)  # Press touch
    device.syn()

    # Move in steps to simulate dragging
    for i in range(steps):
        device.emit(uinput.ABS_X, start_x + step_x * i, syn=False)
        device.emit(uinput.ABS_Y, start_y + step_y * i, syn=False)
        device.syn()
        time.sleep(delay)

    # End touch
    time.sleep(delay_on_touch_up)
    device.emit(uinput.ABS_X, end_x, syn=False)
    device.emit(uinput.ABS_Y, end_y, syn=False)
    device.emit(uinput.BTN_TOUCH, 0)  # Release touch
    device.syn()


def main():
    parser = argparse.ArgumentParser(description="Simulate a swipe gesture.")
    parser.add_argument("start_x", type=int,
                        help="Starting X position of the swipe.")
    parser.add_argument("start_y", type=int,
                        help="Starting Y position of the swipe.")
    parser.add_argument("end_x", type=int,
                        help="Ending X position of the swipe.")
    parser.add_argument("end_y", type=int,
                        help="Ending Y position of the swipe.")
    parser.add_argument("--duration", type=float, default=0.5,
                        help="Duration of the swipe in seconds.")
    parser.add_argument("--steps", type=int, default=10,
                        help="Number of steps for the swipe.")
    parser.add_argument("--delay-on-touch-up", type=float, default=0,
                        help="Delay on touch up.")

    args = parser.parse_args()

    # Create a device that can emit touch events
    device = uinput.Device([
        uinput.ABS_X + (0, DISPLAY_WIDTH, 0, 0),
        uinput.ABS_Y + (0, DISPLAY_HEIGHT, 0, 0),
        uinput.BTN_TOUCH,
    ])

    time.sleep(DEVICE_READY_TIMEOUT)

    simulate_scroll(device, args.start_x, args.start_y, args.end_x, args.end_y,
                    args.duration, args.steps, args.delay_on_touch_up)


if __name__ == "__main__":
    main()
