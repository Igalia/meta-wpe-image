#!/usr/bin/env python3

import argparse
import json
import os
import re
import subprocess
import sys

import xml.etree.ElementTree as ET

TESTS = ('unbounded', 'unbounded_and_no_animate')

def parse_args(argument_list):
    parser = argparse.ArgumentParser(
        description="Run WPE testbed.",
    )
    parser.add_argument('--new-baseline', action='store_true', dest='new_baseline', help='Save generated results as new baseline')
    parser.add_argument('--report', action='store_true', dest='report', help='Return actual and expected results')
    parser.add_argument('--filter', dest='filter', choices=TESTS, help='Filter by test name')
    return parser.parse_args(argument_list)

# Utility class to compose run wpe-testbed.
class WPETestbed:

    WAYLAND_DISPLAY="/run/wayland-0"
    program = "wpe-testbed-wayland"

    def __init__(self, **kwargs):
        # Set default values.
        if "tiles" not in kwargs:
            self.tiles = 1
        if not "opaque" in kwargs:
            self.opaque = True
        if not "fences" in kwargs:
            self.fences = True
        if not "title_update_method" in kwargs:
            self.title_update_method = "mmap"
        if not "dmabuf_tiles" in kwargs:
            self.dmabug_tiles = True
        if not "frames" in kwargs:
            self.frames = 2000
        if not "drm_node_ipu" in kwargs:
            self.drm_node_ipu = "/dev/dri/card0"
        if not "drm_node_gpu" in kwargs:
            self.drm_node_gpu = "/dev/dri/card0"
        # Parse arguments.
        for key in kwargs.keys():
            setattr(self, key, kwargs[key])

    def compose(self):
        def as_arg(value):
            return '--%s' % value.replace('_', '-')

        result = [self.program]
        for attr in vars(self):
            value = getattr(self, attr)
            if isinstance(value, bool):
                if value == True:
                    result.append(as_arg(attr))
            else:
                result.append(as_arg(attr))
                result.append(str(value))
        return result

    def run(self):
        try:
            cmd = f"WAYLAND_DISPLAY={self.WAYLAND_DISPLAY} " + " ".join(self.compose())
            output = subprocess.run(cmd, shell=True, stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
        except Exception as e:
            return

        for line in output.stdout.splitlines():
            m = re.match(r"Rendered .* \(([0-9.]+) fps\)$", line.decode('utf-8'))
            if m:
                fps = float(m.group(1))
        return fps

def run_wpetestbed_unbounded():
    if isWandboard():
        return WPETestbed(drm_node_ipu="/dev/dri/card1", unbounded=True).run()
    else:
        return WPETestbed(unbounded=True).run()

def run_wpetestbed_unbounded_and_no_animate():
    if isWandboard():
        return WPETestbed(drm_node_ipu="/dev/dri/card1", unbounded=True, no_animate=True).run()
    else:
        return WPETestbed(unbounded=True, no_animate=True).run()

def isWandboard():
    return get_platform() == "wandboard"

def get_platform():
    hostname = os.uname().nodename
    if "pi3" in hostname:
        return "rpi3"
    elif "pi5" in hostname:
        return "rpi5"
    elif "wandboard" in hostname:
        return "wandboard"
    else:
        return "other"

TESTS_DICT = {
    'unbounded': run_wpetestbed_unbounded,
    'unbounded_and_no_animate': run_wpetestbed_unbounded_and_no_animate,
}

def run_tests(key=None):
    result = {}
    if key and not key in TESTS_DICT.keys():
        return result
    for key in ([key] or TESTS_DICT.keys()):
        callback = TESTS_DICT[key]
        value = callback()
        if value:
            result[key] = value
    return result

def read_baseline():
    filename = get_baseline_filename()
    with open(filename, "r+") as fd:
        return json.load(fd)

def update_baseline(results):
    filename = get_baseline_filename()
    with open(filename, "w+") as fd:
        fd.write(json.dumps(results))

def get_baseline_path(dirname):
    root = os.path.dirname(os.path.abspath(__file__))
    dirname = os.path.join(root, "..", "tests-baselines", dirname)
    if not os.path.exists(dirname):
        os.makedirs(dirname)
    filename = "%s-expected.json" % get_platform()
    return os.path.realpath(os.path.join(dirname, filename))

def get_baseline_filename():
    return get_baseline_path("wpe-testbed")

def dump(results):
	print(json.dumps(results))

def main(argument_list):
    args = parse_args(argument_list)

    actual_results = run_tests(args.filter)
    if args.new_baseline:
        update_baseline(actual_results)
    elif args.report:
        expected_results = read_baseline()
        if args.filter:
            dump({'actual': actual_results[args.filter], 'expected': expected_results[args.filter]})
        else:
            dump({'actual': actual_results, 'expected': expected_results})
    else:
        if actual_results:
            dump(actual_results)

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
