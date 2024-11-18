#!/usr/bin/python3

import argparse
import uinput
import time

DEVICE_READY_TIMEOUT = 3
DISPLAY_WIDTH = 1920
DISPLAY_HEIGHT = 1080


def simulate_two_finger_gesture(device,
                                start_x1, start_y1, end_x1, end_y1,
                                start_x2, start_y2, end_x2, end_y2,
                                duration=0.5, steps=10):
    """ Simulate a two-finger scroll from (start_x1, start_y1) and
        (start_x2, start_y2) to  (end_x1, end_y1) and (end_x2, end_y2)
    """

    tracking_id1 = 1
    tracking_id2 = 2

    # Calculate step increments for smooth motion
    step_x1 = (end_x1 - start_x1) // steps
    step_y1 = (end_y1 - start_y1) // steps
    step_x2 = (end_x2 - start_x2) // steps
    step_y2 = (end_y2 - start_y2) // steps
    delay = duration / steps  # Time delay between each step

    # Start touch for both fingers
    device.emit(uinput.ABS_MT_TRACKING_ID, tracking_id1, syn=False)
    device.emit(uinput.ABS_MT_POSITION_X, start_x1, syn=False)
    device.emit(uinput.ABS_MT_POSITION_Y, start_y1, syn=False)
    device.emit(uinput.ABS_MT_SLOT, 1, syn=False)

    device.emit(uinput.ABS_MT_TRACKING_ID, tracking_id2, syn=False)
    device.emit(uinput.ABS_MT_POSITION_X, start_x2, syn=False)
    device.emit(uinput.ABS_MT_POSITION_Y, start_y2, syn=False)
    device.emit(uinput.ABS_MT_SLOT, 0, syn=False)

    device.emit(uinput.BTN_TOUCH, 1)  # Press touch for first finger
    device.emit(uinput.ABS_X, start_x1, syn=False)
    device.emit(uinput.ABS_Y, start_y1, syn=False)
    device.syn()

    # Move both fingers in steps to simulate dragging
    for i in range(steps):
        # Update first finger position
        device.emit(uinput.ABS_MT_SLOT, 1, syn=False)
        device.emit(uinput.ABS_MT_POSITION_X, start_x1 + step_x1 * i,
                    syn=False)
        device.emit(uinput.ABS_MT_POSITION_Y, start_y1 + step_y1 * i,
                    syn=False)
        device.emit(uinput.ABS_X, start_x1 + step_x1 * i, syn=False)
        device.emit(uinput.ABS_Y, start_y1 + step_y1 * i, syn=False)

        # Update second finger position
        device.emit(uinput.ABS_MT_SLOT, 0, syn=False)
        device.emit(uinput.ABS_MT_POSITION_X, start_x2 + step_x2 * i,
                    syn=False)
        device.emit(uinput.ABS_MT_POSITION_Y, start_y2 + step_y2 * i,
                    syn=False)

        device.syn()

        # Wait between steps to simulate smooth scroll
        time.sleep(delay)

    # End touch for both fingers
    device.emit(uinput.ABS_MT_SLOT, 1, syn=False)
    device.emit(uinput.ABS_MT_POSITION_X, end_x1, syn=False)
    device.emit(uinput.ABS_MT_POSITION_Y, end_y1, syn=False)
    device.emit(uinput.ABS_X, end_x1, syn=False)
    device.emit(uinput.ABS_Y, end_y1, syn=False)
    device.emit(uinput.ABS_MT_TRACKING_ID, -1, syn=False)
    device.emit(uinput.BTN_TOUCH, 0)  # Release touch for first finger
    device.syn()

    device.emit(uinput.ABS_MT_SLOT, 0, syn=False)
    device.emit(uinput.ABS_MT_POSITION_X, end_x2, syn=False)
    device.emit(uinput.ABS_MT_POSITION_Y, end_y2, syn=False)
    device.emit(uinput.ABS_X, end_x2, syn=False)
    device.emit(uinput.ABS_Y, end_y2, syn=False)
    device.emit(uinput.ABS_MT_TRACKING_ID, -1, syn=False)
    device.emit(uinput.BTN_TOUCH, 0)  # Release touch for second finger
    device.syn()


def main():
    parser = argparse.ArgumentParser(description="Simulate a swipe gesture.")
    parser.add_argument("start_x1", type=int,
                        help="Starting X1 position of the swipe.")
    parser.add_argument("start_y1", type=int,
                        help="Starting Y1 position of the swipe.")
    parser.add_argument("end_x1", type=int,
                        help="Ending X1 position of the swipe.")
    parser.add_argument("end_y1", type=int,
                        help="Ending Y1 position of the swipe.")
    parser.add_argument("start_x2", type=int,
                        help="Starting X2 position of the swipe.")
    parser.add_argument("start_y2", type=int,
                        help="Starting Y2 position of the swipe.")
    parser.add_argument("end_x2", type=int,
                        help="Ending X2 position of the swipe.")
    parser.add_argument("end_y2", type=int,
                        help="Ending Y2 position of the swipe.")
    parser.add_argument("--duration", type=float, default=0.5,
                        help="Duration of the swipe in seconds.")
    parser.add_argument("--steps", type=int, default=10,
                        help="Number of steps for the swipe.")

    args = parser.parse_args()

    # Create a device that can emit touch events
    device = uinput.Device([
        uinput.ABS_MT_TRACKING_ID + (0, 65535, 0, 0),
        uinput.ABS_MT_POSITION_X + (0, DISPLAY_WIDTH, 0, 0),
        uinput.ABS_MT_POSITION_Y + (0, DISPLAY_HEIGHT, 0, 0),
        uinput.ABS_X + (0, DISPLAY_WIDTH, 0, 0),
        uinput.ABS_Y + (0, DISPLAY_HEIGHT, 0, 0),
        uinput.ABS_MT_SLOT + (0, 10, 0, 0),
        uinput.BTN_TOUCH,
    ])

    time.sleep(DEVICE_READY_TIMEOUT)

    # Simulate a two-finger scroll gesture
    simulate_two_finger_gesture(device,
                                args.start_x1, args.start_y1,
                                args.end_x1, args.end_y1,
                                args.start_x2, args.start_y2,
                                args.end_x2, args.end_y2,
                                args.duration, args.steps)


if __name__ == "__main__":
    main()
