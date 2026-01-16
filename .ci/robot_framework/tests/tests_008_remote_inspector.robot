*** Variables ***
${REMOTE_INSPECTOR_ELEMENTS_COLLAPSED_ACTIVE}     remote-inspector-elements-collapsed-active.png
${REMOTE_INSPECTOR_ELEMENTS_EXPANDED_INACTIVE}    remote-inspector-elements-expanded-inactive.png
${REMOTE_INSPECTOR_ELEMENTS_EXPANDED_ACTIVE}      remote-inspector-elements-expanded-active.png
${REMOTE_INSPECTOR_HOME}                          remote-inspector-home.png
${REMOTE_INSPECTOR_SOURCES}                       remote-inspector-sources.png
${REMOTE_INSPECTOR_TIMELINES}                     remote-inspector-timelines.png

*** Settings ***
Test Timeout    120 seconds

Suite Setup    Configure Mockup Pages

Library    DocTest.VisualTest
Library    SeleniumLibrary

Resource   variables.robot
Resource   keywords_common.robot

*** Test Cases ***
Validate Remote Inspector Functionality
    [Documentation]    Connects to a running WebKit remote inspector and validates its basic UI functions.
    [Tags]    test:retry(0)
    [Setup]    Setup Validate Remote Inspector Functionality

    Verify Inspector

    [Teardown]    Teardown Validate Remote Inspector Functionality

*** Keywords ***
Setup Validate Remote Inspector Functionality
    Kill Demo
    Launch Demo WPE Website With HTTP Remote Inspector Enabled
    Connect To Remote Inspector

Teardown Validate Remote Inspector Functionality
    Close Browser
    Kill Demo

Launch Demo WPE Website With HTTP Remote Inspector Enabled
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${TEST_WEBKIT_INSPECTOR_HTTP_SERVER_PORT}    Get Environment Variable    TEST_WEBKIT_INSPECTOR_HTTP_SERVER_PORT
    SSH Command In Background    ${TEST_BOARD_IP}    export WEBKIT_INSPECTOR_HTTP_SERVER=0.0.0.0:${TEST_WEBKIT_INSPECTOR_HTTP_SERVER_PORT} && /usr/bin/demo-wpe-website

Kill Demo
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    SSH Command In Background    ${TEST_BOARD_IP}    /usr/bin/kill-demo

Create ChromiumOptions
    [Arguments]    @{params}

    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    FOR    ${param}    IN    @{params}
        Call Method    ${options}    add_argument    ${param}
    END
    RETURN    ${options}

Connect To Remote Inspector
    [Documentation]    Opens a browser and navigates to the remote inspector URL.
    ${TEST_BOARD_IP}    Get Environment Variable    TEST_BOARD_IP
    ${TEST_WEBKIT_INSPECTOR_HTTP_SERVER_PORT}    Get Environment Variable    TEST_WEBKIT_INSPECTOR_HTTP_SERVER_PORT
    ${TEST_WPEWEBKIT_VERSION}    Get Environment Variable    TEST_WPEWEBKIT_VERSION
    ${REMOTE_INSPECTOR_URL}    Set Variable    http://${TEST_BOARD_IP}:${TEST_WEBKIT_INSPECTOR_HTTP_SERVER_PORT}

    Log    Connecting to remote inspector at ${REMOTE_INSPECTOR_URL}

    ${chromium_options}    Create ChromiumOptions
    ...    --headless
    ...    --user-data-dir=/tmp/user-data
    ...    --no-sandbox

    Create Webdriver    Chrome    options=${chromium_options}

    Go To    url=${REMOTE_INSPECTOR_URL}
    Maximize Browser Window

    Wait Until Page Contains    Home Page    timeout=15s
    Wait Until Element Is Visible    xpath=//*[@id="targetlist"]/table/tbody/tr/td[1]/div[1]    timeout=5s

    Go To    http://${TEST_BOARD_IP}:${TEST_WEBKIT_INSPECTOR_HTTP_SERVER_PORT}/Main.html?ws=${TEST_BOARD_IP}:${TEST_WEBKIT_INSPECTOR_HTTP_SERVER_PORT}/socket/1/1/WebPage
    Wait Until Element Is Visible    xpath=//*[@id="main"]    timeout=5s

Capture And Compare
    [Arguments]    ${image}
    ${TEST_WPEWEBKIT_VERSION}    Get Environment Variable    TEST_WPEWEBKIT_VERSION
    Capture Page Screenshot    ${image}
    Compare Images    ${BASELINE_IMAGES_PATH}/${TEST_WPEWEBKIT_VERSION}/${image}    ${image}    threshold=0.0015

Verify Inspector
    [Documentation]    Checks that inspector tabs can be clicked. Locators may need adjustment.

    Log    Verifying navigation between inspector tabs...

    Wait Until Keyword Succeeds    10x   1000ms    Capture And Compare    ${REMOTE_INSPECTOR_HOME}

    Log    Click on Timelines tab
    Click Element    xpath=//*[@id="tab-bar"]/div[3]/div[5]/span/span
    Wait Until Keyword Succeeds    10x   1000ms    Capture And Compare    ${REMOTE_INSPECTOR_TIMELINES}

    Log    Click on Sources tab
    Click Element    xpath=//*[@id="tab-bar"]/div[3]/div[3]/span/span
    Wait Until Keyword Succeeds    10x   1000ms    Capture And Compare    ${REMOTE_INSPECTOR_SOURCES}

    Log   Click on Elements tab
    Click Element    xpath=//*[@id="tab-bar"]/div[3]/div[1]/span/span
    Wait Until Keyword Succeeds    10x   1000ms    Capture And Compare    ${REMOTE_INSPECTOR_ELEMENTS_EXPANDED_INACTIVE}

    Log    Successfully navigated between tabs.

    Log    Click on body element and verify is spandable
    Double Click Element    xpath=//*[@id="tab-browser"]/div/div/div/div[2]/div/ol/ol/li[2]/span/span/span
    Wait Until Keyword Succeeds    10x   1000ms    Capture And Compare    ${REMOTE_INSPECTOR_ELEMENTS_EXPANDED_ACTIVE}

    Log    Reload remote content
    Click Element    xpath=//*[@id="tab-bar"]/div[2]/div[1]/div[3]/div
    Wait Until Keyword Succeeds    10x   1000ms    Capture And Compare    ${REMOTE_INSPECTOR_ELEMENTS_COLLAPSED_ACTIVE}

    Log    Click on body element and verify is spandable again
    Double Click Element    xpath=//*[@id="tab-browser"]/div/div/div/div[2]/div/ol/ol/li[2]/span/span/span
    Wait Until Keyword Succeeds    10x   1000ms    Capture And Compare    ${REMOTE_INSPECTOR_ELEMENTS_EXPANDED_ACTIVE}

