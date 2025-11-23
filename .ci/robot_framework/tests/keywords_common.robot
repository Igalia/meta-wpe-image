*** Settings ***
Documentation       Common keywords for WPE WebKit testing on embedded devices.
...                 Provides utilities for remote configuration, WebDriver management,
...                 screenshot capture, and system monitoring.

Library             Collections
Library             OperatingSystem
Library             DocTest.VisualTest
Library             SeleniumLibrary
Library             ../libs/TestUtils.py
Resource            variables.robot


*** Keywords ***
Configure Mockup Pages
    [Documentation]    Configures mockup pages on the test board by modifying Weston service
    ...    and demo application URLs to point to the test webserver.

    VAR    ${HOME_PAGE}    http://%{TEST_WEBSERVER_IP}:%{TEST_WEBSERVER_PORT}/robot_framework/html/home-page.html
    VAR    ${SEARCH_PAGE}    http://%{TEST_WEBSERVER_IP}:%{TEST_WEBSERVER_PORT}/robot_framework/html/search-page.html

    Configure Weston Service Debug Mode
    Configure Demo Application URLs    ${HOME_PAGE}    ${SEARCH_PAGE}
    SSH Command    %{TEST_BOARD_IP}    systemctl daemon-reload && systemctl restart weston
    Wait Until Keyword Succeeds    20x    1000ms    Remote Weston Check Screenshot    ${HOME_SCREEN_IMAGE}

Configure Weston Service Debug Mode
    [Documentation]    Enables debug mode for Weston service on the test board.

    SSH Command
    ...    %{TEST_BOARD_IP}
    ...    sed -i 's|ExecStart=/usr/bin/weston --modules=systemd-notify.so|ExecStart=/usr/bin/weston --continue-without-input --modules=systemd-notify.so --debug|' /lib/systemd/system/weston.service
    SSH Command
    ...    %{TEST_BOARD_IP}
    ...    sed -i 's|ExecStart=/usr/bin/weston --continue-without-input --modules=systemd-notify.so|ExecStart=/usr/bin/weston --continue-without-input --modules=systemd-notify.so --debug|' /lib/systemd/system/weston.service

Configure Demo Application URLs
    [Documentation]    Updates demo application URLs to point to mockup pages.
    [Arguments]    ${home_page}    ${search_page}

    SSH Command
    ...    %{TEST_BOARD_IP}
    ...    sed -i 's|https://www.wpewebkit.org|${home_page}|g' /usr/bin/demo-wpe-website
    SSH Command
    ...    %{TEST_BOARD_IP}
    ...    sed -i 's|https://duckduckgo.com/|${search_page}|g' /usr/bin/demo-wpe-duckduckgo

Create WPEWebKitOptions
    [Documentation]    Creates and configures WPEWebKit options for WebDriver session.
    [Arguments]    ${binary_name}    ${binary_path}    @{other_params}

    ${wpe_options}    Evaluate    sys.modules['selenium.webdriver'].WPEWebKitOptions()    sys, selenium.webdriver
    ${wpe_options.binary_location}    Set Variable    ${binary_path}
    FOR    ${param}    IN    @{other_params}
        Call Method    ${wpe_options}    add_argument    ${param}
    END
    Call Method    ${wpe_options}    set_capability    browserName    ${binary_name}
    RETURN    ${wpe_options}

Check Device Is IDLE
    [Documentation]    Check if the Device is idle.

    ${stdout}    SSH Command    %{TEST_BOARD_IP}    ps -auxww
    ${formatted}    Evaluate    """${stdout}[0]"""
    Log    ${formatted}

    ${cpu_load}    Get Remote CPU Load
    Log    CPU load: ${cpu_load}
    Should Be True    ${cpu_load} < ${CPU_LOAD_ON_IDLE}

    ${memory_used}    Get Remote Memory Used
    Log    Memory used: ${memory_used}
    Should Be True    ${memory_used} < ${MEMORY_LOAD_ON_IDLE}

