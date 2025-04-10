#!/usr/bin/env python3

import argparse
import json
import os
import re
import subprocess
import sys

import xml.etree.ElementTree as ET

TESTS = ('cpu_1_core', 'cpu_4_core', 'memory', 'rendering')

def parse_args(argument_list):
    parser = argparse.ArgumentParser(
        description="Run stress tests.",
    )
    parser.add_argument('--new-baseline', action='store_true', dest='new_baseline', help='Save generated results as new baseline')
    parser.add_argument('--report', action='store_true', dest='report', help='Return actual and expected results')
    parser.add_argument('--filter', dest='filter', choices=TESTS, help='Filter by test name')
    return parser.parse_args(argument_list)

def run_stress_test(cmd):
    output = "/tmp/output.yaml"
    cmd = "%s --metrics-brief --yaml %s &>/dev/null" % (cmd, output)
    subprocess.run(cmd, shell=True, stdout=subprocess.PIPE)

    if not os.path.exists(output) or os.stat(output).st_size == 0:
        return

    metrics = parse_yaml(output)

    os.remove(output)
    return metrics

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

def run_glmark2_es2_wayland():
    WAYLAND_DISPLAY="/run/wayland-0"
    output = "/tmp/results.xml"

    cmd = f"WAYLAND_DISPLAY={WAYLAND_DISPLAY} glmark2-es2-wayland -b effect2d:duration=5.0 --results-file {output} &>/dev/null"
    subprocess.run(cmd, shell=True, stdout=subprocess.PIPE)

    if not os.path.exists(output) or os.stat(output).st_size == 0:
        return

    with open(output, "r") as fd:
        tree = ET.parse(fd)
        root = tree.getroot()

        status = root.find('.//benchmark/status')
        if status.text == "Success":
            fps = int(root.find('.//benchmark/fps').text)

    os.remove(output)
    return fps

def run_stress_cpu_1_core():
    ret = run_stress_test("stress-ng --cpu 1 --timeout 10s")
    return ret and int(ret['bogo-ops'])

def run_stress_cpu_4_core():
    ret = run_stress_test("stress-ng --cpu 4 --timeout 10s")
    return ret and int(ret['bogo-ops'])

def run_stress_memory():
    ret = run_stress_test("stress-ng --vm 1 --vm-bytes 500M --timeout 10s")
    return ret and int(ret['bogo-ops'])

TESTS_DICT = {
    'cpu_1_core': run_stress_cpu_1_core,
    'cpu_4_core': run_stress_cpu_4_core,
    'memory': run_stress_memory,
    'rendering': run_glmark2_es2_wayland,
}

def run_tests(key=None):
    result = {}
    if key:
        if key in TESTS_DICT.keys():
            callback = TESTS_DICT[key]
            result[key] = callback()
    else:
        for each in TESTS_DICT.keys():
            callback = TESTS_DICT[each]
            result[each] = callback()
    return result

def read_baseline():
    filename = get_baseline_filename()
    with open(filename, "r+") as fd:
        return json.load(fd)

def update_baseline(results):
    filename = get_baseline_filename()
    with open(filename, "w+") as fd:
        fd.write(json.dumps(results))

def get_baseline_filename():
    root = os.path.dirname(os.path.abspath(__file__))
    dirname = os.path.join(root, "..", "tests-baselines", "stress-tests")
    if not os.path.exists(dirname):
        os.makedirs(dirname)
    filename = "%s-expected.json" % get_platform()
    return os.path.realpath(os.path.join(dirname, filename))

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
        dump(actual_results)

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
