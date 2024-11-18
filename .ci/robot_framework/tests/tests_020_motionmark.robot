*** Variables ***
${URL}            https://browserbench.org/MotionMark1.2/
${RUN_BENCHMARK_BUTTON}   xpath=//*[@id="intro"]/div[2]/button
${SCORE_SELECTOR}        xpath=//*[@id="results"]/div[2]/div[1]/div[1]
${TEST_AGAIN_BUTTON}     xpath=//button[contains(@onclick, 'benchmarkController.startBenchmark()') and contains(text(), 'Test Again')]

*** Settings ***

Test Timeout      10 minutes

Suite Setup       Webdriver Remote Start
Suite Teardown    Webdriver Remote Stop
Suite Timeout     15 minutes

Library    SeleniumLibrary

Resource   variables.robot
Resource   keywords_common.robot

*** Keywords ***
Capture Images Until Test Completion
    [Documentation]    Captures a screenshot each time a new test section loads until the "Test Again" button appears.

    ${index}=    Set Variable    1
    WHILE    "True"
        Sleep    20s
        Capture Page Screenshot    motionmark_test_${index}.png
        ${index}=    Evaluate    ${index} + 1

        Run Keyword And Ignore Error    Element Should Be Visible    ${TEST_AGAIN_BUTTON}
        ${is_test_again_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${TEST_AGAIN_BUTTON}
        Run Keyword If    ${is_test_again_visible}    Exit For Loop
    END

*** Test Cases ***
Run MotionMark Benchmark And Validate Score
    [Documentation]    Loads MotionMark benchmark, runs it, waits for the score, and validates.

    Go to    ${URL}
    Wait Until Page Contains Element    ${RUN_BENCHMARK_BUTTON}
    Click Element    ${RUN_BENCHMARK_BUTTON}

    Capture Images Until Test Completion

    Wait Until Page Contains Element    ${TEST_AGAIN_BUTTON}    timeout=600s
    Capture Page Screenshot
    ${score}=    Get Text    ${SCORE_SELECTOR}
    Log    MotionMark Score : ${score}
    Should Be True    ${score} > ${MOTIONMARK_MIN_SCORE}

