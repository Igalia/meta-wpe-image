*** Settings ***
Test Timeout    60 seconds

Library    OperatingSystem
Library    ../libs/TestUtils.py

Resource   variables.robot
Resource   keywords_common.robot

Suite Setup     Wait For Check Device Is IDLE


*** Test Cases ***
CPU 1 Stress Test
    ${stdout}=        SSH Command                               %{TEST_BOARD_IP}             /root/scripts/stress-test.py --report --filter cpu_1_core
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}

CPU 4 Stress Test
    ${stdout}=        SSH Command                               %{TEST_BOARD_IP}             /root/scripts/stress-test.py --report --filter cpu_4_core
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}

Memory Stress Test
    ${stdout}=        SSH Command                               %{TEST_BOARD_IP}             /root/scripts/stress-test.py --report --filter memory
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}

2D Rendering Stress Test
    ${stdout}=        SSH Command                               %{TEST_BOARD_IP}                /root/scripts/stress-test.py --report --filter rendering
    ${data}=          Evaluate                                  json.loads('''${stdout}[0]''')  json
    Should Be True    ${data['actual']} >= ${data['expected']}


*** Keywords ***
Wait For Check Device Is IDLE
    SSH Force Kill                 %{TEST_BOARD_IP}    wpe-simple-launcher
    Wait Until Keyword Succeeds    18x    10s    Check Device Is IDLE
