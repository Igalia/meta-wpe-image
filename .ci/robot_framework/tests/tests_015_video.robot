*** Settings ***
Library             SeleniumLibrary
Resource            variables.robot
Resource            keywords_common.robot

Suite Setup         Wait Until Keyword Succeeds    20x    1000ms    Wait For Webdriver Remote Start Maximized
Suite Teardown      Webdriver Remote Stop
Test Timeout        300 seconds


*** Test Cases ***
Verify Full HD 30 FPS
    VAR    ${PAGE}    Set Variable    http://%{TEST_WEBSERVER_IP}:%{TEST_WEBSERVER_PORT}/robot_framework/html/video_fps.html

    Go To    ${PAGE}
    Sleep    20 seconds

    ${VIDEO_30_FPS_THRESHOLD_FPS}=    Get Machine Expectation
    ...    id=video-30-fps-threshold-fps
    ...    machine=%{TEST_MACHINE}
    ...    wpeversion=%{TEST_WPEWEBKIT_VERSION}

    ${VIDEO_30_FPS_THRESHOLD_CPU_LOAD}=    Get Machine Expectation
    ...    id=video-30-fps-threshold-cpu-load
    ...    machine=%{TEST_MACHINE}
    ...    wpeversion=%{TEST_WPEWEBKIT_VERSION}

    ${VIDEO_30_FPS_THRESHOLD_MEMORY_USED}=    Get Machine Expectation
    ...    id=video-30-fps-threshold-memory-used
    ...    machine=%{TEST_MACHINE}
    ...    wpeversion=%{TEST_WPEWEBKIT_VERSION}

    ${memory_used}=    Get Remote Memory Used
    Log    Memory used: ${memory_used}

    ${cpu_load}=    Get Remote CPU Load
    Log    CPU load: ${cpu_load}

    ${fps}=    Get FPS Value
    Log    FPS value: ${fps}

    Capture Page Screenshot

    Should Be True    ${fps} > ${VIDEO_30_FPS_THRESHOLD_FPS}
    Should Be True    ${cpu_load} < ${VIDEO_30_FPS_THRESHOLD_CPU_LOAD}
    Should Be True    ${memory_used} < ${VIDEO_30_FPS_THRESHOLD_MEMORY_USED}


*** Keywords ***
Get FPS Value
    ${fps_text}=    SeleniumLibrary.Get Text    id=fps
    ${fps}=    Convert To Number    ${fps_text.split(":")[1].strip()}
    RETURN    ${fps}

Wait For Webdriver Remote Start Maximized
    Wait Until Keyword Succeeds    18x    10s    Check Device Is IDLE
    Wait Until Keyword Succeeds    20x    1000ms    Webdriver Remote Start Maximized
