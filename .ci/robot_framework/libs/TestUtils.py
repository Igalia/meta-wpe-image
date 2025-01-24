import argparse
import os
import paramiko
import subprocess
import sys
import time
from multiprocessing import Process
from selenium import webdriver


class TestUtils:
    """Robot Framework library for interacting with remote hosts and running
       tests via SSH and WebDriver."""

    def __init__(self):
        self.driver = None

    def print_envvar(starts_with=""):
        test_args_env_vars = {key: value for key, value in os.environ.items() if
                              key.startswith(starts_with)}

        # Sort the dictionary by key
        sorted_test_args_env_vars = dict(sorted(test_args_env_vars.items()))

        # Print the variables in a well-tabulated format
        for key, value in sorted_test_args_env_vars.items():
            print(f"{key:<30} '{value}'")

    def ssh_command(self, ip, command, quiet=False,  debug=False):
        """Run SSH command."""
        if debug:
            print(f"COMMAND: {ip} {command}", file=sys.stderr)
        username = 'root'
        password = None
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        try:
            client.connect(ip, username=username, password=None)
        except paramiko.ssh_exception.SSHException as e:
            if not password:
                client.get_transport().auth_none(username)
            else:
                raise e
        stdin, stdout, stderr = client.exec_command(command)

        output = stdout.read().decode('utf-8').strip()
        error = stderr.read().decode('utf-8').strip()

        # Ensure command completes before closing the session
        stdout.channel.recv_exit_status()

        client.close()

        return output, error

    def ssh_command_in_background(self, ip, command):
        """Run SSH command in the background without closing the SSH
           connection."""
        process = Process(target=self.ssh_command, args=(ip, command))
        process.start()

    def ssh_force_kill(self, ip, text):
        """Force kill all related process."""
        print(f"RUN: Killing all '{text}' related processes ...")
        command = f"pgrep -f {text} && pgrep -f {text} | xargs kill -9 || echo '{text} not running'"
        return self.ssh_command(ip, command, quiet=True)

    def ssh_reboot_force_reboot(self, ip):
        command("(echo b > /proc/sysrq-trigger) </dev/null &>/dev/null &")
        self.ssh_command_in_background(ip, command)

    def ssh_reboot_wait_for_reboot(self, ip, timeout=60):
        start_time = time.time()
        while True:
            try:
                self.ssh_command(ip, "true")
                print("Host is back online.")
                break
            except Exception:
                print("Host is still down...")
                if time.time() - start_time > timeout:
                    print("Timeout reached, stopping wait.")
                    break
            time.sleep(5)

    def ssh_webdriver_remote_start(self, ip, port):
        command = (
            f"WPEWebDriver --host={ip} "
            f"--port={port} --host-all"
        )
        self.ssh_command_in_background(ip, command)

    def ssh_webdriver_remote_stop(self, ip):
        self.ssh_force_kill(ip, "WPEWebDriver")
