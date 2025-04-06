*** Settings ***

Test Timeout    300 seconds

Suite Setup       Wait Until Keyword Succeeds    20x   1000ms    Webdriver Remote Start Maximized
Suite Teardown    Webdriver Remote Stop

Library    SeleniumLibrary

Resource   variables.robot
Resource   keywords_common.robot

*** Keywords ***
Get FPS Value
    ${fps_text}=    Get Text    id=fps
    ${fps}=    Convert To Number    ${fps_text.split(":")[1].strip()}
    RETURN    ${fps}

*** Test Cases ***
Verify Full HD 30 FPS
    ${TEST_WEBSERVER_IP}    Get Environment Variable    TEST_WEBSERVER_IP
    ${TEST_WEBSERVER_PORT}    Get Environment Variable    TEST_WEBSERVER_PORT
    ${PAGE}    Set Variable    http://${TEST_WEBSERVER_IP}:${TEST_WEBSERVER_PORT}/robot_framework/html/video_fps.html

    Go to    ${PAGE}
    Sleep    20 seconds

    ${memory_used}=    Get Remote Memory Used
    Log    Memory used: ${memory_used}

    ${cpu_load}=    Get Remote CPU Load
    Log    CPU load: ${cpu_load}

    ${fps}    Get FPS Value
    Log    FPS value: ${fps}

    Capture Page Screenshot

    Should Be True    ${fps} > ${VIDEO_30_FPS_THRESHOLD_FPS}
    Should Be True    ${cpu_load} < ${VIDEO_30_FPS_THRESHOLD_CPU_LOAD}
    Should Be True    ${memory_used} < ${VIDEO_30_FPS_THRESHOLD_MEMORY_USED}

