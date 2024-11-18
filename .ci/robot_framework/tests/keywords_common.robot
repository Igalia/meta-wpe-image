*** Settings ***
Library    Collections
Library    OperatingSystem
Library    ../libs/TestUtils.py

*** Keywords ***
Create WPEWebKitOptions
    [Arguments]    ${binary_name}    ${binary_path}    @{other_params}

    ${wpe_options} =     Evaluate    sys.modules['selenium.webdriver'].WPEWebKitOptions()    sys, selenium.webdriver
    ${wpe_options.binary_location}    Set Variable    ${binary_path}
    FOR    ${param}    IN    @{other_params}
        Call Method    ${wpe_options}    add_argument      ${param}
    END
    Call Method    ${wpe_options}    set_capability    browserName    ${binary_name}
    RETURN    ${wpe_options}

Get Remote CPU Load
    [Timeout]      30 seconds

    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${stdout}=    SSH Command    ${TEST_BOARD_IP}    uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}'
    ${value}=    Evaluate    float(${stdout}[0])
    RETURN    ${value}

Get Remote Memory Used
    [Timeout]      30 seconds

    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${stdout}=    SSH Command    ${TEST_BOARD_IP}    free -m | grep Mem | awk '{print $3}'
    ${value}=    Evaluate    float(${stdout}[0])
    RETURN    ${value}

Webdriver Remote Start
    [Arguments]    @{other_params}
    [Timeout]      2 minutes

    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${TEST_BOARD_WEBDRIVER_PORT}    Get Environment Variable    TEST_BOARD_WEBDRIVER_PORT

    # Force kill previous launchers
    SSH Webdriver Remote Stop    ${TEST_BOARD_IP}
    SSH Force Kill    ${TEST_BOARD_IP}    cog

    SSH Webdriver Remote Start    ${TEST_BOARD_IP}    ${TEST_BOARD_WEBDRIVER_PORT}
    Sleep    5

    ${wpe_options} =    Create WPEWebKitOptions    cog    /usr/bin/cog-fdo-exported-wayland    --automation    @{other_params}
    Create Webdriver    Remote    command_executor=${TEST_BOARD_IP}:${TEST_BOARD_WEBDRIVER_PORT}    options=${wpe_options}

Webdriver Remote Stop
    [Timeout]      2 minutes

    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${TEST_BOARD_WEBDRIVER_PORT}    Get Environment Variable    TEST_BOARD_WEBDRIVER_PORT

    Close All Browsers
    SSH Webdriver Remote Stop    ${TEST_BOARD_IP}
    SSH Force Kill    ${TEST_BOARD_IP}    cog

