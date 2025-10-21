*** Settings ***
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

Toggle Gallium HUD
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 1 --steps 1 --delay-on-touch-up 0 535 15 535 15
    Wait Until Keyword Succeeds    20x   1000ms    Remote Weston Check Screenshot Contain Template    ${GALLIUM_HUD_TEMPLATE}
    SSH Command    ${TEST_BOARD_IP}    /root/scripts/touch-one-finger-gesture.py --duration 1 --steps 1 --delay-on-touch-up 0 535 15 535 15
    Wait Until Keyword Succeeds    20x   1000ms    Run Keyword And Expect Error    *Template was not found in the Image.*    Remote Weston Check Screenshot Contain Template    ${GALLIUM_HUD_TEMPLATE}

