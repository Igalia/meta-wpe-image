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
    ${stdout}=    SSH Command    ${TEST_BOARD_IP}   /root/scripts/check-l2-cache-is-enabled.sh
    Should Be Equal As Strings  ${stdout}[0]  L2 cache enabled

Check Kernel Configuration CONFIG_HID_MULTITOUCH Is Enabled
    [Documentation]    Verify that the kernel configuration contains
    ...                CONFIG_HID_MULTITOUCH enabled. This ensures that
    ...                multitouch input support is available in the kernel.
    ...                The test fails if the configuration is missing or
    ...                explicitly disabled.
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${stdout}=    SSH Command    ${TEST_BOARD_IP}    zcat /proc/config.gz | grep "CONFIG_HID_MULTITOUCH"
    Log    ${stdout}
    Should Not Contain    ${stdout}[0]    CONFIG_HID_MULTITOUCH is not set

Check Weston Service
    Wait Until Keyword Succeeds    3x    1000ms    Start And Status Weston Service

*** Keywords ***
Start And Status Weston Service
    ${TEST_BOARD_IP}=    Get Environment Variable    TEST_BOARD_IP
    SSH Command    ${TEST_BOARD_IP}    systemctl start weston
    ${stdout}=    SSH Command    ${TEST_BOARD_IP}    systemctl status weston
    Should Contain    ${stdout}[0]    Active: active (running)

