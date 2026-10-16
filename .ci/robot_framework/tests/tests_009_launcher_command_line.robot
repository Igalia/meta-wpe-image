*** Settings ***
Documentation       Validates that /usr/bin/wpe-exported-wayland forwards its command line
...                 arguments verbatim to wpe-simple-launcher.
...
...                 When run as root the wrapper re-executes the launcher through
...                 `su weston -c "..."`, so every argument is parsed a second time by
...                 the inner shell. Arguments with shell metacharacters (e.g. a URL
...                 like `?varname1=X&varname2=Y`) used to be split, truncated or
...                 executed as shell code. Each test launches the wrapper with a
...                 tricky argument list and checks the launcher argv read back from
...                 /proc/<pid>/cmdline, plus that no injected command ran.
...
...                 Upstream fix: https://github.com/moonforgelinux/meta-moonforge/pull/27

Library             Collections
Library             ../libs/TestUtils.py

Suite Setup         Setup Launcher Command Line Suite
Suite Teardown      Teardown Launcher Command Line Suite
Test Teardown       Stop All Launchers
Test Timeout        120 seconds


*** Variables ***
${WRAPPER}              /usr/bin/wpe-exported-wayland
${LAUNCHER}             /usr/bin/wpe-simple-launcher
${CTRL_FILE}            /tmp/wpe-exported-wayland
${CANARY}               /tmp/wpe-launcher-cmdline-canary
${LAUNCHER_SERVICE}     wpe-simple-launcher.service
${CMDLINE_TO_HEX}       python3 -c 'import sys; print(open(sys.argv[1], "rb").read().hex())'
# Every process that may sit between the SSH session and the launcher: the wrapper
# script itself, `sh -c <wrapper ...>` / `su weston -c <wrapper ...>` and
# `su weston -c <launcher ...>` / its inner `sh -c <launcher ...>`. The `[-]` keeps
# the pattern from matching the remote shell that runs pgrep/pkill with it.
${PARENTS_REGEX}        ^[^ ]*sh ${WRAPPER}( |$)|[-]c ${WRAPPER}( |$)|[-]c ${LAUNCHER}( |$)


*** Test Cases ***
Ampersands In Query String As Root
    [Template]    Wrapper Should Forward Arguments As Root
    ${PAGE}?varname1=X&varname2=Y

Ampersand Followed By Command As Root
    [Template]    Wrapper Should Forward Arguments As Root
    ${PAGE}?a=1&touch\${IFS}${CANARY}

Semicolon As Root
    [Template]    Wrapper Should Forward Arguments As Root
    ${PAGE}?a=1;touch\${IFS}${CANARY}

Pipe As Root
    [Template]    Wrapper Should Forward Arguments As Root
    ${PAGE}?a=1|touch\${IFS}${CANARY}

Output Redirection As Root
    [Template]    Wrapper Should Forward Arguments As Root
    ${PAGE}?a=1>${CANARY}

Command Substitution As Root
    [Template]    Wrapper Should Forward Arguments As Root
    ${PAGE}?a=$(touch\${IFS}${CANARY})

Backticks As Root
    [Template]    Wrapper Should Forward Arguments As Root
    ${PAGE}?a=`touch\${IFS}${CANARY}`

Variable Expansion As Root
    [Template]    Wrapper Should Forward Arguments As Root
    ${PAGE}?home=$HOME&user=\${USER}

Quotes As Root
    [Template]    Wrapper Should Forward Arguments As Root
    ${PAGE}?q="double"&r='single'

Whitespace Inside An Argument As Root
    [Template]    Wrapper Should Forward Arguments As Root
    ${PAGE}?q=hello world

Empty And Padded Arguments As Root
    [Template]    Wrapper Should Forward Arguments As Root
    ${PAGE}    ${EMPTY}    ${SPACE}padded${SPACE}

