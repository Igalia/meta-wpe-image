*** Settings ***
Test Timeout    60 seconds

Suite Setup       Wait Until Keyword Succeeds    20x   1000ms    Webdriver Remote Start Maximized
Suite Teardown    Webdriver Remote Stop

Library    Collections
Library    DocTest.VisualTest
Library    OperatingSystem
Library    SeleniumLibrary
Library    ../libs/TestUtils.py

Resource   variables.robot
Resource   keywords_touch_events.robot

*** Test Cases ***
Test Check Browser Imprecise Touch Event Using Uinput
    Check Browser Imprecise Touch Event Using Uinput

Test Check Browser Touch Events Using Uinput
    [Tags]    ignoreonfail
    Check Browser Touch Events Using Uinput

