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

# Special key mapping based on Linux input event codes
SPECIAL_KEYS = {
    # Function Keys (F1-F12)
    'f1': uinput.KEY_F1,
    'f2': uinput.KEY_F2,
    'f3': uinput.KEY_F3,
    'f4': uinput.KEY_F4,
    'f5': uinput.KEY_F5,
    'f6': uinput.KEY_F6,
    'f7': uinput.KEY_F7,
    'f8': uinput.KEY_F8,
    'f9': uinput.KEY_F9,
    'f10': uinput.KEY_F10,
    'f11': uinput.KEY_F11,
    'f12': uinput.KEY_F12,

    # Arrow Keys
    'up': uinput.KEY_UP,
    'down': uinput.KEY_DOWN,
    'left': uinput.KEY_LEFT,
    'right': uinput.KEY_RIGHT,

    # Control Keys
    'enter': uinput.KEY_ENTER,
    'return': uinput.KEY_ENTER,  # Alias for enter
    'delete': uinput.KEY_DELETE,
    'del': uinput.KEY_DELETE,    # Alias for delete
    'tab': uinput.KEY_TAB,
    'escape': uinput.KEY_ESC,
    'esc': uinput.KEY_ESC,       # Alias for escape
    'backspace': uinput.KEY_BACKSPACE,
    'insert': uinput.KEY_INSERT,
    'ins': uinput.KEY_INSERT,    # Alias for insert
    'home': uinput.KEY_HOME,
    'end': uinput.KEY_END,
    'pageup': uinput.KEY_PAGEUP,
    'pgup': uinput.KEY_PAGEUP,   # Alias for pageup
    'pagedown': uinput.KEY_PAGEDOWN,
    'pgdn': uinput.KEY_PAGEDOWN, # Alias for pagedown

    # Modifier Keys
    'shift': uinput.KEY_LEFTSHIFT,
    'leftshift': uinput.KEY_LEFTSHIFT,
    'rightshift': uinput.KEY_RIGHTSHIFT,
    'ctrl': uinput.KEY_LEFTCTRL,
    'leftctrl': uinput.KEY_LEFTCTRL,
    'rightctrl': uinput.KEY_RIGHTCTRL,
    'alt': uinput.KEY_LEFTALT,
    'leftalt': uinput.KEY_LEFTALT,
    'rightalt': uinput.KEY_RIGHTALT,
    'meta': uinput.KEY_LEFTMETA,
    'leftmeta': uinput.KEY_LEFTMETA,
    'rightmeta': uinput.KEY_RIGHTMETA,
    'super': uinput.KEY_LEFTMETA,  # Alias for meta
    'cmd': uinput.KEY_LEFTMETA,    # Alias for meta
    'win': uinput.KEY_LEFTMETA,    # Alias for meta

    # Additional common keys
    'space': uinput.KEY_SPACE,
    'capslock': uinput.KEY_CAPSLOCK,
    'numlock': uinput.KEY_NUMLOCK,
    'scrolllock': uinput.KEY_SCROLLLOCK,
    'pause': uinput.KEY_PAUSE,
    'printscreen': uinput.KEY_SYSRQ,
    'prtsc': uinput.KEY_SYSRQ,     # Alias for printscreen
    'menu': uinput.KEY_MENU,
}

# Key combinations for common shortcuts
KEY_COMBINATIONS = {
    'ctrl+c': [uinput.KEY_LEFTCTRL, uinput.KEY_C],
    'ctrl+v': [uinput.KEY_LEFTCTRL, uinput.KEY_V],
    'ctrl+x': [uinput.KEY_LEFTCTRL, uinput.KEY_X],
    'ctrl+z': [uinput.KEY_LEFTCTRL, uinput.KEY_Z],
    'ctrl+y': [uinput.KEY_LEFTCTRL, uinput.KEY_Y],
    'ctrl+a': [uinput.KEY_LEFTCTRL, uinput.KEY_A],
    'ctrl+s': [uinput.KEY_LEFTCTRL, uinput.KEY_S],
    'ctrl+o': [uinput.KEY_LEFTCTRL, uinput.KEY_O],
    'ctrl+n': [uinput.KEY_LEFTCTRL, uinput.KEY_N],
    'ctrl+w': [uinput.KEY_LEFTCTRL, uinput.KEY_W],
    'ctrl+q': [uinput.KEY_LEFTCTRL, uinput.KEY_Q],
    'alt+tab': [uinput.KEY_LEFTALT, uinput.KEY_TAB],
    'alt+f4': [uinput.KEY_LEFTALT, uinput.KEY_F4],
    'ctrl+alt+del': [uinput.KEY_LEFTCTRL, uinput.KEY_LEFTALT, uinput.KEY_DELETE],
}


def get_key_code(key_name):
    """Get the key code for a given key name"""
    key_name = key_name.lower().strip()

    # Check for key combinations first
    if key_name in KEY_COMBINATIONS:
        return KEY_COMBINATIONS[key_name], True

    # Check for single keys
    if key_name in SPECIAL_KEYS:
        return SPECIAL_KEYS[key_name], False

    # If not found, return None
    return None, False


def emit_key_press(device, key_code, duration=0.01):
    """Emit a single key press and release"""
    device.emit(key_code, 1)  # Press key
    device.syn()
    time.sleep(duration)
    device.emit(key_code, 0)  # Release key
    device.syn()