Get Remote CPU Load
    [Documentation]    Returns the current 1-minute CPU load average from the test board.
    [Timeout]    30 seconds

    ${stdout}    SSH Command
    ...    %{TEST_BOARD_IP}
    ...    uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}'
    ${value}    Evaluate    float(${stdout}[0])
    RETURN    ${value}

Get Remote Memory Used
    [Documentation]    Returns the amount of used memory in MB on the test board.
    [Timeout]    30 seconds

    ${stdout}    SSH Command    %{TEST_BOARD_IP}    free -m | grep Mem | awk '{print $3}'
    ${value}    Evaluate    float(${stdout}[0])
    RETURN    ${value}

Remote Weston Capture Screenshot
    [Documentation]    Captures a screenshot from Weston compositor and saves it locally.
    [Arguments]    ${capture_name}

    SSH Command
    ...    %{TEST_BOARD_IP}
    ...    rm -rf wayland-screenshot-*.png && export XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-1 && weston-screenshooter
    Run
    ...    scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@%{TEST_BOARD_IP}:~/wayland-screenshot-*.png ${capture_name}
    Log    <img src="${capture_name}" width="50%" />    html

Remote Weston Check Screenshot
    [Documentation]    Captures and compares screenshot against baseline image.
    [Arguments]    ${image}

    Remote Weston Capture Screenshot    ${image}
    Compare Images
    ...    ${BASELINE_IMAGES_PATH}/%{TEST_WPEWEBKIT_VERSION}/${image}
    ...    ${image}
    ...    threshold=0.0050

Remote Weston Check Screenshot Contain Template
    [Documentation]    Verifies that screenshot contains a specific template image.
    [Arguments]    ${template}

    Remote Weston Capture Screenshot    screenshot-${template}
    Image Should Contain Template
    ...    screenshot-${template}
    ...    ${BASELINE_IMAGES_PATH}/%{TEST_WPEWEBKIT_VERSION}/${template}
    ...    take_screenshots=True
    ...    threshold=0.9

Webdriver Remote Start
    [Documentation]    Starts WebDriver session on remote test board with WPE launcher.
    [Arguments]    @{other_params}
    [Timeout]    2 minutes

    # Force kill previous launchers
    SSH Webdriver Remote Stop    %{TEST_BOARD_IP}
    SSH Force Kill    %{TEST_BOARD_IP}    wpe-simple-launcher

    SSH Webdriver Remote Start    %{TEST_BOARD_IP}    %{TEST_BOARD_WEBDRIVER_PORT}
    Sleep    5

    ${wpe_options}    Create WPEWebKitOptions
    ...    wpe-simple-launcher
    ...    /usr/bin/wpe-exported-wayland
    ...    --automation
    ...    @{other_params}
    Create Webdriver
    ...    Remote
    ...    command_executor=%{TEST_BOARD_IP}:%{TEST_BOARD_WEBDRIVER_PORT}
    ...    options=${wpe_options}

Webdriver Remote Start Maximized
    [Documentation]    Starts WebDriver in maximized mode and verifies window dimensions.
    [Arguments]    @{other_params}
    [Timeout]    2 minutes

    VAR    ${PAGE}    http://%{TEST_WEBSERVER_IP}:%{TEST_WEBSERVER_PORT}/robot_framework/html/home-page.html

    Webdriver Remote Start    --maximized
    Go To    ${PAGE}
    Wait Until Page Contains    Home Page    timeout=10s

    ${inner_width}    Execute JavaScript    return window.innerWidth;
    Should Be True    ${inner_width} == 1920
    ${inner_height}    Execute JavaScript    return window.innerHeight;
    Should Be True    ${inner_height} == 1048

Webdriver Remote Stop
    [Documentation]    Stops WebDriver session and cleans up browser processes.
    [Timeout]    2 minutes

    Close All Browsers
    SSH Webdriver Remote Stop    %{TEST_BOARD_IP}
    SSH Force Kill    %{TEST_BOARD_IP}    wpe-simple-launcher
