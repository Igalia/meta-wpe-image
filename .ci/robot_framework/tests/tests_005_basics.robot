*** Settings ***
Test Timeout    60 seconds

Library    OperatingSystem
Library    ../libs/TestUtils.py

Resource   variables.robot

*** Test Cases ***
Check Kernel Configuration available in /proc/config.gz
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${stdout}=    SSH Command    ${TEST_BOARD_IP}    zcat /proc/config.gz |grep "Kernel Configuration"
    Log    ${stdout}
    Should Contain    ${stdout}[0]    Kernel Configuration

Check L2 Cache is enabled
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${stdout}=    SSH Command    ${TEST_BOARD_IP}   cat /boot/config.txt | grep -E -q "^disable_l2cache=1$" || echo "L2 cache enabled"
    Log    ${stdout}
    Should Contain    ${stdout}[0]    L2 cache enabled
