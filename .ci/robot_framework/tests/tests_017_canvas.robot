*** Settings ***
Documentation       Canvas animation performance (FPS, CPU, memory) on different machines and WPEWebKit versions.

Library             SeleniumLibrary
Resource            variables.robot
Resource            keywords_common.robot

Suite Setup         Wait For Webdriver Remote Start Maximized
Suite Teardown      Webdriver Remote Stop
Test Timeout        300 seconds


*** Test Cases ***
Verify Canvas Animation 60 FPS
    [Documentation]    Verifies that canvas animation runs at 60 FPS with acceptable CPU and memory usage.
    [Tags]    test:retry(1)

    VAR    ${PAGE}    http://%{TEST_WEBSERVER_IP}:%{TEST_WEBSERVER_PORT}/robot_framework/html/canvas_fps.html

    Go To    ${PAGE}
    Sleep    22 seconds

    ${memory_used}=    Get Remote Memory Used
    Log    Memory used: ${memory_used}

    ${cpu_load}=    Get Remote CPU Load
    Log    CPU load: ${cpu_load}

    ${fps}=    Get FPS Value
    Log    FPS value: ${fps}

    ${average}=    Get Average Value
    Log    Average value: ${average}

    ${std_deviation}=    Get Std Deviation Value
    Log    Std Deviation: ${std_deviation}

    Capture Page Screenshot

    ${CANVAS_FPS_THRESHOLD_FPS}=    Get Machine Expectation
    ...    id=canvas-fps-threshold-fps
    ...    machine=%{TEST_MACHINE}
    ...    wpeversion=%{TEST_WPEWEBKIT_VERSION}
    ...    type=number
    Should Be True    ${fps} > ${CANVAS_FPS_THRESHOLD_FPS}
    ${CANVAS_FPS_THRESHOLD_AVERAGE}=    Get Machine Expectation
    ...    id=canvas-fps-threshold-average
    ...    machine=%{TEST_MACHINE}
    ...    wpeversion=%{TEST_WPEWEBKIT_VERSION}
    ...    type=number
    Should Be True    ${average} < ${CANVAS_FPS_THRESHOLD_AVERAGE}
    ${CANVAS_FPS_THRESHOLD_STD_DEVIATION}=    Get Machine Expectation
    ...    id=canvas-fps-threshold-std-deviation
    ...    machine=%{TEST_MACHINE}
    ...    wpeversion=%{TEST_WPEWEBKIT_VERSION}
    ...    type=number
    Should Be True    ${std_deviation} < ${CANVAS_FPS_THRESHOLD_STD_DEVIATION}
    ${CANVAS_FPS_THRESHOLD_CPU_LOAD}=    Get Machine Expectation
    ...    id=canvas-fps-threshold-cpu-load
    ...    machine=%{TEST_MACHINE}
    ...    wpeversion=%{TEST_WPEWEBKIT_VERSION}
    ...    type=number
    Should Be True    ${cpu_load} < ${CANVAS_FPS_THRESHOLD_CPU_LOAD}
    ${CANVAS_FPS_THRESHOLD_MEMORY_USED}=    Get Machine Expectation
    ...    id=canvas-fps-threshold-memory-used
    ...    machine=%{TEST_MACHINE}
    ...    wpeversion=%{TEST_WPEWEBKIT_VERSION}
    ...    type=number
    Should Be True    ${memory_used} < ${CANVAS_FPS_THRESHOLD_MEMORY_USED}


*** Keywords ***
Get FPS Value
    [Documentation]    Returns the current FPS value from the page.
    ${fps_text}=    SeleniumLibrary.Get Text    id=fps
    ${fps}=    Convert To Number    ${fps_text.split(":")[1].strip()}
    RETURN    ${fps}

Get Average Value
    [Documentation]    Returns the average FPS value from the page.
    ${average_text}=    SeleniumLibrary.Get Text    id=average
    ${average}=    Convert To Number    ${average_text.split(":")[1].strip()}
    RETURN    ${average}

Get Std Deviation Value
    [Documentation]    Returns the standard deviation of FPS from the page.
    ${std_deviation_text}=    SeleniumLibrary.Get Text    id=std-deviation
    ${std_deviation}=    Convert To Number    ${std_deviation_text.split(":")[1].strip()}
    RETURN    ${std_deviation}

Wait For Webdriver Remote Start Maximized
    Wait Until Keyword Succeeds    18x    10s    Check Device Is IDLE
    Wait Until Keyword Succeeds    20x    1000ms    Webdriver Remote Start Maximized
