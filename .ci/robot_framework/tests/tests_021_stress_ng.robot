*** Settings ***
Test Timeout    65 seconds

Library    OperatingSystem
Library    ../libs/TestUtils.py

Resource   variables.robot

*** Test Cases ***
CPU Stress test
    ${TEST_BOARD_IP}  Get Environment Variable  TEST_BOARD_IP
    ${stdout}=  SSH Command  ${TEST_BOARD_IP}	stress-ng --cpu 0 --timeout 60s --metrics-brief
    Log  ${stdout}
    ${failed}= 	Run 	echo "${stdout}" | sed -n -r "s|.*failed: ([0-9]+)$|\\1|p"
    Should Be Equal  ${failed}  0

Memory Stress test
    ${TEST_BOARD_IP}  Get Environment Variable  TEST_BOARD_IP
    ${stdout}=  SSH Command  ${TEST_BOARD_IP}	stress-ng --vm 1 --vm-bytes 80% --timeout 60s --metrics-brief
    Log  ${stdout}
    ${failed}= 	Run 	echo "${stdout}" | sed -n -r "s|.*failed: ([0-9]+)$|\\1|p"
    Should Be Equal  ${failed}  0