def emit_key_combination(device, key_codes, duration=0.01, release_delay=0.01):
    """Emit a key combination (press all, then release all)"""
    # Press all keys
    for key_code in key_codes:
        device.emit(key_code, 1)
        device.syn()
        time.sleep(0.01)  # Small delay between key presses

    # Hold the combination
    time.sleep(duration)

    # Release all keys in reverse order
    for key_code in reversed(key_codes):
        device.emit(key_code, 0)
        device.syn()
        time.sleep(release_delay)


def simulate_key_sequence(device, keys, delay_between_keys=0.1, key_duration=0.01):
    """Simulate a sequence of keys or key combinations"""

    for key_name in keys:
        key_result, is_combination = get_key_code(key_name)

        if key_result is None:
            print(f"Warning: Unknown key '{key_name}'", file=sys.stderr)
            print(f"Available keys: {', '.join(sorted(SPECIAL_KEYS.keys()))}", file=sys.stderr)
            print(f"Available combinations: {', '.join(sorted(KEY_COMBINATIONS.keys()))}", file=sys.stderr)
            continue

        if is_combination:
            print(f"Sending key combination: {key_name}")
            emit_key_combination(device, key_result, key_duration, 0.01)
        else:
            print(f"Sending key: {key_name}")
            emit_key_press(device, key_result, key_duration)

        # Wait before next key
        if delay_between_keys > 0:
            time.sleep(delay_between_keys)


def list_available_keys():
    """Print all available keys and combinations"""
    print("Available Special Keys:")
    print("=" * 50)

    # Group keys by category
    function_keys = [k for k in SPECIAL_KEYS.keys() if k.startswith('f') and k[1:].isdigit()]
    arrow_keys = ['up', 'down', 'left', 'right']
    control_keys = ['enter', 'return', 'delete', 'del', 'tab', 'escape', 'esc',
                   'backspace', 'insert', 'ins', 'home', 'end', 'pageup', 'pgup',
                   'pagedown', 'pgdn', 'space']
    modifier_keys = [k for k in SPECIAL_KEYS.keys() if any(mod in k.lower() for mod in
                    ['shift', 'ctrl', 'alt', 'meta', 'super', 'cmd', 'win'])]
    other_keys = [k for k in SPECIAL_KEYS.keys() if k not in function_keys + arrow_keys +
                 control_keys + modifier_keys]

    print(f"Function Keys ({len(function_keys)}): {', '.join(sorted(function_keys))}")
    print(f"Arrow Keys ({len(arrow_keys)}): {', '.join(arrow_keys)}")
    print(f"Control Keys ({len(control_keys)}): {', '.join(control_keys)}")
    print(f"Modifier Keys ({len(modifier_keys)}): {', '.join(sorted(modifier_keys))}")
    if other_keys:
        print(f"Other Keys ({len(other_keys)}): {', '.join(sorted(other_keys))}")

    print("\nAvailable Key Combinations:")
    print("=" * 50)
    for combo in sorted(KEY_COMBINATIONS.keys()):
        print(f"  {combo}")

    print(f"\nTotal: {len(SPECIAL_KEYS)} keys, {len(KEY_COMBINATIONS)} combinations")


def main():
    parser = argparse.ArgumentParser(
        description="Send special keys and key combinations using uinput.",
        epilog="Examples:\n"
               "  %(prog)s f1                    # Send F1 key\n"
               "  %(prog)s up down left right    # Send arrow key sequence\n"
               "  %(prog)s ctrl+c                # Send Ctrl+C combination\n"
               "  %(prog)s enter tab enter       # Send Enter, Tab, Enter\n"
               "  %(prog)s --list                # Show all available keys",
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("keys", nargs="*",
                        help="Key names or combinations to send (space-separated)")
    parser.add_argument("--delay", type=float, default=0.1,
                        help="Delay between keys in seconds (default: 0.1)")
    parser.add_argument("--key-duration", type=float, default=0.01,
                        help="Duration of each key press in seconds (default: 0.01)")
    parser.add_argument("--start-delay", type=float, default=3.0,
                        help="Delay before starting to send keys (default: 3.0)")
    parser.add_argument("--list", action="store_true",
                        help="List all available keys and combinations")
    parser.add_argument("--repeat", type=int, default=1,
                        help="Number of times to repeat the key sequence (default: 1)")

    args = parser.parse_args()

    if args.list:
        list_available_keys()
        return

    if not args.keys:
        parser.print_help()
        print("\nError: No keys specified. Use --list to see available keys.")
        return

    # Collect all possible key codes that might be needed
    all_keys = set(SPECIAL_KEYS.values())
    for combo in KEY_COMBINATIONS.values():
        all_keys.update(combo)

    # Add basic alphabet keys for combinations
    # for char in CHAR_TO_KEYCODE.values():
    #     all_keys.update(char)
    all_keys.update(CHAR_TO_KEYCODE.values())

    # Create a virtual keyboard device
    try:
        device = uinput.Device(list(all_keys))
    except Exception as e:
        print(f"Error creating virtual keyboard device: {e}", file=sys.stderr)
        print("Make sure you have the necessary permissions (try running with sudo)", file=sys.stderr)
        print("and that the uinput module is loaded (sudo modprobe uinput)", file=sys.stderr)
        return

    print(f"Virtual keyboard created. Waiting {args.start_delay} seconds before sending keys...")
    time.sleep(args.start_delay)

    for repeat_count in range(args.repeat):
        if args.repeat > 1:
            print(f"\nRepeat {repeat_count + 1}/{args.repeat}:")

        simulate_key_sequence(device, args.keys, args.delay, args.key_duration)

        if repeat_count < args.repeat - 1:  # Don't delay after the last repetition
            time.sleep(args.delay)

    print("Key sequence completed.")


if __name__ == "__main__":
    main()
