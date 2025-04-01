*** Variables ***
${SCROLL_MAX_POSITION}    10000
${SCROLL_POSITION}    745
${SCROLL_THRESHOLD}    8
${SWIPE_POSITION}   2650
${SWIPE_THRESHOLD}    350

${BASELINE_IMAGES_PATH}    /app/robot_framework/images/
${PINCH_GESTURE_IMAGE}    pinch-gesture.png
${ZOOM_GESTURE_IMAGE}    zoom-gesture.png

*** Settings ***
Library    DocTest.VisualTest
Library    OperatingSystem
Library    ../libs/TestUtils.py

Resource   variables.robot
Resource   keywords_common.robot

*** Keywords ***

Check Window Result Value
    [Arguments]    ${expectation}
    Capture Page Screenshot
    ${result}=    Execute JavaScript    return window.result;
    Should Be Equal As Strings     ${result}   ${expectation}

Check Window PageYOffset Value
    [Arguments]    ${expectation_equal_or_bigger_than}    ${expectation_equal_or_less_than}
    Capture Page Screenshot
    ${scroll_position}=    Execute JavaScript    return window.pageYOffset;
    Should Be True    ${scroll_position} >= ${expectation_equal_or_bigger_than}
    Should Be True    ${scroll_position} <= ${expectation_equal_or_less_than}

Check Browser Imprecise Touch Event Using Uinput
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${TEST_WEBSERVER_IP}    Get Environment Variable    TEST_WEBSERVER_IP
    ${TEST_WEBSERVER_PORT}    Get Environment Variable    TEST_WEBSERVER_PORT
    ${TEST_WPEWEBKIT_VERSION}    Get Environment Variable    TEST_WPEWEBKIT_VERSION
    ${PAGE}    Set Variable    http://${TEST_WEBSERVER_IP}:${TEST_WEBSERVER_PORT}/robot_framework/html/test_button_click.html

    Go to    ${PAGE}
    Capture Page Screenshot

    # Press button: Valid
    Go to    ${PAGE}
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/emit-button-touch-event.py 75 75
    Wait Until Keyword Succeeds    10x   1000ms    Check Window Result Value    green

    # Press button: Not valid
    Go to    ${PAGE}
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/emit-button-touch-event.py 200 200 20 0
    Wait Until Keyword Succeeds    10x   1000ms    Check Window Result Value    white

    # Press button: Not valid
    Go to    ${PAGE}
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/emit-button-touch-event.py 200 200 0 20
    Wait Until Keyword Succeeds    10x   1000ms    Check Window Result Value    white

Check Browser Touch Events Using Uinput
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${TEST_WEBSERVER_IP}    Get Environment Variable    TEST_WEBSERVER_IP
    ${TEST_WEBSERVER_PORT}    Get Environment Variable    TEST_WEBSERVER_PORT
    ${TEST_WPEWEBKIT_VERSION}    Get Environment Variable    TEST_WPEWEBKIT_VERSION
    ${PAGE}    Set Variable    http://${TEST_WEBSERVER_IP}:${TEST_WEBSERVER_PORT}/robot_framework/html/vertical_scroll.html
    ${PAGE2}    Set Variable    http://${TEST_WEBSERVER_IP}:${TEST_WEBSERVER_PORT}/robot_framework/html/rbyers/paint.html

    Go to    ${PAGE}
    Capture Page Screenshot

    # Scroll
    ${scroll_lower_position}=    Set Variable    ${SCROLL_POSITION} - ${SCROLL_THRESHOLD}
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 5 --steps 40 --delay-on-touch-up 0 100 500 100 200
    Wait Until Keyword Succeeds    5x   3000ms    Check Window PageYOffset Value    ${scroll_lower_position}    ${SCROLL_MAX_POSITION}

    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 5 --steps 40 --delay-on-touch-up 0 100 200 100 500
    Wait Until Keyword Succeeds    5x   3000ms    Check Window PageYOffset Value    0    ${SCROLL_THRESHOLD}

    # Swipe
    Capture Page Screenshot

    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 0.1 --steps 40 --delay-on-touch-up 0 100 500 100 200
    ${swipe_upper_position}=    Set Variable    ${SWIPE_POSITION} - ${SWIPE_THRESHOLD}
    Wait Until Keyword Succeeds    5x   3000ms    Check Window PageYOffset Value    ${swipe_upper_position}    ${SCROLL_MAX_POSITION}

    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 0.1 --steps 40 --delay-on-touch-up 0 100 200 100 500
    Wait Until Keyword Succeeds    5x   3000ms    Check Window PageYOffset Value    0    ${SWIPE_THRESHOLD}

    # Multitouch: Pinch
    Go to    ${PAGE2}
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-two-fingers-gesture.py --duration 2 --steps 40 900 200 900 500 900 800 900 500
    Capture Page Screenshot    ${PINCH_GESTURE_IMAGE}
    Wait Until Keyword Succeeds    10x   1000ms    Compare Images   ${BASELINE_IMAGES_PATH}/${TEST_WPEWEBKIT_VERSION}/${PINCH_GESTURE_IMAGE}    ${PINCH_GESTURE_IMAGE}    threshold=0.0005

    # Multitouch: Zoom
    Go to    ${PAGE2}
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-two-fingers-gesture.py --duration 2 --steps 40 900 500 900 200 900 500 900 800
    Capture Page Screenshot    ${ZOOM_GESTURE_IMAGE}
    Wait Until Keyword Succeeds    10x   1000ms    Compare Images   ${BASELINE_IMAGES_PATH}/${TEST_WPEWEBKIT_VERSION}/${ZOOM_GESTURE_IMAGE}    ${ZOOM_GESTURE_IMAGE}    threshold=0.0005

