A Robot Framework tests suite for automating the validation of the
meta-wpe-image images.

# Installation

We have the  `install-requirements.sh` and `podman-compose.sh` scripts in the
project.The first one is a convenient script for installing the Podman
requirements. The second, is a wrapper for execute the podman-compose command
but with the environment variables defined in the setup-env.sh.

``` sh
./install-requirements.sh
cp setup-env-local.sh.sample setup-env-local.sh  # Use an editor for adapt the content
```

A sample environment setup file (`setup-env-local.sh.sample`) is provided to
guide the initial configuration. It sets the variables for the test board and
network configurations adapted to your environment.

## How It Works

To set up the testing environment, run:

```sh
./podman-compose.sh up --force-recreate --always-recreate-deps --build -d -t 4
```

Once the environment is running, you can trigger the tests with the
`./run-tests.sh` launcher:

```sh
./run-tests.sh
```

By default, the `run-tests.sh` script runs all the Robot Framework tests inside
`.ci/robot_framework/tests`. To filter which tests to run, pass the path to the
test as argument. For example:

```sh
./run-tests.sh robot_framework/tests/tests_005_basics.robot
```

It's possible to pass more than one test:

```sh
./run-tests.sh robot_framework/tests/tests_005_basics.robot robot_framework/tests/tests_010_input_events.robot
```

### Services Setup

The `./podman-compose.sh up` command initializes the following services:

- **webserver**: Runs an NGINX container, exposing port **8008** for HTTP
  requests.
- **robot**: Runs a Python-based container configured for executing tests
  using the Robot Framework.

### Running Tests

To execute the tests, use:

```sh
./run-tests.sh [options]
```

Options:

- `--force-recreate` : Recreate and build containers before running tests.
- `--help` : Display the help message for available options.

### Stopping the Containers

To stop the Podman containers, use:

```sh
./podman-compose.sh down -t 4
```

