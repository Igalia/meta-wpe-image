*** Settings ***

Test Timeout    300 seconds

Suite Setup       Webdriver Remote Start    --maximized
Suite Teardown    Webdriver Remote Stop

Library    SeleniumLibrary

Resource   variables.robot
Resource   keywords_common.robot

*** Keywords ***
Get FPS Value
    ${fps_text}=    Get Text    id=fps
    ${fps}=    Convert To Number    ${fps_text.split(":")[1].strip()}
    RETURN    ${fps}

Get Average Value
    ${average_text}=    Get Text    id=average
    ${average}=    Convert To Number    ${average_text.split(":")[1].strip()}
    RETURN    ${average}

Get Std Deviation Value
    ${std_deviation_text}=    Get Text    id=std-deviation
    ${std_deviation}=    Convert To Number    ${std_deviation_text.split(":")[1].strip()}
    RETURN    ${std_deviation}

*** Test Cases ***
Verify Canvas Animation 60 FPS
    ${TEST_WEBSERVER_IP}    Get Environment Variable    TEST_WEBSERVER_IP
    ${TEST_WEBSERVER_PORT}    Get Environment Variable    TEST_WEBSERVER_PORT
    ${PAGE}    Set Variable    http://${TEST_WEBSERVER_IP}:${TEST_WEBSERVER_PORT}/robot_framework/html/canvas_fps.html

    Go to    ${PAGE}
    Sleep    22 seconds

    ${memory_used}=    Get Remote Memory Used
    Log    Memory used: ${memory_used}

    ${cpu_load}=    Get Remote CPU Load
    Log    CPU load: ${cpu_load}

    ${fps}    Get FPS Value
    Log    FPS value: ${fps}

    ${average}    Get Average Value
    Log    Average value: ${average}

    ${std_deviation}    Get Std Deviation Value
    Log    Std Deviation: ${std_deviation}

    Capture Page Screenshot

    Should Be True    ${fps} > ${CANVAS_FPS_THRESHOLD_FPS}
    Should Be True    ${average} > ${CANVAS_FPS_THRESHOLD_AVERAGE}
    Should Be True    ${std_deviation} < ${CANVAS_FPS_THRESHOLD_STD_DEVIATION}
    Should Be True    ${cpu_load} < ${CANVAS_FPS_THRESHOLD_CPU_LOAD}
    Should Be True    ${memory_used} < ${CANVAS_FPS_THRESHOLD_MEMORY_USED}

