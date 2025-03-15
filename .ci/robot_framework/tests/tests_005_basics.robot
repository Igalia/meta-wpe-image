*** Settings ***
Test Timeout    60 seconds

Library    OperatingSystem
Library    ../libs/TestUtils.py

Resource   variables.robot

*** Test Cases ***
Test Check Kernel Configuration available in /proc/config.gz
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${stdout}=    SSH Command    ${TEST_BOARD_IP}    zcat /proc/config.gz |grep "Kernel Configuration"
    Log    ${stdout}
    Should Contain    ${stdout}    Kernel Configuration

