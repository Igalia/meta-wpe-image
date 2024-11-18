*** Variables ***
${BASELINE_IMAGES_PATH}    /app/robot_framework/images/
${GLYPHS_PAGE_IMAGE}    glyphs.png

*** Settings ***
Test Timeout    30 seconds

Suite Setup       Webdriver Remote Start
Suite Teardown    Webdriver Remote Stop
Suite Timeout     5 minutes

Library    DocTest.VisualTest
Library    SeleniumLibrary

Resource   variables.robot
Resource   keywords_common.robot

*** Test Cases ***
Verify no changes in the glyphs
    ${TEST_WEBSERVER_IP}    Get Environment Variable    TEST_WEBSERVER_IP
    ${TEST_WEBSERVER_PORT}    Get Environment Variable    TEST_WEBSERVER_PORT
    ${PAGE}    Set Variable    http://${TEST_WEBSERVER_IP}:${TEST_WEBSERVER_PORT}/robot_framework/html/glyphs.html

    Go to    ${PAGE}
    Wait Until Page Contains    Ready    timeout=10s

    Capture Page Screenshot    ${GLYPHS_PAGE_IMAGE}
    Compare Images   ${BASELINE_IMAGES_PATH}/${GLYPHS_PAGE_IMAGE}    ${GLYPHS_PAGE_IMAGE}    threshold=0.0005