Glob Characters As Root
    [Template]    Wrapper Should Forward Arguments As Root
    # `/*` always matches, so an unquoted inner shell would expand it.
    ${PAGE}?q=*    /*

Multiple Options And URL As Root
    [Template]    Wrapper Should Forward Arguments As Root
    --maximized    --features=!DirPseudo,+WebAnimationsCustomEffects    ${PAGE}?varname1=X&varname2=Y

Ampersands In Query String As Weston User
    [Template]    Wrapper Should Forward Arguments As Weston User
    ${PAGE}?varname1=X&varname2=Y

Multiple Options And URL As Weston User
    [Template]    Wrapper Should Forward Arguments As Weston User
    --maximized    --features=!DirPseudo,+WebAnimationsCustomEffects    ${PAGE}?a=1;touch\${IFS}${CANARY}


*** Keywords ***
Setup Launcher Command Line Suite
    [Documentation]    Stops the wpe-simple-launcher service (if it is running) so the
    ...    only launcher on the board is the one started by each test.

    VAR    ${SERVICE_WAS_ACTIVE}    ${False}    scope=SUITE
    VAR    ${PAGE}    http://%{TEST_WEBSERVER_IP}:%{TEST_WEBSERVER_PORT}/robot_framework/html/home-page.html
    ...    scope=SUITE
    ${stdout}    SSH Command    %{TEST_BOARD_IP}    systemctl is-active ${LAUNCHER_SERVICE} || true
    VAR    ${SERVICE_WAS_ACTIVE}    ${{ $stdout[0] == 'active' }}    scope=SUITE
    SSH Command    %{TEST_BOARD_IP}    systemctl stop ${LAUNCHER_SERVICE} || true
    Stop All Launchers

Teardown Launcher Command Line Suite
    [Documentation]    Restores the wpe-simple-launcher service if it was running before.

    IF    ${SERVICE_WAS_ACTIVE}
        SSH Command    %{TEST_BOARD_IP}    systemctl start ${LAUNCHER_SERVICE}
    END

Stop All Launchers
    [Documentation]    Kills the launcher together with the wrapper/su/sh processes in
    ...    front of it, then removes the canary file.

    SSH Command
    ...    %{TEST_BOARD_IP}
    ...    pkill -9 -f '${PARENTS_REGEX}'; pkill -9 -f '^${LAUNCHER} '; rm -f ${CANARY}; true

Wrapper Should Forward Arguments As Root
    [Documentation]    Runs the wrapper as root (the `su weston -c` code path).
    [Arguments]    @{args}

    ${command}    Evaluate    shlex.join([$WRAPPER, *$args])    modules=shlex
    Wrapper Should Forward Arguments    ${command}    @{args}

Wrapper Should Forward Arguments As Weston User
    [Documentation]    Runs the wrapper as the weston user (the direct exec code path).
    [Arguments]    @{args}

    ${command}    Evaluate    'su weston -c ' + shlex.quote(shlex.join([$WRAPPER, *$args]))    modules=shlex
    Wrapper Should Forward Arguments    ${command}    @{args}

Wrapper Should Forward Arguments
    [Documentation]    Starts `${command}` on the board and checks that the launcher received
    ...    exactly `--ctrl ${CTRL_FILE}` followed by `@{args}`, and that no shell code
    ...    hidden in the arguments was executed.
    [Arguments]    ${command}    @{args}

    VAR    @{expected}    ${LAUNCHER}    --ctrl    ${CTRL_FILE}    @{args}

    SSH Command In Background    %{TEST_BOARD_IP}    ${command}
    ${argv}    Wait Until Keyword Succeeds    20x    500ms    Get Launcher Argv
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${argv}    ${expected}

    # Kill only the launcher: with an unescaped `;` the injected command would run
    # once the launcher exits, so let the parent shells finish before checking.
    SSH Command    %{TEST_BOARD_IP}    pkill -9 -f '^${LAUNCHER} ' || true
    Wait Until Keyword Succeeds    20x    500ms    Launcher Parents Should Be Gone
    Remote Canary Should Not Exist

Get Launcher Argv
    [Documentation]    Returns the argv of the newest wpe-simple-launcher process as a list.
    ...    The cmdline is read as hex so empty arguments and surrounding whitespace survive.

    ${stdout}    SSH Command
    ...    %{TEST_BOARD_IP}
    ...    pid=$(pgrep -n -f '^${LAUNCHER} ') && ${CMDLINE_TO_HEX} /proc/$pid/cmdline
    Should Not Be Empty    ${stdout}[0]    msg=${LAUNCHER} is not running
    ${argv}    Evaluate    bytes.fromhex($stdout[0]).decode().split('\\0')[:-1]
    Log    ${argv}
    RETURN    ${argv}

Launcher Parents Should Be Gone
    [Documentation]    Fails while the wrapper or any su/sh process in front of the launcher
    ...    is still running.

    ${stdout}    SSH Command
    ...    %{TEST_BOARD_IP}
    ...    pgrep -a -f '${PARENTS_REGEX}' || pgrep -f '${PARENTS_REGEX}' || true
    Should Be Empty    ${stdout}[0]    msg=Wrapper/su/sh processes still running:\n${stdout}[0]

Remote Canary Should Not Exist
    [Documentation]    Fails if any injected `touch`/redirection created the canary file.

    ${stdout}    SSH Command    %{TEST_BOARD_IP}    test -e ${CANARY} && echo present || echo absent
    Should Be Equal    ${stdout}[0]    absent
    ...    msg=Shell code embedded in the launcher arguments was executed (${CANARY} was created)
