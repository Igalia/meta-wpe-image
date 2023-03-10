# Copyright (c) 2013, Thomas P. Robitaille
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

from __future__ import (unicode_literals, division, print_function,
                        absolute_import)

import time
import argparse
import csv


def get_percent(process):
    try:
        return process.cpu_percent()
    except AttributeError:
        return process.get_cpu_percent()


def get_memory(process):
    return process.memory_full_info()


def all_children(pr):
    processes = []
    children = []
    try:
        children = pr.children()
    except AttributeError:
        children = pr.get_children()
    except Exception:  # pragma: no cover
        pass

    for child in children:
        processes.append(child)
        processes += all_children(child)
    return processes


def main():

    parser = argparse.ArgumentParser(
        description='Record CPU and memory usage for a process')

    parser.add_argument('process_id_or_command', type=str,
                        help='the process id or command')

    parser.add_argument('--log', type=str,
                        help='output the statistics to a csv file')

    parser.add_argument('--plot', type=str,
                        help='output the statistics to a plot')

    parser.add_argument('--duration', type=float,
                        help='how long to record for (in seconds). If not '
                             'specified, the recording is continuous until '
                             'the job exits.')

    parser.add_argument('--interval', type=float,
                        help='how long to wait between each sample (in '
                             'seconds). By default the process is sampled '
                             'as often as possible.')

    parser.add_argument('--include-children',
                        help='include sub-processes in statistics (results '
                             'in a slower maximum sampling rate).',
                        action='store_true')

    parser.add_argument('--use-unix-ts',
                        help='When used, time would be logged in unix timestamp',
                        action='store_true')

    args = parser.parse_args()

    # Attach to process
    try:
        pid = int(args.process_id_or_command)
        print("Attaching to process {0}".format(pid))
        sprocess = None
    except Exception:
        import subprocess
        command = args.process_id_or_command
        print("Starting up command '{0}' and attaching to process"
              .format(command))
        sprocess = subprocess.Popen(command, shell=True)
        pid = sprocess.pid

    monitor(pid, logfile=args.log, plot=args.plot, duration=args.duration,
            interval=args.interval, include_children=args.include_children,
            use_unix_ts=args.use_unix_ts)

    if sprocess is not None:
        sprocess.kill()


def monitor(pid, logfile=None, plot=None, duration=None, interval=None,
            include_children=False, use_unix_ts=False):

    # We import psutil here so that the module can be imported even if psutil
    # is not present (for example if accessing the version)
    import psutil

    pr = psutil.Process(pid)

    # Record start time
    start_time = time.time()

    if logfile:
        fields = ['time', 'cpu', 'mem_real', 'mem_virtual']
        f = open(logfile, 'w')
        stat_writer = csv.DictWriter(f, fieldnames=fields,
                                     extrasaction='ignore')
        stat_writer.writeheader()

    log = {}
    log['times'] = []
    log['cpu'] = []
    log['mem_real'] = []
    log['mem_virtual'] = []

    try:
        # Gather first CPU metric and don't use it, as mentioned in the documentation.
        current_cpu = get_percent(pr)

        # Start main event loop
        while True:

            # Find current time
            current_time = time.time()
            logged_time = (current_time - start_time) if not use_unix_ts \
                else current_time

            try:
                pr_status = pr.status()
            except TypeError:  # psutil < 2.0
                pr_status = pr.status
            except psutil.NoSuchProcess:  # pragma: no cover
                break

            # Check if process status indicates we should exit
            if pr_status in [psutil.STATUS_ZOMBIE, psutil.STATUS_DEAD]:
                print("Process finished ({0:.2f} seconds)"
                      .format(logged_time))
                break

            # Check if we have reached the maximum time
            if duration is not None and current_time - start_time > duration:
                break

            # Get current CPU and memory
            try:
                current_cpu = get_percent(pr)
                current_mem = get_memory(pr)
            except Exception:
                break
            current_mem_real = current_mem.pss / 1024. ** 2
            current_mem_virtual = current_mem.vms / 1024. ** 2

            # Get information for children
            if include_children:
                for child in all_children(pr):
                    try:
                        current_cpu += get_percent(child)
                        current_mem = get_memory(child)
                    except Exception:
                        continue
                    current_mem_real += current_mem.pss / 1024. ** 2
                    current_mem_virtual += current_mem.vms / 1024. ** 2

            if logfile:
                stat_writer.writerow({
                    'time': logged_time,
                    'cpu': current_cpu,
                    'mem_real': current_mem_real,
                    'mem_virtual': current_mem_virtual})
                f.flush()

            if interval is not None:
                time.sleep(interval)

            # If plotting, record the values
            if plot:
                log['times'].append(logged_time)
                log['cpu'].append(current_cpu)
                log['mem_real'].append(current_mem_real)
                log['mem_virtual'].append(current_mem_virtual)

    except KeyboardInterrupt:  # pragma: no cover
        pass

    if logfile:
        f.close()

    if plot:

        # Use non-interactive backend, to enable operation on headless machines
        import matplotlib.pyplot as plt
        with plt.rc_context({'backend': 'Agg'}):

            fig = plt.figure()
            ax = fig.add_subplot(1, 1, 1)

            ax.plot(log['times'], log['cpu'], '-', lw=1, color='r')

            ax.set_ylabel('CPU (%)', color='r')
            ax.set_xlabel('time (s)')
            ax.set_ylim(0., max(log['cpu']) * 1.2)

            ax2 = ax.twinx()

            ax2.plot(log['times'], log['mem_real'], '-', lw=1, color='b')
            ax2.set_ylim(0., max(log['mem_real']) * 1.2)

            ax2.set_ylabel('Real Memory (MB)', color='b')

            ax.grid()

            fig.savefig(plot)
