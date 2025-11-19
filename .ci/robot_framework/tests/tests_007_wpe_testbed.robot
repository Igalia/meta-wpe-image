*** Settings ***
Test Timeout    120 seconds

Library    OperatingSystem
Library    ../libs/TestUtils.py

Resource   variables.robot
Resource   keywords_common.robot

*** Test Cases ***
WPE Testbed Unbounded
    Wait Until Keyword Succeeds    18x    10s    Check Device Is IDLE
    ${TEST_BOARD_IP}  Get Environment Variable                  TEST_BOARD_IP
    ${stdout}=        SSH Command                               ${TEST_BOARD_IP}                /root/scripts/wpe-testbed.py --report --filter unbounded
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}

WPE Testbed Unbounded And No Animate
    Wait Until Keyword Succeeds    18x    10s    Check Device Is IDLE
    ${TEST_BOARD_IP}  Get Environment Variable                  TEST_BOARD_IP
    ${stdout}=        SSH Command                               ${TEST_BOARD_IP}                /root/scripts/wpe-testbed.py --report --filter unbounded_and_no_animate
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}
