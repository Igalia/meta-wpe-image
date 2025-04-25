import argparse
import json
import os
import re


def dump(results):
    print(json.dumps(results))


def get_platform():
    platforms = {
        'pi3': 'rpi3',
        'pi5': 'rpi5',
        'wandboard': 'wandboard',
    }
    hostname = os.uname().nodename
    for key in platforms.keys():
        if key in hostname:
            return platforms[key]
    return "generic"


def isWandboard():
    return get_platform() == "wandboard"


def parse_args(argument_list, filter_choices):
    parser = argparse.ArgumentParser(
        description="Run WPE testbed.",
    )
    arg = parser.add_argument
    arg('--new-baseline', action='store_true', dest='new_baseline',
        help='Save generated results as new baseline')
    arg('--report', action='store_true', dest='report',
        help='Return actual and expected results')
    arg('--filter', dest='filter', choices=filter_choices,
        help='Filter by test name')
    return parser.parse_args(argument_list)


# Manually parse yaml to avoid relying on yaml library.
def parse_yaml(filename):
    results = {}
    start = False
    with open(filename, "r") as fd:
        for line in fd.readlines():
            if re.match("metrics:", line):
                start = True
                continue
            if start:
                m = re.match(r'(.*?): (.*)$', line)
                if m:
                    key = m.group(1).strip()
                    value = m.group(2).strip()
                    if re.match(r'^- ', key):
                        key = key[2:]
                    results[key] = value
    return results


def wayland_display():
    if os.getenv("WAYLAND_DISPLAY"):
        return os.getenv("WAYLAND_DISPLAY")
    for filename in ['/run/user/0/wayland-0', '/run/wayland-0']:
        if os.path.exists(filename):
            return filename


class TestRunner:

    def __init__(self, tests):
        self.tests = tests

    def run_tests(self, testname):
        assert(self.tests)
        result = {}
        keys = [testname] or self.tests.keys()
        for each in keys:
            result[each] = self.run_test(each)
        return result

    def run_test(self, name):
        if name not in self.tests:
            return
        fn = self.tests[name]
        return fn()


class BaselineHandler:

    def __init__(self, dirname):
        self.dirname = dirname

    def read(self):
        filename = self.get_baseline_filename()
        with open(filename, "r+") as fd:
            return json.load(fd)

    def update(self, results):
        filename = self.get_baseline_filename()
        with open(filename, "w+") as fd:
            fd.write(json.dumps(results))

    def get_baseline_filename(self):
        return self.get_baseline_path()

    def get_baseline_path(self):
        root = os.path.dirname(os.path.abspath(__file__))
        dirname = os.path.join(root, "..", "tests-baselines", self.dirname)
        if not os.path.exists(dirname):
            os.makedirs(dirname)
        filename = "%s-expected.json" % get_platform()
        return os.path.realpath(os.path.join(dirname, filename))
