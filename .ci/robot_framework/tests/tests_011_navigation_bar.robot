*** Settings ***
Test Timeout    120 seconds

Suite Setup    Configure Mockup Pages

Library    ../libs/TestUtils.py

Resource   variables.robot
Resource   keywords_common.robot

*** Keywords ***
Browser Reload
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 1 --steps 1 --delay-on-touch-up 0 470 15 470 15
    Wait Until Keyword Succeeds    20x   1000ms    Remote Weston Check Screenshot    ${SEARCH_SCREEN_IMAGE}

Click On Search Link In Home
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 0.2 --steps 2 --delay-on-touch-up 0 90 160 90 160
    Wait Until Keyword Succeeds    20x   1000ms    Remote Weston Check Screenshot    ${SEARCH_SCREEN_IMAGE}

Configure Mockup Pages
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${TEST_WEBSERVER_IP}    Get Environment Variable    TEST_WEBSERVER_IP
    ${TEST_WEBSERVER_PORT}    Get Environment Variable    TEST_WEBSERVER_PORT
    ${HOME_PAGE}    Set Variable    http://${TEST_WEBSERVER_IP}:${TEST_WEBSERVER_PORT}/robot_framework/html/home-page.html
    ${SEARCH_PAGE}    Set Variable    http://${TEST_WEBSERVER_IP}:${TEST_WEBSERVER_PORT}/robot_framework/html/search-page.html

    SSH Command    ${TEST_BOARD_IP}    sed -i 's|ExecStart=/usr/bin/weston --modules=systemd-notify.so|ExecStart=/usr/bin/weston --continue-without-input --modules=systemd-notify.so --debug|' /lib/systemd/system/weston.service
    SSH Command    ${TEST_BOARD_IP}    sed -i 's|ExecStart=/usr/bin/weston --continue-without-input --modules=systemd-notify.so|ExecStart=/usr/bin/weston --continue-without-input --modules=systemd-notify.so --debug|' /lib/systemd/system/weston.service
    SSH Command    ${TEST_BOARD_IP}    sed -i 's|https://www.wpewebkit.org|${HOME_PAGE}|g' /usr/bin/demo-wpe-website
    SSH Command    ${TEST_BOARD_IP}    sed -i 's|https://duckduckgo.com/|${SEARCH_PAGE}|g' /usr/bin/demo-wpe-duckduckgo
    SSH Command    ${TEST_BOARD_IP}    systemctl daemon-reload && systemctl restart weston
    Wait Until Keyword Succeeds    20x   1000ms    Remote Weston Check Screenshot    ${HOME_SCREEN_IMAGE}

Open Home
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 1 --steps 1 --delay-on-touch-up 0 215 15 215 15
    Wait Until Keyword Succeeds    20x   1000ms    Remote Weston Check Screenshot    ${HOME_SCREEN_IMAGE}

Open Search
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    SSH Command    ${TEST_BOARD_IP}   /root/scripts/touch-one-finger-gesture.py --duration 1 --steps 1 --delay-on-touch-up 0 275 15 275 15
    Wait Until Keyword Succeeds    20x   1000ms    Remote Weston Check Screenshot    ${SEARCH_SCREEN_IMAGE}

Navigation Back
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 1 --steps 1 --delay-on-touch-up 0 345 15 345 15
    Wait Until Keyword Succeeds    20x   1000ms    Remote Weston Check Screenshot    ${HOME_SCREEN_IMAGE}

Navigation Forward
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 1 --steps 1 --delay-on-touch-up 0 400 15 400 15
    Wait Until Keyword Succeeds    20x   1000ms    Remote Weston Check Screenshot    ${SEARCH_SCREEN_IMAGE}

Terminate Browser
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 1 --steps 1 --delay-on-touch-up 0 595 15 595 15
    Wait Until Keyword Succeeds    20x   1000ms    Remote Weston Check Screenshot    ${INIT_SCREEN_IMAGE}

Toggle Fullscreen
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/keyboard-input-special-keys.py f11
    Wait Until Keyword Succeeds    20x   1000ms    Remote Weston Check Screenshot    ${FULL_HOME_SCREEN_IMAGE}
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/keyboard-input-special-keys.py f11
    Wait Until Keyword Succeeds    20x   1000ms    Remote Weston Check Screenshot    ${HOME_SCREEN_IMAGE}

*** Test Cases ***
Test Check Navigation Bar
    [Tags]    test:retry(0)

    Terminate Browser
    Open Home
    Toggle Fullscreen
    Click On Search Link In Home
    Navigation Back
    Navigation Forward
    Browser Reload
    Navigation Back
    Open Search
    Terminate Browser
