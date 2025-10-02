#! /usr/bin/python3

import argparse
import uinput
import time
import sys

DEVICE_READY_TIMEOUT = 3

# Character to key code mapping based on Linux input event codes
# This includes the most common ASCII characters
CHAR_TO_KEYCODE = {
    # Letters (lowercase and uppercase map to same key codes)
    'a': uinput.KEY_A, 'A': uinput.KEY_A,
    'b': uinput.KEY_B, 'B': uinput.KEY_B,
    'c': uinput.KEY_C, 'C': uinput.KEY_C,
    'd': uinput.KEY_D, 'D': uinput.KEY_D,
    'e': uinput.KEY_E, 'E': uinput.KEY_E,
    'f': uinput.KEY_F, 'F': uinput.KEY_F,
    'g': uinput.KEY_G, 'G': uinput.KEY_G,
    'h': uinput.KEY_H, 'H': uinput.KEY_H,
    'i': uinput.KEY_I, 'I': uinput.KEY_I,
    'j': uinput.KEY_J, 'J': uinput.KEY_J,
    'k': uinput.KEY_K, 'K': uinput.KEY_K,
    'l': uinput.KEY_L, 'L': uinput.KEY_L,
    'm': uinput.KEY_M, 'M': uinput.KEY_M,
    'n': uinput.KEY_N, 'N': uinput.KEY_N,
    'o': uinput.KEY_O, 'O': uinput.KEY_O,
    'p': uinput.KEY_P, 'P': uinput.KEY_P,
    'q': uinput.KEY_Q, 'Q': uinput.KEY_Q,
    'r': uinput.KEY_R, 'R': uinput.KEY_R,
    's': uinput.KEY_S, 'S': uinput.KEY_S,
    't': uinput.KEY_T, 'T': uinput.KEY_T,
    'u': uinput.KEY_U, 'U': uinput.KEY_U,
    'v': uinput.KEY_V, 'V': uinput.KEY_V,
    'w': uinput.KEY_W, 'W': uinput.KEY_W,
    'x': uinput.KEY_X, 'X': uinput.KEY_X,
    'y': uinput.KEY_Y, 'Y': uinput.KEY_Y,
    'z': uinput.KEY_Z, 'Z': uinput.KEY_Z,

    # Numbers
    '0': uinput.KEY_0,
    '1': uinput.KEY_1,
    '2': uinput.KEY_2,
    '3': uinput.KEY_3,
    '4': uinput.KEY_4,
    '5': uinput.KEY_5,
    '6': uinput.KEY_6,
    '7': uinput.KEY_7,
    '8': uinput.KEY_8,
    '9': uinput.KEY_9,

    # Common punctuation and symbols
    ' ': uinput.KEY_SPACE,
    '\t': uinput.KEY_TAB,
    '\n': uinput.KEY_ENTER,
    ',': uinput.KEY_COMMA,
    '.': uinput.KEY_DOT,
    ';': uinput.KEY_SEMICOLON,
    "'": uinput.KEY_APOSTROPHE,
    '`': uinput.KEY_GRAVE,
    '-': uinput.KEY_MINUS,
    '=': uinput.KEY_EQUAL,
    '[': uinput.KEY_LEFTBRACE,
    ']': uinput.KEY_RIGHTBRACE,
    '\\': uinput.KEY_BACKSLASH,
    '/': uinput.KEY_SLASH,
}

# Characters that require shift to be pressed
SHIFT_CHARS = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+',
    '{', '}', '|', ':', '"', '<', '>', '?', '~'
}

# Additional shifted character mappings
SHIFT_CHAR_MAP = {
    '!': uinput.KEY_1,    # Shift + 1
    '@': uinput.KEY_2,    # Shift + 2
    '#': uinput.KEY_3,    # Shift + 3
    '$': uinput.KEY_4,    # Shift + 4
    '%': uinput.KEY_5,    # Shift + 5
    '^': uinput.KEY_6,    # Shift + 6
    '&': uinput.KEY_7,    # Shift + 7
    '*': uinput.KEY_8,    # Shift + 8
    '(': uinput.KEY_9,    # Shift + 9
    ')': uinput.KEY_0,    # Shift + 0
    '_': uinput.KEY_MINUS,    # Shift + -
    '+': uinput.KEY_EQUAL,    # Shift + =
    '{': uinput.KEY_LEFTBRACE,    # Shift + [
    '}': uinput.KEY_RIGHTBRACE,   # Shift + ]
    '|': uinput.KEY_BACKSLASH,    # Shift + \
    ':': uinput.KEY_SEMICOLON,    # Shift + ;
    '"': uinput.KEY_APOSTROPHE,   # Shift + '
    '<': uinput.KEY_COMMA,        # Shift + ,
    '>': uinput.KEY_DOT,          # Shift + .
    '?': uinput.KEY_SLASH,        # Shift + /
    '~': uinput.KEY_GRAVE,        # Shift + `
}


def get_key_for_char(char):
    """Get the key code and shift requirement for a character"""
    if char in CHAR_TO_KEYCODE:
        return CHAR_TO_KEYCODE[char], char in SHIFT_CHARS
    elif char in SHIFT_CHAR_MAP:
        return SHIFT_CHAR_MAP[char], True
    else:
        # Unsupported character
        return None, False


def emit_key_press(device, key_code, duration=0.01):
    """Emit a key press and release"""
    device.emit(key_code, 1)  # Press key
    device.syn()
    time.sleep(duration)
    device.emit(key_code, 0)  # Release key
    device.syn()


def simulate_string_typing(device, text, delay_between_keys=0.02, key_duration=0.01):
    """Simulate typing a string character by character"""

    for char in text:
        key_code, needs_shift = get_key_for_char(char)

        if key_code is None:
            print(f"Warning: Unsupported character '{char}' (ASCII: {ord(char)})", file=sys.stderr)
            continue

        # Press shift if needed
        if needs_shift:
            device.emit(uinput.KEY_LEFTSHIFT, 1)
            device.syn()

        # Press and release the character key
        emit_key_press(device, key_code, key_duration)

        # Release shift if it was pressed
        if needs_shift:
            device.emit(uinput.KEY_LEFTSHIFT, 0)
            device.syn()

        # Wait before next character
        if delay_between_keys > 0:
            time.sleep(delay_between_keys)


def main():
    parser = argparse.ArgumentParser(
        description="Simulate keyboard input by typing a string.",
        epilog="Example: %(prog)s 'Hello World!' --delay 0.1"
    )
    parser.add_argument("text", type=str,
                        help="Text string to type")
    parser.add_argument("--delay", type=float, default=0.02,
                        help="Delay between keystrokes in seconds (default: 0.02)")
    parser.add_argument("--key-duration", type=float, default=0.01,
                        help="Duration of each key press in seconds (default: 0.01)")
    parser.add_argument("--start-delay", type=float, default=3.0,
                        help="Delay before starting to type (default: 3.0)")

    args = parser.parse_args()

    # Collect all possible key codes that might be needed
    all_keys = set(CHAR_TO_KEYCODE.values())
    all_keys.update(SHIFT_CHAR_MAP.values())
    all_keys.add(uinput.KEY_LEFTSHIFT)

    # Create a virtual keyboard device
    device = uinput.Device(list(all_keys))

    print(f"Virtual keyboard created. Waiting {args.start_delay} seconds before typing...")
    time.sleep(args.start_delay)

    print(f"Typing: '{args.text}'")
    simulate_string_typing(device, args.text, args.delay, args.key_duration)

    print("Typing completed.")


if __name__ == "__main__":
    main()
