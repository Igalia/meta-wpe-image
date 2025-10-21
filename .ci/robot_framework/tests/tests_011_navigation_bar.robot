*** Settings ***
Test Timeout    120 seconds

Suite Setup    Configure Mockup Pages

Resource   keywords_touch_navigation.robot

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
    Toggle Gallium HUD
