#!/usr/bin/env python3

import re
import subprocess
import sys

from harness import BaselineHandler, TestRunner, dump, isWandboard, parse_args, wayland_display


def run_wpetestbed_unbounded():
    if isWandboard():
        return WPETestbed(drm_node_ipu="/dev/dri/card1", unbounded=True).run()
    else:
        return WPETestbed(unbounded=True).run()


def run_wpetestbed_unbounded_and_no_animate():
    if isWandboard():
        return WPETestbed(drm_node_ipu="/dev/dri/card1", unbounded=True,
                          no_animate=True).run()
    else:
        return WPETestbed(unbounded=True, no_animate=True).run()


TESTS = {
    'unbounded': run_wpetestbed_unbounded,
    'unbounded_and_no_animate': run_wpetestbed_unbounded_and_no_animate,
}


# Utility class to compose run wpe-testbed.
class WPETestbed:
    program = "wpe-testbed-wayland"

    def __init__(self, **kwargs):
        # Set default values.
        if "tiles" not in kwargs:
            self.tiles = 1
        if "opaque" not in kwargs:
            self.opaque = True
        if "fences" not in kwargs:
            self.fences = True
        if "title_update_method" not in kwargs:
            self.title_update_method = "mmap"
        if "dmabuf_tiles" not in kwargs:
            self.dmabug_tiles = True
        if "frames" not in kwargs:
            self.frames = 2000
        if "drm_node_ipu" not in kwargs:
            self.drm_node_ipu = "/dev/dri/card0"
        if "drm_node_gpu" not in kwargs:
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
                if value is True:
                    result.append(as_arg(attr))
            else:
                result.append(as_arg(attr))
                result.append(str(value))
        return result

    def run(self):
        WAYLAND_DISPLAY = wayland_display()
        try:
            cmd = " ".join(self.compose())
            cmd = f"WAYLAND_DISPLAY={WAYLAND_DISPLAY} {cmd}"
            output = subprocess.run(cmd, shell=True, stderr=subprocess.STDOUT,
                                    stdout=subprocess.PIPE)
        except Exception:
            return

        fps = 0
        for line in output.stdout.splitlines():
            m = re.match(r"Rendered .* \(([0-9.]+) fps\)$",
                         line.decode('utf-8'))
            if m:
                fps = float(m.group(1))
        return fps


def main(argument_list):
    filter_choices = sorted(TESTS.keys())
    args = parse_args(argument_list, filter_choices)

    baseline = BaselineHandler("wpe-testbed")
    testRunner = TestRunner(TESTS)

    actual_results = testRunner.run_tests(args.filter)
    if args.new_baseline:
        baseline.update(actual_results)
    elif args.report:
        expected_results = baseline.read()
        if args.filter:
            dump({'actual': actual_results[args.filter],
                  'expected': expected_results[args.filter]})
        else:
            dump({'actual': actual_results,
                  'expected': expected_results})
    else:
        if actual_results:
            dump(actual_results)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
