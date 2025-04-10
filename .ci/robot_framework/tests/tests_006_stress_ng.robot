*** Settings ***
Test Timeout    60 seconds

Library    OperatingSystem
Library    ../libs/TestUtils.py

Resource   variables.robot

*** Test Cases ***
CPU 1 Stress Test
    ${TEST_BOARD_IP}  Get Environment Variable                  TEST_BOARD_IP
    ${stdout}=        SSH Command                               ${TEST_BOARD_IP}             /root/scripts/stress-test.py --report --filter cpu_1_core
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}

CPU 4 Stress Test
    ${TEST_BOARD_IP}  Get Environment Variable                  TEST_BOARD_IP
    ${stdout}=        SSH Command                               ${TEST_BOARD_IP}             /root/scripts/stress-test.py --report --filter cpu_4_core
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}

Memory Stress Test
    ${TEST_BOARD_IP}  Get Environment Variable                  TEST_BOARD_IP
    ${stdout}=        SSH Command                               ${TEST_BOARD_IP}             /root/scripts/stress-test.py --report --filter memory
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}

2D Rendering Stress Test
    ${TEST_BOARD_IP}  Get Environment Variable                  TEST_BOARD_IP
    ${stdout}=        SSH Command                               ${TEST_BOARD_IP}                /root/scripts/stress-test.py --report --filter rendering
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}
