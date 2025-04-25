#!/usr/bin/env python3

import os
import subprocess
import sys

import xml.etree.ElementTree as ET

from harness import BaselineHandler, TestRunner, dump, isWandboard, parse_args, parse_yaml, wayland_display


def run_stress_cpu_1_core():
    ret = run_stress_test("stress-ng --cpu 1 --timeout 10s")
    return ret and int(ret['bogo-ops'])


def run_stress_cpu_4_core():
    ret = run_stress_test("stress-ng --cpu 4 --timeout 10s")
    return ret and int(ret['bogo-ops'])


def run_stress_memory():
    ret = run_stress_test("stress-ng --vm 1 --vm-bytes 500M --timeout 10s")
    return ret and int(ret['bogo-ops'])


def run_stress_test(cmd):
    output = "/tmp/output.yaml"
    cmd = "%s --metrics-brief --yaml %s &>/dev/null" % (cmd, output)
    subprocess.run(cmd, shell=True, stdout=subprocess.PIPE)

    if not os.path.exists(output) or os.stat(output).st_size == 0:
        return

    metrics = parse_yaml(output)

    os.remove(output)
    return metrics


def run_glmark2_es2_wayland():
    output = "/tmp/results.xml"

    WAYLAND_DISPLAY = wayland_display()
    cmd = f"WAYLAND_DISPLAY={WAYLAND_DISPLAY} glmark2-es2-wayland -b effect2d:duration=5.0 --results-file {output} &>/dev/null"  # noqa: E501
    subprocess.run(cmd, shell=True, stdout=subprocess.PIPE)

    if not os.path.exists(output) or os.stat(output).st_size == 0:
        return

    fps = 0
    with open(output, "r") as fd:
        tree = ET.parse(fd)
        root = tree.getroot()

        status = root.find('.//benchmark/status')
        if status.text == "Success":
            fps = int(root.find('.//benchmark/fps').text)

    os.remove(output)
    return fps


TESTS = {
    'cpu_1_core': run_stress_cpu_1_core,
    'cpu_4_core': run_stress_cpu_4_core,
    'memory': run_stress_memory,
    'rendering': run_glmark2_es2_wayland,
}


def main(argument_list):
    filter_choices = sorted(TESTS.keys())
    args = parse_args(argument_list, filter_choices)

    baseline = BaselineHandler("stress-tests")
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
