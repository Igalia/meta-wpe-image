*** Settings ***
Test Timeout    60 seconds

Library    OperatingSystem
Library    ../libs/TestUtils.py

Resource   variables.robot

*** Test Cases ***
WPE Testbed Unbounded
    ${TEST_BOARD_IP}  Get Environment Variable                  TEST_BOARD_IP
    ${stdout}=        SSH Command                               ${TEST_BOARD_IP}                /root/scripts/wpe-testbed.py --report --filter unbounded
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}

WPE Testbed Unbounded And No Animate
    ${TEST_BOARD_IP}  Get Environment Variable                  TEST_BOARD_IP
    ${stdout}=        SSH Command                               ${TEST_BOARD_IP}                /root/scripts/wpe-testbed.py --report --filter unbounded_and_no_animate
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}
