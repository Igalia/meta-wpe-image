*** Settings ***
Test Timeout    120 seconds

Library    OperatingSystem
Library    ../libs/TestUtils.py

Resource   variables.robot
Resource   keywords_common.robot

Suite Setup     Wait For Check Device Is IDLE


*** Test Cases ***
WPE Testbed Unbounded
    ${stdout}=        SSH Command                               %{TEST_BOARD_IP}                /root/scripts/wpe-testbed.py --report --filter unbounded
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}

WPE Testbed Unbounded And No Animate
    ${stdout}=        SSH Command                               %{TEST_BOARD_IP}                /root/scripts/wpe-testbed.py --report --filter unbounded_and_no_animate
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}


*** Keywords ***
Wait For Check Device Is IDLE
    SSH Force Kill                 %{TEST_BOARD_IP}    wpe-simple-launcher
    Wait Until Keyword Succeeds    18x    10s    Check Device Is IDLE
